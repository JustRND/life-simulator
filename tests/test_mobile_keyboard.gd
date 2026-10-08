extends Control

func _ready() -> void:
	print("--- Running MobileKeyboardManager & TextInput Integration Test ---")

	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(800, 1000)
	canvas.size = Vector2(800, 1000)
	add_child(canvas)

	var scroll := ScrollContainer.new()
	scroll.position = Vector2(50, 50)
	scroll.size = Vector2(400, 500)
	canvas.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(400, 1200)
	scroll.add_child(vbox)

	var name_input := LineEdit.new()
	name_input.name = "NameInput"
	name_input.text = "John Doe"
	name_input.size = Vector2(380, 70)
	name_input.custom_minimum_size = Vector2(380, 70)
	vbox.add_child(name_input)

	var other_input := LineEdit.new()
	other_input.name = "CustomCityInput"
	other_input.placeholder_text = "Enter city..."
	other_input.size = Vector2(380, 70)
	other_input.custom_minimum_size = Vector2(380, 70)
	vbox.add_child(other_input)

	var touch_controller = preload("res://scripts/ui/touch_scroll_controller.gd").new()
	add_child(touch_controller)

	var kb_manager = preload("res://scripts/ui/mobile_keyboard_manager.gd").new()
	add_child(kb_manager)

	await get_tree().process_frame
	await get_tree().process_frame

	# Test 1: Auto-attachment of MobileKeyboardManager
	print("\n--- Test 1: Auto-attachment verification ---")
	assert(name_input.has_meta("mobile_kb_attached"), "name_input must have mobile_kb_attached meta")
	assert(name_input.virtual_keyboard_enabled, "name_input virtual_keyboard_enabled must be true")
	assert(other_input.has_meta("mobile_kb_attached"), "other_input must have mobile_kb_attached meta")
	assert(other_input.virtual_keyboard_enabled, "other_input virtual_keyboard_enabled must be true")
	print("✔ Test 1 passed: All LineEdit controls automatically attached to MobileKeyboardManager!")

	# Test 2: TouchScrollController text input detection
	print("\n--- Test 2: TouchScrollController text input detection ---")
	var found_input = touch_controller._find_text_input_at(get_tree().root, Vector2(100, 75))
	assert(found_input == name_input, "Must detect name_input at (100, 75)")
	print("✔ Test 2 passed: _find_text_input_at correctly identifies LineEdit at coordinates!")

	# Test 3: Tap on LineEdit triggers focus and preserves input
	print("\n--- Test 3: Tap on LineEdit without swipe ---")
	var tap_down = InputEventScreenTouch.new()
	tap_down.position = Vector2(100, 75)
	tap_down.pressed = true
	tap_down.index = 0
	touch_controller._input(tap_down)
	assert(touch_controller._captured_text_input == name_input, "name_input must be captured on touch down")

	var tap_up = InputEventScreenTouch.new()
	tap_up.position = Vector2(101, 76)
	tap_up.pressed = false
	tap_up.index = 0
	touch_controller._input(tap_up)

	assert(name_input.has_focus(), "name_input must gain focus after tap")
	assert(touch_controller._captured_text_input == null, "_captured_text_input must be cleared after tap")
	print("✔ Test 3 passed: Intentional tap on LineEdit gives focus and triggers keyboard!")

	# Test 4: Swiping over LineEdit scrolls instead of focusing
	print("\n--- Test 4: Swiping over LineEdit ---")
	name_input.release_focus()
	var swipe_down = InputEventScreenTouch.new()
	swipe_down.position = Vector2(100, 75)
	swipe_down.pressed = true
	swipe_down.index = 1
	touch_controller._input(swipe_down)
	assert(touch_controller._captured_text_input == name_input, "name_input captured on swipe start")

	var swipe_move = InputEventScreenDrag.new()
	swipe_move.position = Vector2(100, 20) # 55px drag (well above SWIPE_THRESHOLD)
	swipe_move.index = 1
	touch_controller._input(swipe_move)
	assert(touch_controller._is_swiping, "Controller must enter swiping state")
	assert(touch_controller._captured_text_input == null, "Text input must be released when swiping starts")

	var swipe_up = InputEventScreenTouch.new()
	swipe_up.position = Vector2(100, 20)
	swipe_up.pressed = false
	swipe_up.index = 1
	touch_controller._input(swipe_up)
	assert(not name_input.has_focus(), "name_input must NOT gain focus after a swipe gesture")
	print("✔ Test 4 passed: Swiping gesture scrolls cleanly without triggering input focus!")

	# Test 5: Dynamic LineEdit addition at runtime
	print("\n--- Test 5: Dynamically created LineEdit ---")
	var dynamic_input := LineEdit.new()
	dynamic_input.name = "DynamicTradeInput"
	vbox.add_child(dynamic_input)
	await get_tree().process_frame
	assert(dynamic_input.has_meta("mobile_kb_attached"), "Dynamic LineEdit must be automatically attached on node_added")
	assert(dynamic_input.virtual_keyboard_enabled, "Dynamic LineEdit virtual_keyboard_enabled must be true")
	print("✔ Test 5 passed: Dynamically instantiated LineEdit auto-attached via node_added signal!")

	print("\n🎉 ALL MOBILE KEYBOARD & TEXT INPUT INTEGRATION TESTS PASSED SUCCESSFULLY! 🎉")
