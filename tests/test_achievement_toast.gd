extends Control

func _ready() -> void:
	print("--- Testing Achievement Toast & Close Button ---")
	
	# Create mock options menu and pages
	var main_control = Control.new()
	main_control.custom_minimum_size = Vector2(1080, 1920)
	main_control.size = Vector2(1080, 1920)
	add_child(main_control)
	
	var options = preload("res://scripts/ui/options_menu.gd").new()
	options.main = main_control
	options.pages = preload("res://scripts/ui/settings_pages.gd").new()
	add_child(options.pages)
	add_child(options)
	
	await get_tree().process_frame
	
	# Queue an achievement notice
	options._queue_notice("First Steps", "Started your first life journey")
	await get_tree().process_frame
	await get_tree().process_frame
	
	var toast = main_control.get_node_or_null("AchievementToast")
	assert(toast != null, "AchievementToast must be created")
	print("✔ Toast successfully created")
	
	var close_btn = toast.find_child("CloseAchievementButton", true, false) as Button
	assert(close_btn != null, "CloseAchievementButton must exist inside AchievementToast")
	assert(close_btn.text == "✕", "Close button must have '✕' text")
	print("✔ CloseAchievementButton found with text '✕'")
	
	# Simulate clicking the close button
	print("Simulating click on close button...")
	close_btn.emit_signal("pressed")
	
	# Wait for dismiss animation
	await get_tree().create_timer(0.3).timeout
	
	var toast_after = main_control.get_node_or_null("AchievementToast")
	assert(toast_after == null or not is_instance_valid(toast_after), "Toast must be dismissed and freed after clicking '✕'")
	print("✔ Toast successfully dismissed and removed from screen!")
	
	print("\n✔ ACHIEVEMENT TOAST 'X' BUTTON TEST PASSED SUCCESSFULLY!")
	get_tree().quit(0)
