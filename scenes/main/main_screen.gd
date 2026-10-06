extends Control

var age: int = 0

var health: int = 80
var happiness: int = 75
var smarts: int = 60
var looks: int = 65

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


func _ready() -> void:
	update_ui()


func age_up() -> void:
	age += 1

	randomize_stats()

	var year_word := "year" if age == 1 else "years"

	add_life_event(
		"You turned %d %s old." % [age, year_word]
	)

	update_ui()


func randomize_stats() -> void:
	health += randi_range(-5, 3)
	happiness += randi_range(-4, 4)
	smarts += randi_range(0, 2)
	looks += randi_range(-2, 2)

	health = clamp(health, 0, 100)
	happiness = clamp(happiness, 0, 100)
	smarts = clamp(smarts, 0, 100)
	looks = clamp(looks, 0, 100)


func add_life_event(text: String) -> void:
	life_feed.append_text("\n\n" + text)


func update_ui() -> void:
	age_label.text = "Age: %d" % age

	health_bar.value = health
	happiness_bar.value = happiness
	smarts_bar.value = smarts
	looks_bar.value = looks


func _on_age_button_pressed() -> void:
	age_up()
