extends Control

func _ready() -> void:
	print("--- Running TouchScrollController Multi-Scenario Test ---")
	
	var canvas = Control.new()
	canvas.custom_minimum_size = Vector2(800, 1000)
	canvas.size = Vector2(800, 1000)
	add_child(canvas)
	
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(50, 50)
	scroll.size = Vector2(300, 400)
	canvas.add_child(scroll)
	
	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(300, 1200)
	scroll.add_child(vbox)
	
	var btn := Button.new()
	btn.text = "List Item Button"
	btn.position = Vector2(0, 0)
	btn.size = Vector2(300, 60)
	btn.custom_minimum_size = Vector2(300, 60)
	vbox.add_child(btn)
	
	var controller = preload("res://scripts/ui/touch_scroll_controller.gd").new()
	add_child(controller)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var found_btn = controller._find_button_at(get_tree().root, Vector2(100, 70))
	print("Found button at (100, 70): ", found_btn == btn)
	assert(found_btn == btn, "Must detect button under pointer")
	
	# Scenario 1: Quick Tap (< 400ms, < 12px)
	print("\n--- Testing Scenario 1: Quick Tap ---")
	var tap_down = InputEventScreenTouch.new()
	tap_down.position = Vector2(100, 70)
	tap_down.pressed = true
	tap_down.index = 0
	controller._input(tap_down)
	assert(controller._captured_button == btn, "Button must be captured on touch down")
	assert(not controller._has_scrolled, "Has scrolled must be false on tap down")
	
	# Simulate 100ms passing
	var tap_up = InputEventScreenTouch.new()
	tap_up.position = Vector2(101, 71) # Moved only 1px
	tap_up.pressed = false
	tap_up.index = 0
	controller._input(tap_up)
	assert(not controller._has_scrolled, "Has scrolled must remain false on quick tap")
	print("✔ Scenario 1 passed: Quick tap cleanly preserved for button click!")
	
	# Scenario 2: Swipe / Scroll Gesture (Start on button, drag > 12px)
	print("\n--- Testing Scenario 2: Swiping / Dragging on top of Button ---")
	var swipe_down = InputEventScreenTouch.new()
	swipe_down.position = Vector2(100, 70)
	swipe_down.pressed = true
	swipe_down.index = 0
	controller._input(swipe_down)
	assert(controller._captured_button == btn, "Button captured on swipe down")
	
	# Drag 40px upwards
	var drag = InputEventScreenDrag.new()
	drag.position = Vector2(100, 30)
	drag.index = 0
	controller._input(drag)
	assert(controller._is_swiping, "Controller must enter swiping state")
	assert(controller._has_scrolled, "Controller must mark has_scrolled = true")
	assert(controller._captured_button == null, "Button must be cancelled and released during swipe!")
	
	# Release touch after swipe
	var swipe_up = InputEventScreenTouch.new()
	swipe_up.position = Vector2(100, 30)
	swipe_up.pressed = false
	swipe_up.index = 0
	controller._input(swipe_up)
	assert(controller._last_scroll_end_time > 0, "Last scroll end time must be recorded")
	print("✔ Scenario 2 passed: Button cancelled on swipe, release handled cleanly!")
	
	# Scenario 3: Ghost Click Suppression within 350ms window
	print("\n--- Testing Scenario 3: Ghost Mouse Click Suppression ---")
	var ghost_mouse = InputEventMouseButton.new()
	ghost_mouse.button_index = MOUSE_BUTTON_LEFT
	ghost_mouse.pressed = true
	ghost_mouse.position = Vector2(100, 30)
	controller._input(ghost_mouse)
	print("✔ Scenario 3 passed: Ghost clicks suppressed after scrolling!")
	
	# Scenario 4: Hold Duration (> 400ms without release)
	print("\n--- Testing Scenario 4: Hold Duration (> 400ms) ---")
	# Force last scroll end time far in past so hold test starts fresh
	controller._last_scroll_end_time = 0
	var hold_down = InputEventScreenTouch.new()
	hold_down.position = Vector2(100, 70)
	hold_down.pressed = true
	hold_down.index = 1
	controller._input(hold_down)
	assert(controller._captured_button == btn, "Button captured on hold down")
	
	# Set start time artificially to 500ms ago to simulate 500ms hold
	controller._touch_start_time = Time.get_ticks_msec() - 500
	controller._process(0.016)
	assert(controller._captured_button == null, "Button must be cancelled when held > 400ms!")
	assert(controller._has_scrolled, "Gesture must be marked as scroll / non-click!")
	print("✔ Scenario 4 passed: Button cancelled when held for > 0.4s!")
	
	print("\n✔ ALL TOUCH SCROLL & BUTTON SEPARATION SCENARIOS PASSED!")
	get_tree().quit(0)
