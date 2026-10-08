extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://panel_spacing_test_profile.json"
	get_window().size = Vector2i(540, 800)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.age = 15
	var finance = main.get_node("FinancePanel")
	for mode in ["light", "dark"]:
		LifeLibrary.data.theme = mode
		main.get_node("ThemeController").apply_theme()
		for language in ["en", "ru", "id"]:
			GameLocale.set_preferences(language, "USD")
			for tab in ["Exchange", "Portfolio", "My Businesses"]:
				finance.selected_tab = tab
				finance.open()
				await get_tree().create_timer(0.5).timeout
				var tabs: Control = finance.overlay.find_child("MarketTabs", true, false)
				if tab == "Exchange":
					var listings: Control = finance.overlay.find_child("ActiveListings", true, false)
					assert(listings.get_global_rect().position.y - tabs.get_global_rect().end.y >= 24)
				check_boxes(finance.overlay)
				if language == "en" and tab == "Exchange":
					await RenderingServer.frame_post_draw
					get_viewport().get_texture().get_image().save_png("res://work/market-spacing-" + mode + ".png")
		finance.overlay.queue_free()
		await get_tree().process_frame
		for panel_name in ["activities", "bank", "relationships", "character", "settings"]:
			main.show_tab(panel_name)
			await get_tree().create_timer(0.45).timeout
			var panel: Control = main.settings_overlay if panel_name == "settings" else main.get(panel_name + "_panel")
			check_boxes(panel)
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("PANEL_SPACING_TEST_PASSED")
	get_tree().quit()

func check_boxes(node: Node) -> void:
	if node is BoxContainer and node.is_visible_in_tree():
		var previous: Control
		for child in node.get_children():
			if not child is Control or not child.visible or child.is_set_as_top_level():
				continue
			if previous != null:
				var gap: float = child.position.y - previous.get_rect().end.y if node is VBoxContainer else child.position.x - previous.get_rect().end.x
				assert(gap >= 7.0, "Missing spacing in %s: %s to %s (%f)" % [node.get_path(), previous.name, child.name, gap])
			previous = child
	for child in node.get_children():
		check_boxes(child)
