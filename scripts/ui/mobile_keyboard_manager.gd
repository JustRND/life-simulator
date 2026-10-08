class_name MobileKeyboardManager
extends Node

## MobileKeyboardManager
## Automatically detects mobile devices (Android, iOS) and mobile web browsers (Chrome, Safari, etc.)
## ensuring that tapping on ANY LineEdit or TextEdit reliably triggers the virtual keyboard.

const PROMPT_CANCEL_SENTINEL := "___CANCELLED___"

static var _instance: MobileKeyboardManager = null


func _ready() -> void:
	_instance = self
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Listen for any new LineEdit or TextEdit nodes added to the scene tree dynamically
	get_tree().node_added.connect(_on_node_added)

	# Scan existing scene tree deferred so everything is ready
	_scan_tree.call_deferred(get_tree().root)


func _on_node_added(node: Node) -> void:
	if node is LineEdit or node is TextEdit:
		attach_to_input(node as Control)


func _scan_tree(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		return
	if node is LineEdit or node is TextEdit:
		attach_to_input(node as Control)
	for child in node.get_children():
		_scan_tree(child)


## Determines if the game is running on a mobile device (native Android/iOS or mobile web browser)
static func is_mobile() -> bool:
	if OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		return true
	if is_mobile_web():
		return true
	return false


## Specifically detects mobile browsers (iOS Safari, Android Chrome, tablet touchscreens) via JavaScriptBridge
static func is_mobile_web() -> bool:
	if not OS.has_feature("web"):
		return false
	if not OS.has_feature("JavaScript"):
		return false
	var res = JavaScriptBridge.eval("""
		Boolean(
			/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|Mobile/i.test(navigator.userAgent) ||
			(navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1) ||
			(window.matchMedia && window.matchMedia('(pointer: coarse)').matches)
		)
	""")
	return bool(res)


## Attaches mobile keyboard triggering behavior to any LineEdit or TextEdit control
static func attach_to_input(input_ctrl: Control, prompt_title: String = "") -> void:
	if input_ctrl == null or not is_instance_valid(input_ctrl):
		return
	if input_ctrl.has_meta("mobile_kb_attached"):
		if not prompt_title.is_empty():
			input_ctrl.set_meta("mobile_kb_prompt_title", prompt_title)
		return

	input_ctrl.set_meta("mobile_kb_attached", true)
	if not prompt_title.is_empty():
		input_ctrl.set_meta("mobile_kb_prompt_title", prompt_title)

	if input_ctrl is LineEdit:
		var le := input_ctrl as LineEdit
		le.virtual_keyboard_enabled = true
		le.focus_mode = Control.FOCUS_ALL

	# Connect gui_input to capture direct screen touches and clicks
	input_ctrl.gui_input.connect(func(event: InputEvent):
		if event is InputEventScreenTouch:
			var st := event as InputEventScreenTouch
			if not st.pressed:
				open_keyboard(input_ctrl, input_ctrl.get_meta("mobile_kb_prompt_title", ""))
		elif event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.button_index == MOUSE_BUTTON_LEFT and not mb.pressed:
				# On mobile web browsers, screen touches are often emulated as mouse button releases
				if is_mobile():
					open_keyboard(input_ctrl, input_ctrl.get_meta("mobile_kb_prompt_title", ""))
	)

	# Connect focus_entered to trigger keyboard whenever the input gains focus
	input_ctrl.focus_entered.connect(func():
		if is_mobile():
			open_keyboard(input_ctrl, input_ctrl.get_meta("mobile_kb_prompt_title", ""))
	)


## Opens the virtual keyboard for the target input control
static func open_keyboard(input_ctrl: Control, prompt_override: String = "") -> void:
	if input_ctrl == null or not is_instance_valid(input_ctrl):
		return

	# Debounce within 350ms to prevent double-firing
	var now := Time.get_ticks_msec()
	var last_open: int = int(input_ctrl.get_meta("last_kb_open_time", 0))
	if (now - last_open) < 350:
		return
	input_ctrl.set_meta("last_kb_open_time", now)

	# Ensure control has focus
	if not input_ctrl.has_focus() and input_ctrl.focus_mode != Control.FOCUS_NONE:
		input_ctrl.grab_focus()

	var current_text := ""
	var max_len := -1
	if input_ctrl is LineEdit:
		var le := input_ctrl as LineEdit
		current_text = le.text
		max_len = le.max_length
	elif input_ctrl is TextEdit:
		var te := input_ctrl as TextEdit
		current_text = te.text

	# 1. Native DisplayServer virtual keyboard call (handles native Android/iOS and Godot Web experimentalVK)
	if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		DisplayServer.virtual_keyboard_show(current_text, input_ctrl.get_global_rect(), DisplayServer.KEYBOARD_TYPE_DEFAULT, max_len)

	# 2. Web Mobile Browser Support (iOS Safari, Android Chrome, Samsung Internet)
	# On mobile browsers, HTML5 canvas elements cannot summon the OS virtual keyboard without a native DOM prompt or input
	if is_mobile_web():
		_prompt_mobile_web(input_ctrl, prompt_override, current_text)


## Prompts the user via native browser modal on mobile web, guaranteeing the OS virtual keyboard appears
static func _prompt_mobile_web(input_ctrl: Control, prompt_override: String, current_val: String) -> void:
	if not OS.has_feature("web") or not OS.has_feature("JavaScript"):
		return

	var prompt_title := prompt_override
	if prompt_title.is_empty():
		prompt_title = str(input_ctrl.get_meta("mobile_kb_prompt_title", ""))

	if prompt_title.is_empty():
		if input_ctrl is LineEdit:
			var le := input_ctrl as LineEdit
			if not le.placeholder_text.is_empty():
				prompt_title = le.placeholder_text
			elif le.name == "NameInput":
				prompt_title = "What is your name?"
			elif le.name == "ShareQuantityInput":
				prompt_title = "Enter share quantity:"
			else:
				prompt_title = "Enter " + le.name.capitalize()
		elif input_ctrl is TextEdit:
			prompt_title = "Enter text:"

	if prompt_title.is_empty():
		prompt_title = "Enter text:"

	var js_eval := """
		(function() {
			var title = %s;
			var def = %s;
			if (typeof window.godotPromptInput === 'function') {
				return window.godotPromptInput(title, def);
			}
			var res = window.prompt(title, def);
			return res !== null ? res : '%s';
		})()
	""" % [JSON.stringify(prompt_title), JSON.stringify(current_val), PROMPT_CANCEL_SENTINEL]

	var res = JavaScriptBridge.eval(js_eval)
	if res != null:
		var res_str := str(res)
		if res_str != PROMPT_CANCEL_SENTINEL and res_str != "null":
			if input_ctrl is LineEdit:
				var le := input_ctrl as LineEdit
				if le.max_length > 0 and res_str.length() > le.max_length:
					res_str = res_str.substr(0, le.max_length)
				le.text = res_str
				le.text_changed.emit(res_str)
				le.text_submitted.emit(res_str)
				# Auto-normalize names if this is a character name field
				if le.name == "NameInput" or le.get_meta("is_name_input", false):
					var CreationOptionsRef = load("res://scripts/core/creation_options.gd")
					if CreationOptionsRef != null:
						le.text = CreationOptionsRef.normalize_name(le.text)
			elif input_ctrl is TextEdit:
				var te := input_ctrl as TextEdit
				te.text = res_str
				te.text_changed.emit()
