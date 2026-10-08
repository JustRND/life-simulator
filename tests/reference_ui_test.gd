extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://reference_ui_test_profile.json"
	LifeLibrary.data.language = "en"
	LifeLibrary.data.currency = "USD"
	get_window().size = Vector2i(540, 960)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.age = 30
	var controller = main.get_node("ThemeController")
	for mode in ["dark", "light"]:
		LifeLibrary.data.theme = mode
		controller.apply_theme()
		main.settings_overlay.show()
		await capture("options-" + mode)
		main.settings_overlay.hide()
		for panel_name in ["infant", "assets", "bank", "relationships", "character"]:
			main.show_tab(panel_name)
			await capture(panel_name + "-" + mode)
		main.show_tab("activities")
		await capture("activities-" + mode)
		for action in ["_show_jobs_modal", "_show_education_modal", "_show_licensing_modal", "_show_business_modal", "_show_doctor_modal"]:
			var previous_panels: Array = main.get_children()
			main.call(action)
			await capture(action + "-" + mode)
			for child in main.get_children():
				if not child in previous_panels and child is Control:
					child.queue_free()
			await get_tree().process_frame
		var previous: Array = main.get_children()
		main.get_node("FinancePanel").open_learning()
		await capture("learning-" + mode)
		for child in main.get_children():
			if not child in previous and child is Control:
				child.queue_free()
		await get_tree().process_frame
		var modal = main._create_cyber_modal("LAYOUT CHECK", "Long descriptions should wrap and all controls should remain usable.", Color.CYAN)
		var button = main._create_cyber_button("A long action title that needs to wrap on a narrow screen\nA detailed explanation with a price of $1,500", Color.CYAN)
		modal.list.add_child(button)
		var disabled_button = main._create_disabled_cyber_button("Unavailable action", "Requires an adult character")
		modal.list.add_child(disabled_button)
		await capture("nested-" + mode)
		assert(button.custom_minimum_size.y >= 192)
		assert(button.get_node("ReferenceRow").size.x <= get_viewport().get_visible_rect().size.x)
		var row = button.get_node("ReferenceRow")
		var background: Color = button.get_theme_stylebox("normal").bg_color
		assert(contrast(row.heading.get_theme_color("font_color"), background) >= 4.5)
		assert(contrast(row.description.get_theme_color("font_color"), background) >= 4.5)
		assert(contrast(disabled_button.get_node("ReferenceRow").heading.get_theme_color("font_color"), background) >= 4.5)
		modal.close_button.pressed.emit()
		await get_tree().process_frame
	GameLocale.set_preferences("ru", "USD")
	main.settings_overlay.show()
	await capture("options-ru")
	main.settings_overlay.hide()
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("REFERENCE_UI_TEST_PASSED")
	get_tree().quit()

func contrast(a: Color, b: Color) -> float:
	var first := a.srgb_to_linear().get_luminance()
	var second := b.srgb_to_linear().get_luminance()
	return (maxf(first, second) + 0.05) / (minf(first, second) + 0.05)

func capture(label: String) -> void:
	await get_tree().create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://work/reference-" + label + ".png")
