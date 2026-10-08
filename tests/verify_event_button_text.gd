extends Node

func _ready() -> void:
	print("=== BEGIN VERIFICATION: EVENT BUTTON TEXT & DUPLICATE REMOVAL ===")
	
	LifeLibrary.data.theme = "light"
	PlayerData.reset_player()
	
	var main_scene_res = load("res://scenes/main/main_screen.tscn")
	var main_scene = main_scene_res.instantiate()
	add_child(main_scene)
	
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.hide()
	if main_scene.loading_screen != null:
		main_scene.loading_screen.hide()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	main_scene.current_event = {
		"id": "kindergarten_mess_test",
		"title": "KINDERGARTEN MESS",
		"description": "You accidentally tip over a full bowl of tomato soup onto the preschool activity table.\n\nWhat do you do?"
	}
	main_scene.current_event_choices = [
		{"text": "Blame the kid sitting next to you"},
		{"text": "Help clean up the mess with napkins"},
		{"text": "Throw more paint and laugh hysterically"}
	]
	
	main_scene.show_event_popup()
	await get_tree().process_frame
	await get_tree().process_frame
	
	var choices_container = main_scene.get_node("EventOverlay/EventPanel/EventMargin/EventContent/EventChoices")
	assert(choices_container != null, "EventChoices container must exist")
	
	var buttons = [
		choices_container.get_node("EventChoice1") as Button,
		choices_container.get_node("EventChoice2") as Button,
		choices_container.get_node("EventChoice3") as Button
	]
	
	for i in range(buttons.size()):
		var btn: Button = buttons[i]
		assert(btn.visible, "EventChoice%d must be visible" % (i + 1))
		
		# 1. Native button font color must be transparent (to eliminate duplicate middle text)
		var btn_font_col: Color = btn.get_theme_color("font_color")
		print("Button %d native font_color: a=%.2f" % [i + 1, btn_font_col.a])
		assert(btn_font_col.a == 0.0, "Native button font_color must be TRANSPARENT so no text shows in the middle")
		
		# 2. ReferenceRow child must exist
		var ref_row = btn.get_node_or_null("ReferenceRow")
		assert(ref_row != null, "ReferenceRow child must exist on EventChoice%d" % (i + 1))
		
		# 3. Main text (heading) must be WHITE
		var heading: Label = ref_row.heading
		assert(heading != null, "ReferenceRow heading must exist")
		var heading_col: Color = heading.get_theme_color("font_color")
		print("Button %d ReferenceRow heading text: '%s', color: %s" % [i + 1, heading.text, heading_col.to_html()])
		assert(heading_col == Color.WHITE, "Heading font color must be WHITE (got %s)" % heading_col.to_html())
		
		# 4. Heading text must contain the choice text without emoji duplication
		var expected_choice_text: String = main_scene.current_event_choices[i]["text"]
		assert(heading.text == expected_choice_text, "Heading text must be '%s', got '%s'" % [expected_choice_text, heading.text])
		
		# 5. Arrow must also be white
		var arrow: Label = ref_row.arrow
		assert(arrow != null, "Arrow label must exist")
		var arrow_col: Color = arrow.get_theme_color("font_color")
		assert(arrow_col == Color.WHITE, "Arrow font color must be WHITE (got %s)" % arrow_col.to_html())
	
	print("✔ Light theme: All event buttons have white main text and transparent native button text (no duplicate text in middle)!")
	
	# Also test in dark theme
	print("\n--- Testing in dark theme ---")
	LifeLibrary.data.theme = "dark"
	main_scene.show_event_popup()
	await get_tree().process_frame
	await get_tree().process_frame
	
	for i in range(buttons.size()):
		var btn: Button = buttons[i]
		var ref_row = btn.get_node("ReferenceRow")
		var heading: Label = ref_row.heading
		var heading_col: Color = heading.get_theme_color("font_color")
		print("Dark mode Button %d heading color: %s" % [i + 1, heading_col.to_html()])
		assert(heading_col == Color.WHITE, "Dark mode heading font color must be WHITE")
		var btn_font_col: Color = btn.get_theme_color("font_color")
		assert(btn_font_col.a == 0.0, "Dark mode native font_color must be TRANSPARENT")
	
	print("✔ Dark theme: All event buttons have white main text and transparent native button text!")
	print("=== ALL VERIFICATION CHECKS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
