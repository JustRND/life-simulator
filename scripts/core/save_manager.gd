extends Node

const SAVE_PATH := "user://savegame.json"


func save_game() -> void:
	var save_data := {
		"first_name": PlayerData.first_name,
		"birthplace": PlayerData.birthplace,
		"has_started_game": PlayerData.has_started_game,
		"age": PlayerData.age,
		"health": PlayerData.health,
		"happiness": PlayerData.happiness,
		"smarts": PlayerData.smarts,
		"looks": PlayerData.looks,
		"money": PlayerData.money,
		"event_history": PlayerData.event_history
	}

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		push_error("Could not open save file.")
		return

	file.store_string(
		JSON.stringify(save_data, "\t")
	)

	file.close()

	print("Game saved.")


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		push_error("Could not open save file.")
		return false

	var json_text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)

	if typeof(data) != TYPE_DICTIONARY:
		push_error("Save file is invalid.")
		return false

	PlayerData.first_name = str(data.get("first_name", ""))
	PlayerData.birthplace = str(data.get("birthplace", ""))
	PlayerData.has_started_game = bool(
		data.get("has_started_game", false)
	)

	PlayerData.age = int(data.get("age", 0))
	PlayerData.health = int(data.get("health", 80))
	PlayerData.happiness = int(data.get("happiness", 75))
	PlayerData.smarts = int(data.get("smarts", 60))
	PlayerData.looks = int(data.get("looks", 65))
	PlayerData.money = int(data.get("money", 0))

	PlayerData.event_history = data.get(
		"event_history",
		[]
	)

	print("Game loaded.")

	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path(SAVE_PATH)
		)

	print("Save deleted.")
