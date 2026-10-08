extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://panel_close_test_profile.json"
	get_window().size = Vector2i(540, 960)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	main.show_tab("timeline")
	PlayerData.age = 30
	PlayerData.social_media = {}
	main._show_social_media_modal()
	await get_tree().create_timer(0.5).timeout
	var view = main._create_cyber_modal("CLOSE TEST", "Closing should move down before disappearing.", Color.CYAN)
	await get_tree().create_timer(0.5).timeout
	var surface: Control = view.card
	var initial: float = surface.offset_top
	view.close_button.pressed.emit()
	await get_tree().create_timer(0.12).timeout
	assert(is_instance_valid(view.overlay) and surface.offset_top > initial)
	assert(view.close_button.disabled)
	await get_tree().create_timer(0.3).timeout
	assert(not is_instance_valid(view.overlay))
	main.show_tab("activities")
	await get_tree().create_timer(0.4).timeout
	initial = main.activities_panel.offset_top
	main._on_close_panel_button_pressed()
	await get_tree().create_timer(0.12).timeout
	assert(main.activities_panel.visible and main.activities_panel.offset_top > initial)
	await get_tree().create_timer(0.3).timeout
	assert(not main.activities_panel.visible)
	main.show_tab("activities")
	await get_tree().create_timer(0.4).timeout
	assert(is_equal_approx(main.activities_panel.offset_top, initial))
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("PANEL_CLOSE_TEST_PASSED")
	get_tree().quit()
