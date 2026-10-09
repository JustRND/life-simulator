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

	# Test 6: Dedicated Mobile Keyboard Trigger Buttons for Custom Values
	print("\n--- Test 6: Dedicated Mobile Keyboard Trigger Buttons ---")
	# 6.1 Custom Names
	var custom_name_input := LineEdit.new()
	custom_name_input.name = "CustomNameInput"
	vbox.add_child(custom_name_input)
	var name_btn := MobileKeyboardManager.create_keyboard_trigger_button(custom_name_input, "⌨️ Enter Custom Name", "What is your character's name?", Color("#00f0ff"))
	vbox.add_child(name_btn)
	assert(name_btn != null and name_btn is Button, "Dedicated custom name button must be created")
	assert(name_btn.text == "⌨️ Enter Custom Name", "Custom name button text verified")

	# 6.2 Custom Amounts
	var custom_amount_input := LineEdit.new()
	custom_amount_input.name = "CustomAmountInput"
	vbox.add_child(custom_amount_input)
	var amount_btn := MobileKeyboardManager.create_keyboard_trigger_button(custom_amount_input, "⌨️ Type Custom Amount", "Enter deposit amount in whole dollars:", Color("#10b981"))
	vbox.add_child(amount_btn)
	assert(amount_btn != null and amount_btn is Button, "Dedicated custom amount button must be created")
	assert(amount_btn.text == "⌨️ Type Custom Amount", "Custom amount button text verified")

	# 6.3 Custom Cities
	var custom_city_input := LineEdit.new()
	custom_city_input.name = "CustomCityInput"
	vbox.add_child(custom_city_input)
	var city_btn := MobileKeyboardManager.create_keyboard_trigger_button(custom_city_input, "⌨️ Enter Custom City Name", "Enter city name:", Color("#0284c7"))
	vbox.add_child(city_btn)
	assert(city_btn != null and city_btn is Button, "Dedicated custom city button must be created")
	assert(city_btn.text == "⌨️ Enter Custom City Name", "Custom city button text verified")

	# 6.4 Button Press Action Verification
	var amount_text_changed_fired := false
	custom_amount_input.text_changed.connect(func(val):
		amount_text_changed_fired = true
	)
	# Trigger dedicated button click
	amount_btn.emit_signal("pressed")
	assert(custom_amount_input.has_focus(), "Clicking dedicated button must grant focus to target input")
	print("✔ Test 6 passed: Dedicated keyboard trigger buttons for custom names, amounts, and cities verified!")

	print("\n🎉 ALL MOBILE KEYBOARD & TEXT INPUT INTEGRATION TESTS PASSED SUCCESSFULLY! 🎉")
	get_tree().quit(0)
