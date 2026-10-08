extends Node
const Icons = preload("res://scripts/ui/action_icons.gd")

func _ready() -> void:
	var events: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/events/basic_events.json"))
	for event in events:
		var used: Array[String] = []
		for choice in event.choices:
			assert(choice.has("icon"))
			assert(not str(choice.icon) in used)
			used.append(str(choice.icon))
	assert(Icons.for_text("Borrow $1,000 (Micro Advance • 5% APR)") == "🪙")
	assert(Icons.for_text("Borrow $25,000 (Major Commercial • 8% APR)") == "🏢")
	assert(Icons.for_text("Repay Full Debt ($250)") == "✅")
	assert(Icons.for_text("Carefully consider the options") != "🚗")
	assert(Icons.for_text("Launch New YouTube Account") == "▶")
	assert(Icons.for_text("Launch New Instagram Account") == "📸")
	assert(Icons.for_text("Launch New Twitch Account") == "🟣")
	assert(Icons.for_text("Launch New X Account") == "𝕏")
	assert(Icons.for_text("Launch New TikTok Account") == "🎵")
	LifeLibrary.profile_path = "user://action_icons_test_profile.json"
	LifeLibrary.data.language = "en"
	get_window().size = Vector2i(540, 960)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	main.show_tab("activities")
	var list = main.get_node("ActivitiesPanel/ActMargin/ActContent/ActScroll/ActList")
	assert(list.get_node("LearningItem").get_index() == list.get_node("EducationActItem").get_index() + 1)
	await capture("activities")
	for event in events:
		if event.id == "elementary_spelling_bee":
			main.current_event = event
			main.current_event_choices = main.generate_event_choices(event)
			main.show_event_popup()
	await capture("event")
	for button in [main.event_choice_1, main.event_choice_2, main.event_choice_3]:
		assert(button.get_node("ReferenceRow").symbol.text == button.get_meta("action_emoji"))
	main.hide_event_popup()
	main.show_tab("bank")
	await capture("bank")
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("ACTION_ICONS_TEST_PASSED")
	get_tree().quit()

func capture(label: String) -> void:
	await get_tree().create_timer(0.2).timeout
