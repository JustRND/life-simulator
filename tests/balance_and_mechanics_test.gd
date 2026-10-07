extends Node

func _ready() -> void:
	print("--- BEGIN BALANCE & NEW MECHANICS TEST ---")
	test_event_stat_balancing()
	test_parent_anti_spam()
	test_smarts_degradation_and_maintenance()
	print("--- ALL BALANCE & NEW MECHANICS TESTS PASSED! ---")
	get_tree().quit(0)

func test_event_stat_balancing() -> void:
	var file := FileAccess.open("res://data/events/basic_events.json", FileAccess.READ)
	assert(file != null, "basic_events.json must exist")
	var text := file.get_as_text()
	file.close()
	var events: Array = JSON.parse_string(text)
	assert(events.size() > 0, "Events array must not be empty")

	for ev in events:
		for choice in ev.get("choices", []):
			var eff: Dictionary = choice.get("effects", {})
			for stat in ["happiness", "health", "smarts", "looks"]:
				if eff.has(stat):
					var val: int = int(eff[stat])
					assert(abs(val) <= 10, "Event %s choice stat %s (%d) exceeds max balanced threshold of 10!" % [ev.get("id"), stat, val])
			if eff.has("karma"):
				var kval: int = int(eff["karma"])
				assert(abs(kval) <= 12, "Event %s choice karma (%d) exceeds max balanced threshold of 12!" % [ev.get("id"), kval])

	print("✔ Test 1: Event stat balancing verified across all events (all deltas within bounds)")

func test_parent_anti_spam() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 10
	PlayerData.mother_alive = true
	PlayerData.father_alive = true
	PlayerData.mother_relationship = 50
	PlayerData.father_relationship = 50

	# 1. Mother spend_time once
	assert(PlayerData.last_mother_spend_time_age == -1, "Initial last_mother_spend_time_age should be -1")
	main_scene._interact_parent("mother", "spend_time")
	assert(PlayerData.last_mother_spend_time_age == 10, "last_mother_spend_time_age must be updated to 10")
	var rel_after_first: int = PlayerData.mother_relationship

	# Attempt to spam spend_time again at age 10
	main_scene._interact_parent("mother", "spend_time")
	assert(PlayerData.mother_relationship == rel_after_first, "Mother relationship must NOT increase on spam attempt!")

	# 2. Mother compliment once
	assert(PlayerData.last_mother_compliment_age == -1, "Initial last_mother_compliment_age should be -1")
	main_scene._interact_parent("mother", "compliment")
	assert(PlayerData.last_mother_compliment_age == 10, "last_mother_compliment_age must be updated to 10")
	var rel_comp_first: int = PlayerData.mother_relationship

	# Attempt to spam compliment again at age 10
	main_scene._interact_parent("mother", "compliment")
	assert(PlayerData.mother_relationship == rel_comp_first, "Mother relationship must NOT increase on spam compliment!")

	# 3. Father spend_time once
	assert(PlayerData.last_father_spend_time_age == -1, "Initial last_father_spend_time_age should be -1")
	main_scene._interact_parent("father", "spend_time")
	assert(PlayerData.last_father_spend_time_age == 10, "last_father_spend_time_age must be updated to 10")
	var dad_rel_first: int = PlayerData.father_relationship

	# Attempt to spam father spend_time again at age 10
	main_scene._interact_parent("father", "spend_time")
	assert(PlayerData.father_relationship == dad_rel_first, "Father relationship must NOT increase on spam spend_time!")

	# 4. Father compliment once
	assert(PlayerData.last_father_compliment_age == -1, "Initial last_father_compliment_age should be -1")
	main_scene._interact_parent("father", "compliment")
	assert(PlayerData.last_father_compliment_age == 10, "last_father_compliment_age must be updated to 10")
	var dad_comp_first: int = PlayerData.father_relationship

	# Attempt to spam father compliment again at age 10
	main_scene._interact_parent("father", "compliment")
	assert(PlayerData.father_relationship == dad_comp_first, "Father relationship must NOT increase on spam compliment!")

	# 5. Age up: buttons should unlock for age 11
	PlayerData.age = 11
	main_scene._interact_parent("mother", "spend_time")
	assert(PlayerData.last_mother_spend_time_age == 11, "Must allow spending time once again after age up!")
	assert(PlayerData.mother_relationship > rel_after_first, "Relationship must increase on legitimate new year usage")

	main_scene.queue_free()
	print("✔ Test 2: Parent action anti-spam (spend_time & compliment strictly once per year) verified")

func test_smarts_degradation_and_maintenance() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 10
	PlayerData.education_level = "Primary School"
	PlayerData.grades = 50
	PlayerData.smarts = 70
	PlayerData.last_school_activity_age = -1

	# 1. Unmaintained year (didn't study, low grades < 60)
	var prev_smarts := PlayerData.smarts
	main_scene._process_yearly_smarts_decay(10)
	assert(PlayerData.smarts < prev_smarts, "Smarts must degrade when neglected in school!")
	print("  Smarts decayed from %d to %d without study" % [prev_smarts, PlayerData.smarts])

	# 2. Maintained year (actively studied)
	PlayerData.last_school_activity_age = 11
	prev_smarts = PlayerData.smarts
	main_scene._process_yearly_smarts_decay(11)
	assert(PlayerData.smarts == prev_smarts, "Smarts must NOT degrade when player studied during that year!")
	print("  Smarts maintained at %d with active study" % PlayerData.smarts)

	# 3. Adult non-student without study and non-intellectual job
	PlayerData.age = 25
	PlayerData.education_level = "High School Graduate"
	PlayerData.job_id = "dishwasher"
	PlayerData.job_title = "Dishwasher"
	PlayerData.last_school_activity_age = -1
	prev_smarts = PlayerData.smarts
	main_scene._process_yearly_smarts_decay(25)
	assert(PlayerData.smarts < prev_smarts, "Smarts must degrade for adult without study or intellectual job!")
	print("  Adult smarts decayed from %d to %d without mental maintenance" % [prev_smarts, PlayerData.smarts])

	# 4. Adult with intellectual job (e.g. Doctor or Software Developer)
	PlayerData.job_id = "software_engineer"
	PlayerData.job_title = "Lead Software Engineer"
	PlayerData.last_school_activity_age = -1
	prev_smarts = PlayerData.smarts
	main_scene._process_yearly_smarts_decay(26)
	assert(PlayerData.smarts == prev_smarts, "Smarts must NOT degrade for adult in an intellectual profession!")
	print("  Adult smarts maintained at %d via intellectual profession" % PlayerData.smarts)

	# 5. Cosmic Buff immunity
	PlayerData.job_id = ""
	PlayerData.job_title = ""
	PlayerData.active_buffs = ["super_smarts"]
	PlayerData.smarts = 100
	main_scene._process_yearly_smarts_decay(27)
	assert(PlayerData.smarts == 100, "Super Smarts cosmic buff must be immune to decay!")
	print("  Super Smarts cosmic buff preserved at %d" % PlayerData.smarts)

	# 6. Verify randomize_stats does not increase smarts
	PlayerData.active_buffs.clear()
	PlayerData.smarts = 60
	for i in range(10):
		main_scene.randomize_stats()
	assert(PlayerData.smarts == 60, "randomize_stats must never randomly increase Smarts!")

	main_scene.queue_free()
	print("✔ Test 3: Smarts degradation and maintenance logic verified")
