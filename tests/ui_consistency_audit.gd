extends Node
var inspected := 0
var failures: Array[String] = []

func _ready() -> void:
	LifeLibrary.profile_path = "user://ui_consistency_audit_profile.json"
	get_window().size = Vector2i(540, 960)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.age = 30
	PlayerData.is_dead = false
	var pages := ["_show_jobs_modal", "_show_licensing_modal", "_show_freelance_modal", "_show_business_modal", "_show_education_modal", "_show_university_modal", "_show_gym_modal", "_show_meditation_modal", "_show_mind_and_body_modal", "_show_salon_modal", "_show_spa_modal", "_show_shopping_modal", "_show_social_media_modal", "_show_pet_adoption_modal", "_show_pet_store_modal", "_show_pet_ranch_modal", "_show_will_modal", "_show_charity_modal", "_show_doctor_modal", "_show_crime_modal", "_show_casino_modal"]
	for mode in ["light", "dark"]:
		LifeLibrary.data.theme = mode
		main.get_node("ThemeController").apply_theme()
		for method in pages:
			var previous: Array = main.get_children()
			main.call(method)
			await get_tree().create_timer(0.45).timeout
			for child in main.get_children():
				if not child in previous and child is Control:
					audit(child)
					if method in ["_show_education_modal", "_show_social_media_modal", "_show_jobs_modal", "_show_casino_modal"]:
						if DisplayServer.get_name() != "headless":
							await RenderingServer.frame_post_draw
							get_viewport().get_texture().get_image().save_png("res://work/audit-" + method + "-" + mode + ".png")
					child.queue_free()
			await get_tree().process_frame
		for tab in ["infant", "assets", "bank", "relationships", "character", "activities", "settings"]:
			main.show_tab(tab)
			await get_tree().create_timer(0.4).timeout
			audit(main.settings_overlay if tab == "settings" else main.get(tab + "_panel"))
		main.show_tab("timeline")
		for method in ["_load_life", "_achievements", "_cities", "_people", "_settings", "_themes"]:
			var previous: Array = main.get_children()
			main.get_node("OptionsMenu").call(method)
			await get_tree().create_timer(0.45).timeout
			for child in main.get_children():
				if not child in previous and child is Control:
					audit(child)
					child.queue_free()
			await get_tree().process_frame
		var settings = main.get_node("SettingsPages")
		settings._open_account()
		await get_tree().create_timer(0.45).timeout
		audit(settings.page)
		settings.page.hide()
		settings._open_document("Privacy Policy", settings.PRIVACY)
		await get_tree().create_timer(0.45).timeout
		audit(settings.page)
		settings.page.hide()
		main.get_node("ShopPanel").open_shop()
		await get_tree().create_timer(0.45).timeout
		audit(main.get_node("ShopPanel"))
		main.get_node("ShopPanel").hide()
		main.new_game_panel.show()
		await get_tree().create_timer(0.45).timeout
		audit(main.new_game_panel)
		main.new_game_panel.hide()
		main.get_node("FinancePanel").open()
		await get_tree().create_timer(0.5).timeout
		audit(main.get_node("FinancePanel").overlay)
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://work/audit-finance-" + mode + ".png")
		main.get_node("FinancePanel").overlay.queue_free()
		await get_tree().process_frame
	var report := {"controls_checked": inspected, "failures": failures}
	var file := FileAccess.open("res://work/ui-consistency-audit.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "  "))
	file.close()
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("UI_CONSISTENCY_AUDIT: ", inspected, " controls, ", failures.size(), " findings")
	get_tree().quit()

func audit(node: Node) -> void:
	if node is Control and node.is_visible_in_tree():
		inspected += 1
		if node is Button and node.has_meta("market_button"):
			var normal = node.get_theme_stylebox("normal")
			var disabled = node.get_theme_stylebox("disabled")
			if normal is StyleBoxFlat and disabled is StyleBoxFlat:
				if normal.corner_radius_top_left != disabled.corner_radius_top_left:
					failures.append("Button state geometry: " + str(node.text))
			if node.get_theme_font_size("font_size") < 26:
				failures.append("Small action text: " + str(node.text))
		if node is Label and node.has_meta("reference_part") and not node.has_meta("locale_manual"):
			if node.get_theme_font_size("font_size") < 26:
				failures.append("Small detail text: " + str(node.text))
		if (node is Button or node is Label) and node.get_global_rect().end.x > get_viewport().get_visible_rect().end.x + 4:
			failures.append("Horizontal overflow: " + str(node.text))
	for child in node.get_children():
		audit(child)
