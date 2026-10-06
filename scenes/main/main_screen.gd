extends Control

var current_event = null

@onready var age_label: Label = $SafeArea/MainColumn/AgeLabel

@onready var life_feed: RichTextLabel = \
	$SafeArea/MainColumn/LifeFeedPanel/MarginContainer/LifeFeed

@onready var health_bar: ProgressBar = \
	$SafeArea/MainColumn/StatsContainer/HealthBar

@onready var happiness_bar: ProgressBar = \
	$SafeArea/MainColumn/StatsContainer/HappinessBar

@onready var smarts_bar: ProgressBar = \
	$SafeArea/MainColumn/StatsContainer/SmartsBar

@onready var looks_bar: ProgressBar = \
	$SafeArea/MainColumn/StatsContainer/LooksBar

@onready var choice_button_1: Button = \
	$SafeArea/MainColumn/ChoiceContainer/ChoiceButton1

@onready var choice_button_2: Button = \
	$SafeArea/MainColumn/ChoiceContainer/ChoiceButton2

@onready var choice_button_3: Button = \
	$SafeArea/MainColumn/ChoiceContainer/ChoiceButton3

@onready var age_button: Button = \
	$SafeArea/MainColumn/AgeButton

@onready var settings_panel: PanelContainer = \
	$SettingsPanel

@onready var reset_confirmation: ConfirmationDialog = \
	$ResetConfirmation

@onready var new_game_panel: PanelContainer = \
	$NewGamePanel

@onready var name_input: LineEdit = \
	$NewGamePanel/CenterContainer/NewGameContent/NameInput

@onready var birthplace_input: LineEdit = \
	$NewGamePanel/CenterContainer/NewGameContent/BirthplaceInput

@onready var name_label: Label = \
	$SafeArea/MainColumn/NameLabel

@onready var validation_label: Label = \
	$NewGamePanel/CenterContainer/NewGameContent/ValidationLabel


func _ready() -> void:
	var loaded := SaveManager.load_game()

	if loaded and PlayerData.has_started_game:
		hide_new_game_screen()
		update_ui()
	else:
		show_new_game_screen()


func age_up() -> void:
	PlayerData.age += 1

	randomize_stats()

	var year_word := "year" if PlayerData.age == 1 else "years"

	add_life_event(
		"You turned %d %s old." % [
			PlayerData.age,
			year_word
		]
	)

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
	life_feed.append_text("\n\n" + text)


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
		hide_choice_buttons()
		age_button.disabled = false
		return

	add_life_event(current_event["text"])

	show_event_choices()

	age_button.disabled = true

func show_event_choices() -> void:
	hide_choice_buttons()

	var choices: Array = current_event.get("choices", [])

	var buttons := [
		choice_button_1,
		choice_button_2,
		choice_button_3
	]

	for i in range(min(choices.size(), buttons.size())):
		buttons[i].text = choices[i]["text"]
		buttons[i].visible = true

func hide_choice_buttons() -> void:
	choice_button_1.visible = false
	choice_button_2.visible = false
	choice_button_3.visible = false

func choose_event_option(choice_index: int) -> void:
	if current_event == null:
		return

	var choices: Array = current_event.get("choices", [])

	if choice_index < 0 or choice_index >= choices.size():
		return

	var choice = choices[choice_index]

	PlayerData.apply_effects(
		choice.get("effects", {})
	)

	var result_text: String = choice.get("result", "")

	if result_text != "":
		add_life_event(result_text)

	var event_id: String = current_event.get("id", "")

	PlayerData.record_event(event_id)

	current_event = null

	hide_choice_buttons()

	age_button.disabled = false

	update_ui()

	SaveManager.save_game()

func _on_choice_button_1_pressed() -> void:
	choose_event_option(0)


func _on_choice_button_2_pressed() -> void:
	choose_event_option(1)


func _on_choice_button_3_pressed() -> void:
	choose_event_option(2)

func _on_settings_button_pressed() -> void:
	settings_panel.visible = true

func _on_close_settings_button_pressed() -> void:
	settings_panel.visible = false

func _on_reset_progress_button_pressed() -> void:
	reset_confirmation.popup_centered()

func _on_reset_confirmation_confirmed() -> void:
	SaveManager.delete_save()
	PlayerData.reset_player()

	settings_panel.visible = false

	show_new_game_screen()

func show_new_game_screen() -> void:
	new_game_panel.visible = true

func hide_new_game_screen() -> void:
	new_game_panel.visible = false

func _on_start_game_button_pressed() -> void:
	var entered_name := name_input.text.strip_edges()
	var entered_birthplace := birthplace_input.text.strip_edges()

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

	SaveManager.save_game()
