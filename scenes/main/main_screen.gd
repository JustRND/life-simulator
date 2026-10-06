extends Control

var current_event = null
var current_event_choices: Array = []

@onready var age_label: Label = $SafeArea/MainColumn/AgeLabel
@onready var life_feed: RichTextLabel = $SafeArea/MainColumn/LifeFeedPanel/MarginContainer/LifeFeed
@onready var health_bar: ProgressBar = $SafeArea/MainColumn/StatsContainer/HealthBar
@onready var happiness_bar: ProgressBar = $SafeArea/MainColumn/StatsContainer/HappinessBar
@onready var smarts_bar: ProgressBar = $SafeArea/MainColumn/StatsContainer/SmartsBar
@onready var looks_bar: ProgressBar = $SafeArea/MainColumn/StatsContainer/LooksBar
@onready var age_button: Button = $SafeArea/MainColumn/AgeButton
@onready var settings_panel: PanelContainer = $SettingsPanel
@onready var reset_confirmation: ConfirmationDialog = $ResetConfirmation
@onready var new_game_panel: PanelContainer = $NewGamePanel
@onready var name_input: LineEdit = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/NameInput
@onready var birthplace_input: LineEdit = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/BirthplaceInput
@onready var validation_label: Label = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/ValidationLabel
@onready var name_label: Label = $SafeArea/MainColumn/NameLabel

@onready var timeline_panel: Control = $SafeArea
@onready var history_panel: PanelContainer = $HistoryPanel
@onready var character_panel: PanelContainer = $CharacterPanel
@onready var history_list: VBoxContainer = $HistoryPanel/HistoryMargin/HistoryContent/HistoryScroll/HistoryList

@onready var character_name: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterName
@onready var character_age: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterAge
@onready var character_birthplace: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterBirthplace
@onready var character_money: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterMoney
@onready var character_karma: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterKarma

@onready var event_overlay: Control = get_node_or_null("EventOverlay") as Control
@onready var event_title: Label = _find_event_node("EventTitle") as Label
@onready var event_description: RichTextLabel = _find_event_node("EventDescription") as RichTextLabel
@onready var event_choice_1: Button = _find_event_node("EventChoice1") as Button
@onready var event_choice_2: Button = _find_event_node("EventChoice2") as Button
@onready var event_choice_3: Button = _find_event_node("EventChoice3") as Button
@onready var event_choice_4: Button = _find_event_node("EventChoice4") as Button


func _ready() -> void:
	_configure_ui()
	_connect_runtime_signals()

	var loaded: bool = SaveManager.load_game()

	if event_overlay != null:
		event_overlay.visible = false

	history_panel.visible = false
	character_panel.visible = false
	settings_panel.visible = false
	timeline_panel.visible = true

	if loaded and PlayerData.has_started_game:
		hide_new_game_screen()
		rebuild_life_feed()
		update_ui()
	else:
		show_new_game_screen()


func _connect_runtime_signals() -> void:
	var reset_button := get_node_or_null("SettingsPanel/SettingsContent/ResetProgressButton") as Button
	if reset_button != null and not reset_button.pressed.is_connected(_on_reset_progress_button_pressed):
		reset_button.pressed.connect(_on_reset_progress_button_pressed)

	if not reset_confirmation.confirmed.is_connected(_on_reset_confirmation_confirmed):
		reset_confirmation.confirmed.connect(_on_reset_confirmation_confirmed)

	var timeline_button := get_node_or_null("BottomNavigation/NavButtons/TimelineButton") as Button
	if timeline_button != null and not timeline_button.pressed.is_connected(_on_timeline_button_pressed):
		timeline_button.pressed.connect(_on_timeline_button_pressed)

	var history_button := get_node_or_null("BottomNavigation/NavButtons/HistoryButton") as Button
	if history_button != null and not history_button.pressed.is_connected(_on_history_button_pressed):
		history_button.pressed.connect(_on_history_button_pressed)

	var character_button := get_node_or_null("BottomNavigation/NavButtons/CharacterButton") as Button
	if character_button != null and not character_button.pressed.is_connected(_on_character_button_pressed):
		character_button.pressed.connect(_on_character_button_pressed)

	var settings_button := get_node_or_null("BottomNavigation/NavButtons/SettingsNavButton") as Button
	if settings_button != null and not settings_button.pressed.is_connected(_on_settings_nav_button_pressed):
		settings_button.pressed.connect(_on_settings_nav_button_pressed)


