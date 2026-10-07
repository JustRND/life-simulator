extends Node


func _ready() -> void:
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	PlayerData.age = 25
	for tab in ["infant", "assets", "relationships", "activities", "settings"]:
		var panels := {"infant": main.infant_panel, "assets": main.assets_panel, "relationships": main.relationships_panel, "activities": main.activities_panel, "settings": main.settings_overlay.get_node("SettingsCard")}
		var panel: Control = panels[tab]
		var top := panel.offset_top
		var bottom := panel.offset_bottom
		main.show_tab(tab)
		assert(panel.offset_top > top)
		assert(is_equal_approx(panel.offset_bottom - panel.offset_top, bottom - top))
		await get_tree().create_timer(0.45).timeout
		assert(is_equal_approx(panel.offset_top, top))
		assert(is_equal_approx(panel.offset_bottom, bottom))
		if tab == "settings":
			main._on_close_settings_button_pressed()
		else:
			main.show_tab("timeline")
		await get_tree().process_frame
	var original_top: float = main.infant_panel.offset_top
	main.show_tab("infant")
	main.show_tab("timeline")
	assert(is_equal_approx(main.infant_panel.offset_top, original_top))
	await get_tree().process_frame
	main.show_tab("infant")
	await get_tree().create_timer(0.45).timeout
	assert(is_equal_approx(main.infant_panel.offset_top, original_top))
	print("PANEL_PULL_UP_TEST_PASSED")
	get_tree().quit()
