extends Node

var age: int = 0

var health: int = 80
var happiness: int = 75
var smarts: int = 60
var looks: int = 65

var first_name: String = ""
var birthplace: String = ""
var has_started_game: bool = false

var karma: int = 0
var money: int = 0

var event_history: Array = []
var life_log: Array = []


func reset_player() -> void:
	first_name = ""
	birthplace = ""
	has_started_game = false

	age = 0

	health = 80
	happiness = 75
	smarts = 60
	looks = 65

	karma = 0
	money = 0

	event_history.clear()
	life_log.clear()


func get_stats() -> Dictionary:
	return {
		"health": health,
		"happiness": happiness,
		"smarts": smarts,
		"looks": looks,
		"karma": karma
	}


func apply_effects(effects: Dictionary) -> void:
	health += int(effects.get("health", 0))
	happiness += int(effects.get("happiness", 0))
	smarts += int(effects.get("smarts", 0))
	looks += int(effects.get("looks", 0))
	money += int(effects.get("money", 0))
	karma += int(effects.get("karma", 0))

	health = clamp(health, 0, 100)
	happiness = clamp(happiness, 0, 100)
	smarts = clamp(smarts, 0, 100)
	looks = clamp(looks, 0, 100)
	karma = clamp(karma, -100, 100)


func add_life_log_entry(text: String) -> void:
	if text.strip_edges() == "":
		return

	life_log.append({
		"age": age,
		"text": text
	})


func has_seen_event(event_id: String) -> bool:
	return event_history.has(event_id)


func record_event(event_id: String) -> void:
	if event_id == "":
		return

	if not event_history.has(event_id):
		event_history.append(event_id)
