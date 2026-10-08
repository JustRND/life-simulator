extends Node

func _ready() -> void:
	print("--- TESTING RELATIONSHIPS & GRID BUTTON LAYOUTS ---")
	get_window().size = Vector2i(540, 960)
	var main_scene = load("res://scenes/main/main_screen.tscn")
	var main = main_scene.instantiate()
	add_child(main)
	await get_tree().create_timer(1.0).timeout

	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()

	PlayerData.reset_player()
	PlayerData.age = 25
	PlayerData.money = 5000
	PlayerData.mother_alive = true
	PlayerData.mother_name = "Clara Wagner"
	PlayerData.mother_job = "plumber"
	PlayerData.mother_relationship = 45
	PlayerData.mother_health = 80

	PlayerData.father_alive = true
	PlayerData.father_name = "Marcus Wagner"
	PlayerData.father_job = "electrician"
	PlayerData.father_relationship = 65
	PlayerData.father_health = 75

	# Add a partner
	PlayerData.partner = {
		"name": "Sarah Miller",
		"age": 24,
		"gender": "FEMALE",
		"relationship": 85,
		"status": "Girlfriend",
		"happiness": 75,
		"engaged_age": -1,
		"is_alive": true
	}

	# Add a child
	PlayerData.children = [
		{
			"name": "Leo Wagner",
			"age": 6,
			"gender": "MALE",
			"relationship": 90,
			"last_spend_time_age": -1,
			"last_gift_age": -1
		}
	]

	main.show_tab("relationships")
	await get_tree().create_timer(0.5).timeout

	# 1. Inspect MotherActionRow buttons
	var mom_vbox = main.mother_name_label.get_parent() as VBoxContainer
	var mom_row: GridContainer = mom_vbox.get_node_or_null("MotherActionRow") as GridContainer
	assert(mom_row != null, "MotherActionRow must exist")
	print("MotherActionRow columns: ", mom_row.columns)
	print("MotherActionRow size: ", mom_row.size)

	var mom_buttons: Array = mom_row.find_children("*", "Button", true, false)
	print("Found %d buttons in MotherActionRow:" % mom_buttons.size())
	for b in mom_buttons:
		var btn = b as Button
		print("  Mother Button '%s' | size: %s | custom_min: %s | flags: %d" % [btn.text, str(btn.size), str(btn.custom_minimum_size), btn.size_flags_horizontal])
		assert(btn.size.x >= 100, "Mother Button '%s' width (%f) must be >= 100px! Not a thin vertical strip!" % [btn.text, btn.size.x])
		assert(btn.size.y <= 70, "Mother Button '%s' height (%f) must be <= 70px! Not an elongated pillar!" % [btn.text, btn.size.y])

	# 2. Inspect FatherActionRow buttons
	var dad_vbox = main.father_name_label.get_parent() as VBoxContainer
	var dad_row: GridContainer = dad_vbox.get_node_or_null("FatherActionRow") as GridContainer
	assert(dad_row != null, "FatherActionRow must exist")
	print("FatherActionRow columns: ", dad_row.columns)
	print("FatherActionRow size: ", dad_row.size)

	var dad_buttons: Array = dad_row.find_children("*", "Button", true, false)
	print("Found %d buttons in FatherActionRow:" % dad_buttons.size())
	for b in dad_buttons:
		var btn = b as Button
		print("  Father Button '%s' | size: %s | custom_min: %s | flags: %d" % [btn.text, str(btn.size), str(btn.custom_minimum_size), btn.size_flags_horizontal])
		assert(btn.size.x >= 100, "Father Button '%s' width (%f) must be >= 100px!" % [btn.text, btn.size.x])
		assert(btn.size.y <= 70, "Father Button '%s' height (%f) must be <= 70px!" % [btn.text, btn.size.y])

	# 3. Inspect PartnerCard buttons
	var rel_list = main.get_node("RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList")
	var partner_card = rel_list.get_node_or_null("PartnerCard")
	assert(partner_card != null, "PartnerCard must exist")
	var partner_grid: GridContainer = partner_card.find_children("*", "GridContainer", true, false)[0]
	assert(partner_grid != null, "Partner GridContainer must exist")
	var partner_buttons: Array = partner_grid.find_children("*", "Button", true, false)
	print("Found %d buttons in PartnerCard:" % partner_buttons.size())
	for b in partner_buttons:
		var btn = b as Button
		print("  Partner Button '%s' | size: %s | custom_min: %s | flags: %d" % [btn.text, str(btn.size), str(btn.custom_minimum_size), btn.size_flags_horizontal])
		assert(btn.size.x >= 100, "Partner Button '%s' width (%f) must be >= 100px!" % [btn.text, btn.size.x])
		assert(btn.size.y <= 70, "Partner Button '%s' height (%f) must be <= 70px!" % [btn.text, btn.size.y])

	# 4. Inspect ChildCard buttons
	var child_card = rel_list.get_node_or_null("ChildCard_0")
	assert(child_card != null, "ChildCard_0 must exist")
	var child_buttons: Array = child_card.find_children("*", "Button", true, false)
	print("Found %d buttons in ChildCard_0:" % child_buttons.size())
	for b in child_buttons:
		var btn = b as Button
		print("  Child Button '%s' | size: %s | custom_min: %s | flags: %d" % [btn.text, str(btn.size), str(btn.custom_minimum_size), btn.size_flags_horizontal])
		assert(btn.size.x >= 100, "Child Button '%s' width (%f) must be >= 100px!" % [btn.text, btn.size.x])
		assert(btn.size.y <= 70, "Child Button '%s' height (%f) must be <= 70px!" % [btn.text, btn.size.y])

	# 5. Inspect Social Media modal buttons
	SocialMediaManager.create_account(PlayerData, SocialMediaManager.PLATFORM_X)
	main._show_social_media_modal()
	await get_tree().create_timer(0.3).timeout
	var sm_grid: GridContainer = main.social_media_modal_overlay.find_children("*", "GridContainer", true, false)[0]
	assert(sm_grid != null, "Social Media GridContainer must exist")
	var sm_buttons: Array = sm_grid.find_children("*", "Button", true, false)
	print("Found %d buttons in Social Media modal:" % sm_buttons.size())
	for b in sm_buttons:
		var btn = b as Button
		print("  Social Button '%s' | size: %s | custom_min: %s | flags: %d" % [btn.text, str(btn.size), str(btn.custom_minimum_size), btn.size_flags_horizontal])
		assert(btn.size.x >= 100, "Social Button '%s' width (%f) must be >= 100px!" % [btn.text, btn.size.x])
		assert(btn.size.y <= 70, "Social Button '%s' height (%f) must be <= 70px!" % [btn.text, btn.size.y])
	main.social_media_modal_overlay.visible = false
	main.show_tab("relationships")
	await get_tree().create_timer(0.5).timeout

	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var img = get_viewport().get_texture().get_image()
		if img != null and not img.is_empty():
			img.save_png("res://tests/verify_relationships_buttons.png")
			print("Saved screenshot to res://tests/verify_relationships_buttons.png")

	print("--- ALL RELATIONSHIPS & GRID BUTTON TESTS PASSED PERFECTLY ---")
	get_tree().quit()
