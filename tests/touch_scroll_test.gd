extends Node

func _ready() -> void:
	print("--- Running TouchScrollController Unit Test ---")
	var root_window = get_tree().root
	print("root_window is CanvasItem: ", root_window is CanvasItem)
	print("root_window is Window: ", root_window is Window)
	
	var canvas = Control.new()
	canvas.custom_minimum_size = Vector2(800, 1000)
	canvas.size = Vector2(800, 1000)
	add_child(canvas)
	
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(50, 50)
	scroll.size = Vector2(300, 400)
	canvas.add_child(scroll)
	
	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(300, 1200) # Ensure it needs scrolling
	scroll.add_child(vbox)
	
	var clicked_count := 0
	var btn := Button.new()
	btn.text = "Test Button"
	btn.custom_minimum_size = Vector2(300, 60)
	btn.pressed.connect(func(): clicked_count += 1)
	vbox.add_child(btn)
	
	var controller = preload("res://scripts/ui/touch_scroll_controller.gd").new()
	add_child(controller)
	
	# Wait two frames for layout, rects, and scrollbars to compute
	await get_tree().process_frame
	await get_tree().process_frame
	
	var vsb = scroll.get_v_scroll_bar()
	print("Scroll vsb max_value: ", vsb.max_value, " page: ", vsb.page)
	
	var target = controller._find_scroll_at(root_window, Vector2(100, 100))
	print("Found scroll target successfully: ", target == scroll)
	assert(target == scroll, "Must find ScrollContainer under pointer")
	
	# Test 1: Tap without drag -> should not activate swipe
	print("Test 1: Simulating tap...")
	var tap_down = InputEventScreenTouch.new()
	tap_down.position = Vector2(100, 80)
	tap_down.pressed = true
	tap_down.index = 0
	controller._input(tap_down)
	assert(controller._active_scroll == scroll, "Active scroll should be identified")
	assert(not controller._is_swiping, "Tap down must not be swiping")
	
	var tap_up = InputEventScreenTouch.new()
	tap_up.position = Vector2(100, 80)
	tap_up.pressed = false
	tap_up.index = 0
	controller._input(tap_up)
	assert(not controller._is_swiping, "Tap up must not be swiping")
	
	# Test 2: Swipe / Drag via Touch -> should scroll and activate swiping
	print("Test 2: Simulating swipe via touch...")
	var swipe_down = InputEventScreenTouch.new()
	swipe_down.position = Vector2(100, 80)
	swipe_down.pressed = true
	swipe_down.index = 0
	controller._input(swipe_down)
	
	var initial_scroll = scroll.scroll_vertical
	
	# Drag upwards 50px (swipe up)
	var drag1 = InputEventScreenDrag.new()
	drag1.position = Vector2(100, 30)
	drag1.relative = Vector2(0, -50)
	drag1.index = 0
	controller._input(drag1)
	
	assert(controller._is_swiping, "Swiping must be active after exceeding threshold")
	print("Scroll vertical after touch drag: ", scroll.scroll_vertical, " (initial was ", initial_scroll, ")")
	assert(scroll.scroll_vertical > initial_scroll, "ScrollContainer should have scrolled down")
	
	# Release touch after swipe
	var swipe_up = InputEventScreenTouch.new()
	swipe_up.position = Vector2(100, 30)
	swipe_up.pressed = false
	swipe_up.index = 0
	controller._input(swipe_up)
	
	assert(not controller._is_swiping, "Swiping state should reset on release")
	
	# Test 3: Web Browser Emulated Mouse Drag
	print("Test 3: Simulating swipe via mouse drag (browser emulation)...")
	var mb_down = InputEventMouseButton.new()
	mb_down.button_index = MOUSE_BUTTON_LEFT
	mb_down.pressed = true
	mb_down.position = Vector2(100, 80)
	controller._input(mb_down)
	
	var scroll_before_mouse = scroll.scroll_vertical
	var mm = InputEventMouseMotion.new()
	mm.button_mask = MOUSE_BUTTON_MASK_LEFT
	mm.position = Vector2(100, 30)
	controller._input(mm)
	
	assert(controller._is_swiping, "Swiping must be active for mouse drag")
	print("Scroll vertical after mouse drag: ", scroll.scroll_vertical, " (before was ", scroll_before_mouse, ")")
	assert(scroll.scroll_vertical > scroll_before_mouse, "ScrollContainer should have scrolled down via mouse motion")
	
	var mb_up = InputEventMouseButton.new()
	mb_up.button_index = MOUSE_BUTTON_LEFT
	mb_up.pressed = false
	mb_up.position = Vector2(100, 30)
	controller._input(mb_up)
	assert(not controller._is_swiping, "Swiping state should reset on mouse release")
	
	print("✔ All TouchScrollController tests PASSED successfully!")
	get_tree().quit(0)
