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
	var os_name := OS.get_name().to_lower()
	if os_name == "android" or os_name == "ios":
		return true
	if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		return true
	if DisplayServer.is_touchscreen_available():
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
			(navigator.maxTouchPoints && navigator.maxTouchPoints > 0) ||
			(window.matchMedia && (window.matchMedia('(pointer: coarse)').matches || window.matchMedia('(hover: none)').matches)) ||
			('ontouchstart' in window)
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


## Creates a styled cyber button dedicated to triggering mobile keyboard input for a specific input field
static func create_keyboard_trigger_button(input_ctrl: Control, button_title: String = "⌨️ Type Custom Value", prompt_title: String = "", btn_color: Color = Color("#00f0ff")) -> Button:
	var btn := Button.new()
	btn.name = "MobileKeyboardTriggerButton"
	btn.text = button_title
	btn.custom_minimum_size.y = 54
	btn.add_theme_font_size_override("font_size", 22)
	btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn.set_meta("center_text", true)

	var sb_normal := StyleBoxFlat.new()
	sb_normal.bg_color = Color(btn_color.r * 0.15, btn_color.g * 0.15, btn_color.b * 0.15, 0.95)
	sb_normal.border_color = btn_color
	sb_normal.set_border_width_all(2)
	sb_normal.set_corner_radius_all(10)
	sb_normal.content_margin_left = 16
	sb_normal.content_margin_right = 16

	var sb_hover := sb_normal.duplicate() as StyleBoxFlat
	sb_hover.bg_color = Color(btn_color.r * 0.3, btn_color.g * 0.3, btn_color.b * 0.3, 0.98)
	sb_hover.border_color = Color("#ffffff")

	var sb_pressed := sb_normal.duplicate() as StyleBoxFlat
	sb_pressed.bg_color = btn_color

	btn.add_theme_stylebox_override("normal", sb_normal)
	btn.add_theme_stylebox_override("hover", sb_hover)
	btn.add_theme_stylebox_override("pressed", sb_pressed)
	btn.add_theme_color_override("font_color", Color("#ffffff"))
	btn.add_theme_color_override("font_hover_color", Color("#ffffff"))
	btn.add_theme_color_override("font_pressed_color", Color("#000000"))

	btn.pressed.connect(func():
		open_keyboard(input_ctrl, prompt_title, true)
	)
	return btn


static var _active_callbacks: Dictionary = {}


## Opens the virtual keyboard for the target input control
static func open_keyboard(input_ctrl: Control, prompt_override: String = "", force_prompt: bool = false) -> void:
	if input_ctrl == null or not is_instance_valid(input_ctrl):
		return

	# Debounce within 200ms to prevent double-firing
	var now := Time.get_ticks_msec()
	var last_open: int = int(input_ctrl.get_meta("last_kb_open_time", 0))
	if (now - last_open) < 200:
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

	# 1. Native Mobile (Android / iOS native app)
	if not OS.has_feature("web") and DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		var keyboard_type := DisplayServer.KEYBOARD_TYPE_DEFAULT
		if input_ctrl is LineEdit:
			keyboard_type = input_ctrl.virtual_keyboard_type
		DisplayServer.virtual_keyboard_show(current_text, input_ctrl.get_global_rect(), keyboard_type, max_len)
		return

	# 2. Web Mobile Browser Support (iOS Safari, Android Chrome, Samsung Internet)
	if force_prompt or is_mobile_web() or (OS.has_feature("web") and is_mobile()):
		_prompt_mobile_web(input_ctrl, prompt_override, current_text, max_len)


## Prompts the user via native browser modal or cyber overlay on mobile web, guaranteeing OS virtual keyboard input
static func _prompt_mobile_web(input_ctrl: Control, prompt_override: String, current_val: String, max_len: int = -1) -> void:
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

	var input_type := "text"
	if input_ctrl is LineEdit:
		var le_typed := input_ctrl as LineEdit
		if le_typed.virtual_keyboard_type == LineEdit.KEYBOARD_TYPE_NUMBER or le_typed.virtual_keyboard_type == LineEdit.KEYBOARD_TYPE_NUMBER_DECIMAL:
			input_type = "number"

	# Register asynchronous callback for modern overlay
	var on_submit = func(args):
		if input_ctrl == null or not is_instance_valid(input_ctrl):
			_active_callbacks.erase(input_ctrl)
			return
		if args.size() > 0 and args[0] != null:
			var res_str := str(args[0])
			if res_str != PROMPT_CANCEL_SENTINEL and res_str != "null":
				_apply_input_text(input_ctrl, res_str)
		_active_callbacks.erase(input_ctrl)

	var cb = JavaScriptBridge.create_callback(on_submit)
	_active_callbacks[input_ctrl] = cb

	var js_eval := """
		(function() {
			var title = %s;
			var def = %s;
			var maxL = %d;
			var inType = %s;
			if (typeof window.showCyberInputOverlay === 'function') {
				window.showCyberInputOverlay(title, def, maxL, inType, function(val) {
					if (window.__godot_kb_cb) {
						window.__godot_kb_cb(val);
					}
				});
				return '__OPENED_ASYNC__';
			}
			if (typeof window.godotPromptInput === 'function') {
				return window.godotPromptInput(title, def);
			}
			var res = window.prompt(title, def);
			return res !== null ? res : '%s';
		})()
	""" % [JSON.stringify(prompt_title), JSON.stringify(current_val), max_len, JSON.stringify(input_type), PROMPT_CANCEL_SENTINEL]

	var win = JavaScriptBridge.get_interface("window")
	if win != null:
		win["__godot_kb_cb"] = cb

	var res = JavaScriptBridge.eval(js_eval)
	if res != null:
		var res_str := str(res)
		if res_str != "__OPENED_ASYNC__" and res_str != PROMPT_CANCEL_SENTINEL and res_str != "null":
			_apply_input_text(input_ctrl, res_str)


static func _apply_input_text(input_ctrl: Control, res_str: String) -> void:
	if input_ctrl == null or not is_instance_valid(input_ctrl):
		return
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