func _configure_ui() -> void:
	name_label.add_theme_font_size_override("font_size", 46)
	age_label.add_theme_font_size_override("font_size", 28)
	life_feed.add_theme_font_size_override("normal_font_size", 28)
	life_feed.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var life_margin := get_node_or_null("SafeArea/MainColumn/LifeFeedPanel/MarginContainer") as MarginContainer
	if life_margin != null:
		life_margin.add_theme_constant_override("margin_left", 30)
		life_margin.add_theme_constant_override("margin_right", 30)
		life_margin.add_theme_constant_override("margin_top", 24)
		life_margin.add_theme_constant_override("margin_bottom", 24)

	var history_margin := get_node_or_null("HistoryPanel/HistoryMargin") as MarginContainer
	if history_margin != null:
		history_margin.add_theme_constant_override("margin_left", 50)
		history_margin.add_theme_constant_override("margin_right", 50)
		history_margin.add_theme_constant_override("margin_top", 80)
		history_margin.add_theme_constant_override("margin_bottom", 180)

	var character_margin := get_node_or_null("CharacterPanel/CharacterMargin") as MarginContainer
	if character_margin != null:
		character_margin.add_theme_constant_override("margin_left", 50)
		character_margin.add_theme_constant_override("margin_right", 50)
		character_margin.add_theme_constant_override("margin_top", 80)
		character_margin.add_theme_constant_override("margin_bottom", 180)

	var history_title := get_node_or_null("HistoryPanel/HistoryMargin/HistoryContent/HistoryTitle") as Label
	if history_title != null:
		history_title.add_theme_font_size_override("font_size", 42)

	character_name.add_theme_font_size_override("font_size", 36)
	character_age.add_theme_font_size_override("font_size", 30)
	character_birthplace.add_theme_font_size_override("font_size", 30)
	character_money.add_theme_font_size_override("font_size", 30)
	character_karma.add_theme_font_size_override("font_size", 30)

	var character_content := get_node_or_null("CharacterPanel/CharacterMargin/CharacterContent") as VBoxContainer
	if character_content != null:
		character_content.add_theme_constant_override("separation", 20)

	for path in [
		"BottomNavigation/NavButtons/TimelineButton",
		"BottomNavigation/NavButtons/HistoryButton",
		"BottomNavigation/NavButtons/CharacterButton",
		"BottomNavigation/NavButtons/SettingsNavButton"
	]:
		var button := get_node_or_null(path) as Button
		if button != null:
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.size_flags_vertical = Control.SIZE_FILL
			button.custom_minimum_size.y = 120
			button.add_theme_font_size_override("font_size", 22)


func _find_event_node(node_name: String) -> Node:
	var direct_path := "EventOverlay/EventPanel/EventContent/" + node_name
	var margin_path := "EventOverlay/EventPanel/MarginContainer/EventContent/" + node_name
	var choices_direct_path := "EventOverlay/EventPanel/EventContent/EventChoices/" + node_name
	var choices_margin_path := "EventOverlay/EventPanel/MarginContainer/EventContent/EventChoices/" + node_name

	for path in [direct_path, margin_path, choices_direct_path, choices_margin_path]:
		var node: Node = get_node_or_null(path)
		if node != null:
			return node

	return null


func age_up() -> void:
	if current_event != null:
		return

	PlayerData.age += 1
	randomize_stats()

	var year_word: String = "year" if PlayerData.age == 1 else "years"
	add_life_event("You turned %d %s old." % [PlayerData.age, year_word])

	trigger_event()
	update_ui()
	SaveManager.save_game()


func randomize_stats() -> void:
	var random_effects := {
		"health": randi_range(-5, 3),
		"happiness": randi_range(-4, 4),
		"smarts": randi_range(0, 2),
		"looks": randi_range(-2, 2)
	}

	PlayerData.apply_effects(random_effects)


func add_life_event(text: String) -> void:
	if text.strip_edges() == "":
		return

	if life_feed.text.strip_edges() == "":
		life_feed.append_text(text)
	else:
		life_feed.append_text("\n\n" + text)

	PlayerData.add_life_log_entry(text)


func rebuild_life_feed() -> void:
	life_feed.clear()

	for entry in PlayerData.life_log:
		var text_value: String = str(entry.get("text", ""))
		if text_value == "":
			continue

		if life_feed.text.strip_edges() == "":
			life_feed.append_text(text_value)
		else:
			life_feed.append_text("\n\n" + text_value)


func update_ui() -> void:
	name_label.text = PlayerData.first_name
	age_label.text = "Age: %d" % PlayerData.age

	health_bar.value = PlayerData.health
	happiness_bar.value = PlayerData.happiness
	smarts_bar.value = PlayerData.smarts
	looks_bar.value = PlayerData.looks


func _on_age_button_pressed() -> void:
	age_up()


func trigger_event() -> void:
	current_event = EventManager.get_random_event(
		PlayerData.age,
		PlayerData.event_history,
		PlayerData.get_stats()
	)

	if current_event == null:
		current_event_choices.clear()
		age_button.disabled = false
		return

	current_event_choices = generate_event_choices(current_event)
	show_event_popup()


func get_event_text(event: Dictionary) -> String:
	var variants: Array = event.get("text_variants", [])

	if not variants.is_empty():
		return str(variants.pick_random())

	return str(event.get("text", "Something happened."))


func generate_event_choices(event: Dictionary) -> Array:
	var all_choices: Array = event.get("choices", []).duplicate()
	all_choices.shuffle()

	var requested_count: int = int(event.get("choice_count", 3))
	var choice_count: int = min(requested_count, all_choices.size())

	return all_choices.slice(0, choice_count)


