extends Node

var awards := 0


func _ready() -> void:
	# Test storage is isolated from the user's profile, named slots and resume file.
	LifeLibrary.profile_path = "user://options_test_library.json"
	LifeLibrary.slots_path = "user://options_test_slots_" + Crypto.new().generate_random_bytes(6).hex_encode()
	LifeLibrary.resume_path = "user://options_test_resume.json"
	LifeLibrary.data = {"cities": [], "people": [], "achievements": {}, "theme": "dark", "active_slot": "", "muted": false}
	PlayerData.reset_player()
	PlayerData.first_name = "Test Life"
	PlayerData.age = 20
	PlayerData.has_started_game = true
	PlayerData.money = 1234
	assert(LifeLibrary.save_slot())
	var first_id: String = LifeLibrary.data.active_slot
	PlayerData.money = 4321
	assert(LifeLibrary.save_slot(true))
	assert(LifeLibrary.slots().size() == 1)
	assert(LifeLibrary.load_slot(first_id))
	assert(PlayerData.money == 4321)
	assert(LifeLibrary.save_slot(false))
	assert(LifeLibrary.slots().size() == 2)
	var saved_id: String = PlayerData.life_id
	PlayerData.life_id = "different-life"
	assert(LifeLibrary.current_slot().is_empty())
	assert(not LifeLibrary.save_slot(true))
	PlayerData.life_id = saved_id
	assert(LifeLibrary.slot_path("../savegame").is_empty())
	assert(not LifeLibrary.load_slot("abcdef"))
	assert(PlayerData.money == 4321)
	assert(not SaveManager.valid_data({"first_name": "Bad", "age": [], "has_started_game": true}))
	assert(LifeLibrary.add_city("Makassar", "Indonesia").is_empty())
	assert(not LifeLibrary.add_city("Makassar", "Indonesia").is_empty())
	assert(LifeLibrary.birth_location("Indonesia") == "Makassar, Indonesia")
	assert(LifeLibrary.birth_location("Japan") == "Japan")
	assert(LifeLibrary.add_person({"name": "sari putri", "country": "Indonesia", "gender": "FEMALE", "ethnicity": "asian", "portrait_track": 2}).is_empty())
	assert(LifeLibrary.custom_candidate("FEMALE").name == "Sari Putri")
	assert(LifeLibrary.custom_candidate("MALE").is_empty())
	LifeLibrary._ready()
	assert(LifeLibrary.data.people.size() == 1 and LifeLibrary.data.cities.size() == 1)
	LifeLibrary.achievement_unlocked.connect(func(_title, _description): awards += 1)
	LifeLibrary.check_achievements()
	var first_awards := awards
	assert(first_awards >= 2)
	LifeLibrary.check_achievements()
	assert(awards == first_awards)
	PlayerData.partner = {"status": "Wife"}
	LifeLibrary.check_achievements()
	assert(LifeLibrary.data.achievements.has("married"))
	var root = load("res://scenes/main/main_screen.tscn").instantiate()
	get_window().size = Vector2i(540, 960)
	add_child(root)
	await get_tree().create_timer(3.0).timeout
	root.new_game_panel.hide()
	root.show_tab("settings")
	await get_tree().create_timer(0.4).timeout
	var options = root.get_node("OptionsMenu")
	PlayerData.gender = "MALE"
	var found_custom := false
	for attempt in range(64):
		var candidate: Dictionary = root._generate_dating_candidate()
		if candidate.name == "Sari Putri":
			assert(candidate.nationality == "Indonesia")
			assert(candidate.ethnicity == "asian" and candidate.portrait_track == 2)
			found_custom = true
			break
	assert(found_custom)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://work/options-dark.png")
	LifeLibrary.data.theme = "light"
	root.get_node("ThemeController").apply_theme()
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://work/options-light.png")
	root._on_close_settings_button_pressed()
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://work/game-light.png")
	root.show_tab("settings")
	options._save_life()
	options._load_life()
	options._cities()
	options._settings()
	options._achievements()
	options._people()
	await get_tree().process_frame
	LifeLibrary.data.theme = "light"
	root.get_node("ThemeController").apply_theme()
	await get_tree().process_frame
	LifeLibrary.data.theme = "dark"
	root.get_node("ThemeController").apply_theme()
	options._queue_notice("Test Achievement", "Floating popup test")
	await get_tree().create_timer(0.4).timeout
	assert(root.get_node_or_null("AchievementToast") != null)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://work/custom-people.png")
	for entry in LifeLibrary.slots():
		DirAccess.remove_absolute(LifeLibrary.slot_path(entry.id))
	DirAccess.remove_absolute(LifeLibrary.slots_path)
	DirAccess.remove_absolute(LifeLibrary.profile_path)
	DirAccess.remove_absolute(LifeLibrary.resume_path)
	print("OPTIONS_SYSTEM_TEST_PASSED")
	get_tree().quit()
