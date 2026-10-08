extends Node

func _ready() -> void:
	print("=== BEGIN COMPREHENSIVE UI & BLIND-BOX VERIFICATION ===")
	
	# 1. Verify Blind-Box Sanitization in PlayerData & Log
	var sample_event_1 := "You visited the gym for Cardio and Sauna (Health +10, Looks +5, Happiness +5)."
	var sanitized_1 := PlayerData.sanitize_stat_spoilers(sample_event_1)
	assert(not sanitized_1.contains("Health +"), "Sanitizer must remove Health +")
	assert(not sanitized_1.contains("+10"), "Sanitizer must remove +10")
	assert(sanitized_1 == "You visited the gym for Cardio and Sauna.", "Sanitized output mismatch: %s" % sanitized_1)
	print("✔ Test 1: PlayerData.sanitize_stat_spoilers cleanly strips stat modifiers")

	# 2. Verify BalanceRules.learn does not contain stat gains
	PlayerData.age = 10
	PlayerData.money = 1000
	PlayerData.learning_activities.clear()
	var learn_msg: String = BalanceRules.learn(PlayerData, "reading")
	assert(not learn_msg.contains("Smarts +"), "Learn message must not contain Smarts +")
	assert(not learn_msg.contains("Happiness +"), "Learn message must not contain Happiness +")
	assert(learn_msg.contains("completed! Mental maintenance secured for this year."), "Learn message missing confirmation text")
	print("✔ Test 2: BalanceRules.learn adheres to blind-box narrative rules: '%s'" % learn_msg)

	# 3. Instantiate MainScreen
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	await get_tree().process_frame
	await get_tree().process_frame

	# 4. Verify 5 Core Buttons Visible on New Game
	PlayerData.reset_player()
	main_scene._on_start_game_button_pressed()
	await get_tree().process_frame
	
	assert(main_scene.action_bar != null, "Action bar must exist")
	assert(main_scene.action_bar.visible == true, "Action bar (5 core buttons) MUST be visible upon starting new life!")
	assert(main_scene.age_button != null, "Age button must exist")
	assert(main_scene.age_button.visible == true, "Age button MUST be visible upon starting new life!")
	print("✔ Test 3: Bottom action bar & 5 core buttons are visible on new life creation")

	# 5. Verify Parent Condition Debuff Label on Parent Cards
	PlayerData.mother_name = "Valentina"
	PlayerData.father_name = "Carlos"
	PlayerData.mother_condition = "Skin Cancer"
	PlayerData.father_condition = "Heart Disease"
	PlayerData.mother_alive = true
	PlayerData.father_alive = true
	main_scene.update_relationships_panel()
	await get_tree().process_frame

	var mom_vbox: VBoxContainer = main_scene.mother_name_label.get_parent() as VBoxContainer
	var mom_debuff = mom_vbox.get_node_or_null("MotherDebuffLabel") as Label
	assert(mom_debuff != null, "MotherDebuffLabel must exist on mother card")
	assert(mom_debuff.visible == true, "MotherDebuffLabel must be visible")
	assert(mom_debuff.text.contains("Skin Cancer"), "Mother debuff text must mention condition")

	var dad_vbox: VBoxContainer = main_scene.father_name_label.get_parent() as VBoxContainer
	var dad_debuff = dad_vbox.get_node_or_null("FatherDebuffLabel") as Label
	assert(dad_debuff != null, "FatherDebuffLabel must exist on father card")
	assert(dad_debuff.visible == true, "FatherDebuffLabel must be visible")
	assert(dad_debuff.text.contains("Heart Disease"), "Father debuff text must mention condition")
	print("✔ Test 4: Parent debuff labels display accurately on Mother and Father cards")

	# 6. Verify Tactile Button Styling on Parent Actions
	var mom_actions: GridContainer = mom_vbox.get_node_or_null("MotherActionRow") as GridContainer
	assert(mom_actions != null, "MotherActionRow must exist")
	var btn_first: Button = mom_actions.get_child(0) as Button
	assert(btn_first != null, "Parent button must exist")
	var sb = btn_first.get_theme_stylebox("normal")
	assert(sb is StyleBoxFlat, "Button must have StyleBoxFlat normal style")
	var sb_flat := sb as StyleBoxFlat
	assert(sb_flat.border_width_left == 2 and sb_flat.border_width_right == 2, "Tactile button must have 2px borders all around")
	assert(sb_flat.corner_radius_top_left == 10, "Tactile button must have 10px rounded corners")
	assert(sb_flat.shadow_size >= 4, "Tactile button must have shadow backdrop")
	print("✔ Test 5: Parent action buttons use consistent tactile market button styling (borders, corners, shadow)")

	# 7. Verify Deadzone Margins (ReferenceTheme does not zero margins)
	var ref_theme = preload("res://scripts/ui/reference_theme.gd").new()
	var test_margin := MarginContainer.new()
	test_margin.name = "ActMargin"
	ref_theme.apply(test_margin, true)
	assert(test_margin.get_theme_constant("margin_left") >= 24, "ActMargin left must have healthy deadzone margin")
	assert(test_margin.get_theme_constant("margin_right") >= 24, "ActMargin right must have healthy deadzone margin")
	print("✔ Test 6: Deadzone margins strictly preserved on screen containers (ActMargin: %d px)" % test_margin.get_theme_constant("margin_left"))

	# 8. Verify Market Activity String Format in FinancePanel
	var finance_node = main_scene.get_node_or_null("FinancePanel")
	assert(finance_node != null, "FinancePanel must be installed")
	var sample_company := {
		"uid": "TEST_CO",
		"name": "Apex Test",
		"price": 50.0,
		"history": [50.0, 50.0],
		"owner": "Public",
		"available": 5000,
		"npc_buys": 142,
		"npc_sells": 98,
		"business_uid": ""
	}
	var test_box := VBoxContainer.new()
	add_child(test_box)
	# Check formatting string in finance_panel.gd source
	var f_script: GDScript = preload("res://scripts/ui/finance_panel.gd")
	var f_src: String = f_script.source_code
	assert(f_src.contains("Market Activity: %d buys ---- %d sells"), "Market Activity format must be 'Market Activity: [NUMBER] buys ---- [NUMBER] sells'")
	assert(not f_src.contains("NPC Market Activity"), "Must not contain 'NPC Market Activity'")
	print("✔ Test 7: Market Activity text formatted as 'Market Activity: %d buys ---- %d sells' without 'NPC'")

	print("=== ALL COMPREHENSIVE VERIFICATIONS PASSED SUCCESSFULLY (100%) ===")
	get_tree().quit(0)