func show_event_popup() -> void:
	if event_overlay == null or event_description == null:
		push_error("Event popup nodes are missing.")
		current_event = null
		current_event_choices.clear()
		age_button.disabled = false
		return

	if event_title != null:
		event_title.text = str(current_event.get("title", "LIFE EVENT"))

	event_description.text = get_event_text(current_event) + "\n\nWhat do you do?"
	event_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_description.add_theme_font_size_override("normal_font_size", 30)

	event_overlay.visible = true
	age_button.disabled = true

	var buttons: Array[Button] = []
	for button in [event_choice_1, event_choice_2, event_choice_3, event_choice_4]:
		if button != null:
			buttons.append(button)
			button.visible = false

	for i in range(min(current_event_choices.size(), buttons.size())):
		buttons[i].text = str(current_event_choices[i].get("text", "Choose"))
		buttons[i].visible = true


func hide_event_popup() -> void:
	if event_overlay != null:
		event_overlay.visible = false


func choose_event_option(choice_index: int) -> void:
	if current_event == null:
		return

	if choice_index < 0 or choice_index >= current_event_choices.size():
		return

	var choice: Dictionary = current_event_choices[choice_index]
	PlayerData.apply_effects(choice.get("effects", {}))

	var result_text: String = str(choice.get("result", ""))
	if result_text != "":
		add_life_event(result_text)

	var event_id: String = str(current_event.get("id", ""))
	PlayerData.record_event(event_id)

	current_event = null
	current_event_choices.clear()
	hide_event_popup()
	age_button.disabled = false
	update_ui()
	SaveManager.save_game()


func _on_event_choice_1_pressed() -> void:
	choose_event_option(0)


func _on_event_choice_2_pressed() -> void:
	choose_event_option(1)


func _on_event_choice_3_pressed() -> void:
	choose_event_option(2)


func _on_event_choice_4_pressed() -> void:
	choose_event_option(3)


func _on_settings_button_pressed() -> void:
	show_tab("settings")


func _on_close_settings_button_pressed() -> void:
	show_tab("timeline")


func _on_reset_progress_button_pressed() -> void:
	reset_confirmation.popup_centered()


func _on_reset_confirmation_confirmed() -> void:
	SaveManager.delete_save()
	PlayerData.reset_player()

	current_event = null
	current_event_choices.clear()
	hide_event_popup()

	life_feed.clear()
	update_history_panel()
	update_character_panel()
	show_tab("timeline")
	show_new_game_screen()


func show_new_game_screen() -> void:
	if name_input != null:
		name_input.text = ""

	if birthplace_input != null:
		birthplace_input.text = ""

	if validation_label != null:
		validation_label.text = ""

	new_game_panel.visible = true


func hide_new_game_screen() -> void:
	new_game_panel.visible = false


func _on_start_game_button_pressed() -> void:
	if name_input == null:
		push_error("NameInput could not be found.")
		return

	if birthplace_input == null:
		push_error("BirthplaceInput could not be found.")
		return

	if validation_label == null:
		push_error("ValidationLabel could not be found.")
		return

	var entered_name: String = name_input.text.strip_edges()
	var entered_birthplace: String = birthplace_input.text.strip_edges()

	if entered_name == "":
		validation_label.text = "Please enter your name."
		return

	if entered_birthplace == "":
		validation_label.text = "Please enter your birthplace."
		return

	validation_label.text = ""

	PlayerData.reset_player()

	PlayerData.first_name = entered_name
	PlayerData.birthplace = entered_birthplace
	PlayerData.has_started_game = true

	hide_new_game_screen()

	life_feed.clear()

	add_life_event(
		"You were born in %s." % PlayerData.birthplace
	)

	update_ui()
	update_history_panel()
	update_character_panel()

	SaveManager.save_game()


func show_tab(tab_name: String) -> void:
	timeline_panel.visible = tab_name == "timeline"
	history_panel.visible = tab_name == "history"
	character_panel.visible = tab_name == "character"
	settings_panel.visible = tab_name == "settings"


func _on_timeline_button_pressed() -> void:
	show_tab("timeline")


func _on_history_button_pressed() -> void:
	show_tab("history")
	update_history_panel()


func _on_character_button_pressed() -> void:
	show_tab("character")
	update_character_panel()


func _on_settings_nav_button_pressed() -> void:
	show_tab("settings")


func update_history_panel() -> void:
	for child in history_list.get_children():
		child.queue_free()

	for entry in PlayerData.life_log:
		var label := Label.new()
		label.text = "AGE %d\n%s" % [
			int(entry.get("age", 0)),
			str(entry.get("text", ""))
		]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.add_theme_font_size_override("font_size", 28)
		history_list.add_child(label)

		var spacer := Control.new()
		spacer.custom_minimum_size.y = 18
		history_list.add_child(spacer)


func update_character_panel() -> void:
	character_name.text = PlayerData.first_name
	character_age.text = "Age %d" % PlayerData.age
	character_birthplace.text = "Born in %s" % PlayerData.birthplace
	character_money.text = "Money  $%d" % PlayerData.money

	var karma_prefix: String = "+" if PlayerData.karma > 0 else ""
	character_karma.text = "Karma  %s%d" % [karma_prefix, PlayerData.karma]
