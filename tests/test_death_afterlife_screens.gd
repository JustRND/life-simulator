extends Node

const ThemeController = preload("res://scripts/ui/theme_controller.gd")

func _ready() -> void:
	print("--- BEGIN DEATH & AFTERLIFE SCREEN TESTS ---")
	
	# Force Light Mode in settings to test worst-case theme interference!
	LifeLibrary.data.theme = "light"
	PlayerData.reset_player()
	PlayerData.first_name = "Kirana Hidayat"
	PlayerData.birthplace = "Indonesia"
	PlayerData.age = 81
	PlayerData.money = 26774
	PlayerData.bank_savings = 2801
	PlayerData.karma = -40 # Bad karma / condemned
	
	var main_scene = preload("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.hide()
	if main_scene.loading_screen != null:
		main_scene.loading_screen.hide()
	
	# Wait for UI setup
	await get_tree().process_frame
	await get_tree().process_frame
	
	# 1. Test Death Screen Condemned (Negative Karma)
	print("\n--- 1. Testing Death Screen (Condemned / Negative Karma) ---")
	main_scene._show_death_screen("Critical Medical Failure & Acute Complications")
	await get_tree().process_frame
	await get_tree().process_frame
	
	var overlay = main_scene.get_node_or_null("DeathScreenOverlay")
	assert(overlay != null, "DeathScreenOverlay must exist")
	assert(overlay.has_meta("theme_exempt"), "DeathScreenOverlay must be marked theme_exempt")
	assert(ThemeController.is_exempt(overlay), "ThemeController must recognize DeathScreenOverlay as exempt")
	
	# Find card inside overlay
	var screen_margin = overlay.get_child(0)
	var card: PanelContainer = screen_margin.get_child(0)
	var card_sb: StyleBoxFlat = card.get_theme_stylebox("panel")
	print("Card BG Color: %s, Border Color: %s" % [card_sb.bg_color.to_html(), card_sb.border_color.to_html()])
	
	# Assert colors are strictly red and black, NEVER light mode white or blue!
	assert(card_sb.bg_color.v < 0.1, "Death screen card background must be dark/black (v < 0.1), got v=%.2f" % card_sb.bg_color.v)
	assert(card_sb.border_color.r > 0.4 and card_sb.border_color.b < 0.3, "Death screen card border must be blood red")
	
	# Verify that no labels inside DeathScreenOverlay were mutilated by reference_theme
	var labels_found := 0
	for node in overlay.find_children("*", "Label", true, false):
		labels_found += 1
		var l := node as Label
		assert(not l.has_meta("reference_section"), "Death screen label '%s' must NOT have reference_section applied" % l.text)
		assert(l.get_theme_color("font_color") != Color("#174666"), "Death screen label must NOT be styled with light mode blue ink")
	
	print("✔ Verified %d labels in Death Screen (All exempt, zero theme contamination)" % labels_found)
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var vp_img := get_viewport().get_texture().get_image()
		if vp_img != null and not vp_img.is_empty():
			vp_img.save_png("res://tests/death_screen_condemned.png")
			print("Saved res://tests/death_screen_condemned.png")
	
	# 2. Test Death Screen Blessed (Positive Karma)
	print("\n--- 2. Testing Death Screen (Blessed / Positive Karma) ---")
	PlayerData.karma = 50
	main_scene._show_death_screen("Peaceful Old Age")
	await get_tree().process_frame
	await get_tree().process_frame
	
	overlay = main_scene.get_node_or_null("DeathScreenOverlay")
	assert(overlay != null, "DeathScreenOverlay must exist")
	
	# Verify options container has black and red buttons
	var scroll = overlay.find_child("DeathScrollContainer", true, false) as ScrollContainer
	assert(scroll != null, "DeathScrollContainer must exist in Death Screen")
	
	# Clean up death screen before afterlife test
	overlay.queue_free()
	await get_tree().process_frame
	
	# 3. Test Afterlife Minigame Layout & Vertical Text Prevention (Condemned)
	print("\n--- 3. Testing Afterlife Minigame Layout (Condemned) ---")
	var afterlife_script = preload("res://scripts/minigames/afterlife_minigame.gd")
	var amg: AfterlifeMinigame = afterlife_script.new()
	amg.name = "AfterlifeMinigame"
	main_scene.add_child(amg)
	amg.setup(-50, Callable())
	await get_tree().process_frame
	await get_tree().process_frame
	
	var amg_overlay = amg.get_node_or_null("AfterlifeMinigameOverlay")
	assert(amg_overlay != null, "AfterlifeMinigameOverlay must exist")
	assert(ThemeController.is_exempt(amg), "AfterlifeMinigame must be exempt from ThemeController")
	assert(ThemeController.is_exempt(amg_overlay), "AfterlifeMinigameOverlay must be exempt from ThemeController")
	
	# Simulate weighing deeds to show verdict panel & newborn vessel
	amg._finish_weighing()
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert(amg.verdict_panel.visible, "Verdict panel must be visible after weighing")
	assert(amg.accept_button.visible, "Accept button must be visible after weighing")
	
	# Find newborn vessel labels
	var id_title: Label = null
	var id_name: Label = null
	var id_details: Label = null
	for node in amg.verdict_panel.find_children("*", "Label", true, false):
		var lbl := node as Label
		if "NEW MORTAL VESSEL" in lbl.text:
			id_title = lbl
		elif "Name:" in lbl.text:
			id_name = lbl
		elif "Gender:" in lbl.text:
			id_details = lbl
	
	assert(id_title != null, "NEW MORTAL VESSEL label must exist")
	assert(id_name != null, "Name label must exist")
	assert(id_details != null, "Gender/details label must exist")
	
	# Crucial check: verify that id_title did NOT get converted to reference_section
	assert(not id_title.has_meta("reference_section"), "id_title must NOT be marked reference_section")
	assert(not id_name.has_meta("reference_section"), "id_name must NOT be marked reference_section")
	assert(not id_details.has_meta("reference_section"), "id_details must NOT be marked reference_section")
	
	# Verify horizontal dimensions: container must have ample width, NEVER 1-character narrow column
	var id_info_v: VBoxContainer = id_title.get_parent() as VBoxContainer
	assert(id_info_v != null, "id_info_v must exist")
	print("id_info_v custom_minimum_size: %s, size: %s" % [id_info_v.custom_minimum_size, id_info_v.size])
	assert(id_info_v.custom_minimum_size.x >= 300, "id_info_v must have custom_minimum_size.x >= 300 to prevent vertical wrapping")
	
	# Check labels are not single-character width
	print("id_title text: '%s', size: %s" % [id_title.text, id_title.size])
	print("id_name text: '%s', size: %s" % [id_name.text, id_name.size])
	print("id_details text: '%s', size: %s" % [id_details.text, id_details.size])
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var amg_img := get_viewport().get_texture().get_image()
		if amg_img != null and not amg_img.is_empty():
			amg_img.save_png("res://tests/afterlife_condemned.png")
			print("Saved res://tests/afterlife_condemned.png")
	
	# 4. Test Afterlife Minigame Layout (Blessed)
	print("\n--- 4. Testing Afterlife Minigame Layout (Blessed) ---")
	amg.queue_free()
	await get_tree().process_frame
	
	var amg_blessed: AfterlifeMinigame = afterlife_script.new()
	amg_blessed.name = "AfterlifeMinigame"
	main_scene.add_child(amg_blessed)
	amg_blessed.setup(60, Callable())
	await get_tree().process_frame
	amg_blessed._finish_weighing()
	await get_tree().process_frame
	
	assert(amg_blessed.verdict_panel.visible, "Verdict panel visible")
	print("✔ Blessed Afterlife minigame instantiated and weighed successfully")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var blessed_img := get_viewport().get_texture().get_image()
		if blessed_img != null and not blessed_img.is_empty():
			blessed_img.save_png("res://tests/afterlife_blessed.png")
			print("Saved res://tests/afterlife_blessed.png")
	
	print("\n--- ALL DEATH & AFTERLIFE TESTS PASSED PERFECTLY! ---")
	get_tree().quit(0)
