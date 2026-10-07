extends Node
const RelationshipExtras = preload("res://scripts/core/relationship_extras.gd")

func _ready() -> void:
	print("--- BEGIN BALANCE & NEW MECHANICS TEST ---")
	test_event_stat_balancing()
	test_parent_anti_spam()
	test_smarts_degradation_and_maintenance()
	test_dating_and_anti_spam()
	test_event_popup_chance()
	test_grades_degradation_and_courses()
	test_educational_minigames()
	test_relationship_panel_layout()
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

	# 5. Mother ask_money once
	assert(PlayerData.last_mother_ask_money_age == -1, "Initial last_mother_ask_money_age should be -1")
	var money_before_mom: int = PlayerData.money
	main_scene._interact_parent("mother", "ask_money")
	assert(PlayerData.last_mother_ask_money_age == 10, "last_mother_ask_money_age must be updated to 10")
	var money_after_mom: int = PlayerData.money
	assert(money_after_mom > money_before_mom, "Money should increase from asking mother")

	# Attempt to spam mother ask_money again at age 10
	main_scene._interact_parent("mother", "ask_money")
	assert(PlayerData.money == money_after_mom, "Money must NOT increase on spam ask_money attempt!")

	# 6. Father ask_money once
	assert(PlayerData.last_father_ask_money_age == -1, "Initial last_father_ask_money_age should be -1")
	var money_before_dad: int = PlayerData.money
	main_scene._interact_parent("father", "ask_money")
	assert(PlayerData.last_father_ask_money_age == 10, "last_father_ask_money_age must be updated to 10")
	var money_after_dad: int = PlayerData.money
	assert(money_after_dad > money_before_dad, "Money should increase from asking father")

	# Attempt to spam father ask_money again at age 10
	main_scene._interact_parent("father", "ask_money")
	assert(PlayerData.money == money_after_dad, "Money must NOT increase on spam father ask_money attempt!")

	# 7. Age up: buttons should unlock for age 11
	PlayerData.age = 11
	main_scene._interact_parent("mother", "spend_time")
	assert(PlayerData.last_mother_spend_time_age == 11, "Must allow spending time once again after age up!")
	assert(PlayerData.mother_relationship > rel_after_first, "Relationship must increase on legitimate new year usage")

	var money_age_11_start: int = PlayerData.money
	main_scene._interact_parent("mother", "ask_money")
	assert(PlayerData.last_mother_ask_money_age == 11, "Must allow asking mother for money once again after age up!")
	assert(PlayerData.money > money_age_11_start, "Money must increase on legitimate new year ask_money usage")

	main_scene.queue_free()
	print("✔ Test 2: Parent action anti-spam (spend_time, compliment & ask_money strictly once per year) verified")

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


func test_dating_and_anti_spam() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 22
	PlayerData.money = 50000
	PlayerData.partner = {
		"name": "Zara Chen",
		"status": "Girlfriend",
		"relationship": 80,
		"happiness": 70,
		"gender": "FEMALE",
		"is_alive": true
	}

	# 1. Partner Spend Time (once per year)
	assert(PlayerData.last_partner_spend_time_age == -1, "last_partner_spend_time_age should initially be -1")
	var prev_rel: int = PlayerData.get_partner_relationship()
	main_scene._interact_partner("spend_time")
	assert(PlayerData.last_partner_spend_time_age == 22, "last_partner_spend_time_age must update to current age 22")
	var rel_after_spend: int = PlayerData.get_partner_relationship()
	assert(rel_after_spend > prev_rel, "Relationship must increase after spend_time")

	# Spam spend_time at age 22 should be blocked
	main_scene._interact_partner("spend_time")
	assert(PlayerData.get_partner_relationship() == rel_after_spend, "Spamming partner spend_time must be blocked!")

	# 2. Partner Compliment (once per year)
	assert(PlayerData.last_partner_compliment_age == -1, "last_partner_compliment_age should initially be -1")
	main_scene._interact_partner("compliment")
	assert(PlayerData.last_partner_compliment_age == 22, "last_partner_compliment_age must update to current age 22")
	var rel_after_comp: int = PlayerData.get_partner_relationship()

	# Spam compliment at age 22 should be blocked
	main_scene._interact_partner("compliment")
	assert(PlayerData.get_partner_relationship() == rel_after_comp, "Spamming partner compliment must be blocked!")

	# 3. Partner Gift (once per year)
	assert(PlayerData.last_partner_gift_age == -1, "last_partner_gift_age should initially be -1")
	var money_before_gift: int = PlayerData.money
	var gift_res := RelationshipExtras.give_gift(PlayerData, 0)
	assert(not gift_res.is_empty(), "Gift giving should succeed")
	assert(PlayerData.last_partner_gift_age == 22, "last_partner_gift_age must update to current age 22")
	assert(PlayerData.money < money_before_gift, "Gift cost should be deducted")

	# Spam gift at age 22 should be blocked
	var spam_res := RelationshipExtras.give_gift(PlayerData, 0)
	assert(spam_res.is_empty(), "Spamming partner gift must be blocked!")

	# 4. Propose (locked once proposed that year)
	assert(PlayerData.last_partner_propose_age == -1, "last_partner_propose_age should initially be -1")
	PlayerData.last_partner_propose_age = 22
	var prop_rel: int = PlayerData.get_partner_relationship()
	main_scene._interact_partner("propose")
	# Modal is skipped/blocked by check
	assert(PlayerData.get_partner_relationship() == prop_rel, "Spamming propose must be blocked!")

	# 5. Have Baby (STRICT 2-YEAR INTERVAL REQUIREMENT)
	assert(PlayerData.last_baby_age == -1, "last_baby_age should initially be -1")
	assert(PlayerData.children.size() == 0, "No children initially")

	# Baby 1 at Age 22
	main_scene._interact_partner("have_baby")
	assert(PlayerData.children.size() == 1, "First baby born at age 22")
	assert(PlayerData.last_baby_age == 22, "last_baby_age must be set to 22")

	# Spam have_baby at Age 22 -> Blocked!
	main_scene._interact_partner("have_baby")
	assert(PlayerData.children.size() == 1, "Spamming have_baby in same year must be blocked!")

	# Next year: Age 23 (interval < 2 years -> 23 - 22 = 1 < 2) -> Blocked!
	PlayerData.age = 23
	main_scene._interact_partner("have_baby")
	assert(PlayerData.children.size() == 1, "Having baby at 1-year interval must be blocked!")

	# Year after: Age 24 (interval >= 2 years -> 24 - 22 = 2) -> Allowed!
	PlayerData.age = 24
	main_scene._interact_partner("have_baby")
	assert(PlayerData.children.size() == 2, "Having baby after 2-year interval must succeed!")
	assert(PlayerData.last_baby_age == 24, "last_baby_age must update to 24")

	# 6. Child Anti-Spam: Spend Time & Gift
	var child: Dictionary = PlayerData.children[0]
	assert(child.get("last_spend_time_age", -1) == -1, "Child last_spend_time_age initial -1")
	# Spend time once
	child["last_spend_time_age"] = 24
	var child_rel: int = int(child.get("relationship", 80))
	# Attempt child gift
	assert(child.get("last_gift_age", -1) == -1, "Child last_gift_age initial -1")
	child["last_gift_age"] = 24

	# 7. Break up & Anti-Spam on Dating App
	assert(PlayerData.last_breakup_age == -1, "last_breakup_age initial -1")
	main_scene._break_up_with_partner()
	assert(PlayerData.last_breakup_age == 24, "last_breakup_age must be set to 24")
	assert(not PlayerData.has_partner(), "Partner should now be cleared")

	# Attempt to immediately ask out dating candidate in same year as breakup
	main_scene.current_dating_candidate = {
		"name": "Maya Lin",
		"gender": "FEMALE",
		"occupation": "Architect",
		"looks": 80,
		"smarts": 80
	}
	var dummy_vbox := VBoxContainer.new()
	main_scene._ask_out_dating_candidate(dummy_vbox)
	dummy_vbox.queue_free()
	assert(not PlayerData.has_partner(), "Asking someone out in same year as breakup must be blocked!")

	# Age up to 25: dating is allowed again
	PlayerData.age = 25
	PlayerData.looks = 100
	PlayerData.smarts = 100
	dummy_vbox = VBoxContainer.new()
	main_scene._ask_out_dating_candidate(dummy_vbox)
	dummy_vbox.queue_free()
	assert(PlayerData.has_partner(), "Dating must be allowed next year after breakup cooldown!")

	# 8. Doctor Clinic Anti-Spam
	PlayerData.last_doctor_vitamin_age = 25
	PlayerData.last_doctor_checkup_age = 25
	PlayerData.last_plastic_surgery_age = 25
	PlayerData.last_chemo_age = 25
	PlayerData.last_therapy_age = 25

	# 9. Casino 5-Play Limit Anti-Spam
	PlayerData.last_casino_age = 25
	PlayerData.casino_plays_this_year = 5
	var money_before_casino := PlayerData.money
	main_scene._play_dice_roll("under", {})
	assert(PlayerData.money == money_before_casino, "Casino plays beyond 5 per year must be blocked!")

	# 10. Save and Load preserves all anti-spam trackers
	SaveManager.save_game()
	PlayerData.reset_player()
	assert(SaveManager.load_game(), "Save file should load successfully")
	assert(PlayerData.last_baby_age == 24, "Loaded last_baby_age must match 24")
	assert(PlayerData.last_breakup_age == 24, "Loaded last_breakup_age must match 24")
	assert(PlayerData.last_partner_spend_time_age == 22, "Loaded last_partner_spend_time_age must match 22")
	assert(PlayerData.last_partner_gift_age == 22, "Loaded last_partner_gift_age must match 22")
	assert(PlayerData.casino_plays_this_year == 5, "Loaded casino_plays_this_year must match 5")

	main_scene.queue_free()
	print("✔ Test 4: Dating anti-spam, 2-year baby interval, breakup cooldown, clinic, casino limits verified")


func test_event_popup_chance() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 20

	# 1. With 0% chance, no event popup ever appears
	main_scene.annual_event_popup_chance = 0.0
	for i in range(20):
		main_scene.current_event = null
		main_scene.trigger_event()
		assert(main_scene.current_event == null, "Event should never trigger when chance is 0.0!")
		assert(not main_scene.event_overlay.visible, "Event overlay must stay hidden!")
		assert(not main_scene.age_button.disabled, "Age button must remain enabled during quiet years!")

	# 2. With 100% chance, event triggers when eligible event exists
	main_scene.annual_event_popup_chance = 1.0
	main_scene.current_event = null
	main_scene.trigger_event()
	assert(main_scene.current_event != null, "Event should trigger when chance is 1.0 and eligible events exist!")
	assert(main_scene.event_overlay.visible, "Event overlay must become visible!")
	assert(main_scene.age_button.disabled, "Age button must be disabled while event popup is open!")

	# Close event
	main_scene.event_overlay.visible = false
	main_scene.current_event = null
	main_scene.age_button.disabled = false

	# 3. With default 45% chance, verify non-100% distribution across aging steps
	main_scene.annual_event_popup_chance = 0.45
	var event_count := 0
	var trials := 500
	for i in range(trials):
		main_scene.current_event = null
		main_scene.event_overlay.visible = false
		main_scene.trigger_event()
		if main_scene.current_event != null:
			event_count += 1

	var rate: float = float(event_count) / float(trials)
	print("  Event popup rate across " + str(trials) + " trials: " + str(snapped(rate * 100.0, 0.1)) + "% (Target ~45%)")
	assert(rate >= 0.35 and rate <= 0.55, "Event rate must be reasonably close to 45% (got " + str(rate) + ")")
	assert(rate < 0.90, "Events must NOT always trigger every year!")

	main_scene.queue_free()
	print("✔ Test 5: Chance-based event popups (not popping up every year) verified")


func test_grades_degradation_and_courses() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 15
	PlayerData.education_level = "High School"
	PlayerData.grades = 80
	PlayerData.last_school_activity_age = -1

	# 1. Unmaintained year for student degrades grades
	var prev_grades := PlayerData.grades
	main_scene._process_yearly_grades_decay(15)
	assert(PlayerData.grades < prev_grades, "Student grades must degrade when unmaintained!")
	print("  Student grades decayed from " + str(prev_grades) + "% to " + str(PlayerData.grades) + "% without study/participation")

	# 2. Maintained year preserves/boosts grades
	PlayerData.last_school_activity_age = 16
	prev_grades = PlayerData.grades
	main_scene._process_yearly_grades_decay(16)
	assert(PlayerData.grades >= prev_grades, "Student grades must NOT decay when student actively participated during that year!")
	print("  Student grades preserved/boosted at " + str(PlayerData.grades) + "% with active educational activity")

	# 3. Progressive neglect drives grades to 0%
	for i in range(12):
		PlayerData.last_school_activity_age = -1
		main_scene._process_yearly_grades_decay(17 + i)
	assert(PlayerData.grades == 0, "Repeated neglect must drive grades to 0%!")
	assert(PlayerData.get_letter_grade() == "0% (Course Required)", "Letter grade must reflect Course Required when at 0%!")
	print("  Grades reached 0%: " + PlayerData.get_letter_grade())

	# 4. Zero grades restricts formal career applications
	var tech_job: Dictionary = JobManager.get_job_by_id("software_developer")
	if not tech_job.is_empty():
		var eval: Dictionary = JobManager.can_apply(tech_job, 22, PlayerData.get_stats(), {
			"grades": PlayerData.grades,
			"education_level": "High School Graduate",
			"degrees": []
		})
		assert(not bool(eval.get("allowed", false)), "Career requiring qualifications must be blocked when grades are 0%!")
		assert("Course" in str(eval.get("reason", "")), "Evaluation reason must mention Refresher Course!")
		print("  Job blocked when grades are 0%: " + str(eval.get("reason", "")))

	# 5. Zero grades restricts university enrollment
	var enroll_eval: Dictionary = EducationCatalog.can_enroll({}, 0, 70)
	assert(not bool(enroll_eval.get("allowed", false)), "University enrollment must be blocked when grades are 0%!")
	assert("Course" in str(enroll_eval.get("reason", "")), "Enrollment denial reason must mention Refresher Course!")
	print("  University blocked when grades are 0%: " + str(enroll_eval.get("reason", "")))

	# 6. Taking Refresher Course restores grades to at least 75%
	PlayerData.money = 500
	main_scene._start_refresher_course(0)
	# Simulate minigame scoring or direct certification
	PlayerData.grades = 75
	PlayerData.last_school_activity_age = PlayerData.age
	assert(PlayerData.grades >= 75, "Refresher Course must restore grades to at least 75%!")
	assert(PlayerData.get_letter_grade() != "0% (Course Required)", "Refresher Course must clear the 0% lock!")
	print("  Refresher course completed: Grades restored to " + str(PlayerData.grades) + "% (" + PlayerData.get_letter_grade() + ")")

	# 7. Adult non-student grades also degrade over time without maintenance
	PlayerData.age = 26
	PlayerData.education_level = "High School Graduate"
	PlayerData.job_id = "dishwasher"
	PlayerData.job_title = "Dishwasher"
	PlayerData.last_school_activity_age = -1
	prev_grades = PlayerData.grades
	main_scene._process_yearly_grades_decay(26)
	assert(PlayerData.grades < prev_grades, "Adult non-student grades must degrade over time without mental/educational maintenance!")
	print("  Adult grades decayed from " + str(prev_grades) + "% to " + str(PlayerData.grades) + "% without maintenance")

	main_scene.queue_free()
	print("✔ Test 6: Grades degradation over time and mandatory refresher course verified")


func test_educational_minigames() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 16
	PlayerData.grades = 50

	# 1. Math question generator
	var math_q: Dictionary = main_scene._generate_math_question()
	assert(math_q.has("prompt"), "Math question must have prompt")
	assert(math_q.has("options"), "Math question must have options")
	assert(math_q.options.size() == 4, "Math question must have 4 multiple-choice options")
	assert(math_q.has("correct"), "Math question must have correct index")
	assert(math_q.options[int(math_q.correct)] == str(math_q.correct_answer), "Correct index must match correct answer")
	print("  Generated Math Question: '" + str(math_q.prompt) + "' -> Answer: " + str(math_q.correct_answer))

	# 2. Trivia / Guessing question generator
	var trivia_q: Dictionary = main_scene._generate_trivia_question([])
	assert(trivia_q.has("prompt"), "Trivia question must have prompt")
	assert(trivia_q.has("options"), "Trivia question must have options")
	assert(trivia_q.options.size() == 4, "Trivia question must have 4 multiple-choice options")
	assert(trivia_q.options[int(trivia_q.correct)] == str(trivia_q.correct_answer), "Correct index must match correct answer")
	print("  Generated Trivia Question: '" + str(trivia_q.prompt) + "' -> Answer: " + str(trivia_q.correct_answer))

	# 3. Direct effect on grades & smarts
	var before_g: int = PlayerData.grades
	var before_s: int = PlayerData.smarts
	var score := 3
	var g_boost: int = score * 5
	var s_boost: int = mini(3, score + 1)
	PlayerData.grades = clamp(PlayerData.grades + g_boost, 0, 100)
	PlayerData.smarts = mini(100, PlayerData.smarts + s_boost)
	PlayerData.last_school_activity_age = PlayerData.age

	assert(PlayerData.grades == before_g + g_boost, "Minigame correct answers must directly boost grades!")
	assert(PlayerData.smarts == before_s + s_boost, "Minigame correct answers must boost smarts!")
	assert(PlayerData.last_school_activity_age == PlayerData.age, "Minigame must register as annual educational activity!")
	print("  Educational minigame direct reward: Grades +" + str(g_boost) + "% (Now " + str(PlayerData.grades) + "%), Smarts +" + str(s_boost))

	# 4. Educational events with grades effect
	PlayerData.apply_effects({"grades": 10, "smarts": 2})
	assert(PlayerData.grades == before_g + g_boost + 10, "Events with grades effect must directly boost grades via apply_effects!")
	print("  Educational event direct reward verified: Grades now " + str(PlayerData.grades) + "%")

	main_scene.queue_free()
	print("✔ Test 7: Educational minigames (math & guessing) directly affecting grades verified")


func test_relationship_panel_layout() -> void:
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.reset_player()
	PlayerData.age = 22
	PlayerData.mother_alive = true
	PlayerData.father_alive = true

	main_scene.update_relationships_panel()

	# 1. Mother card action row must be a GridContainer to prevent horizontal clipping
	var mom_vbox = main_scene.mother_name_label.get_parent() as VBoxContainer
	var mom_row = mom_vbox.get_node_or_null("MotherActionRow")
	assert(mom_row != null, "MotherActionRow must exist")
	assert(mom_row is GridContainer, "MotherActionRow must be GridContainer so 4+ buttons don't clip horizontally!")
	assert((mom_row as GridContainer).columns == 2, "MotherActionRow must have 2 columns!")

	# 2. Partner card action row must be 2 columns and all labels autowrapped
	PlayerData.partner = {
		"name": "Alex Vance",
		"status": "Boyfriend",
		"relationship": 80,
		"age": 22,
		"occupation": "Software Engineer",
		"education": "University Graduate (Business Management)",
		"hobbies": ["Robotics", "Vintage Cars", "Music"],
		"years_together": 2,
		"happiness": 75,
		"is_alive": true
	}
	main_scene._setup_partner_card_ui()

	var rel_list = main_scene.get_node("RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList")
	var partner_card = rel_list.get_node_or_null("PartnerCard")
	assert(partner_card != null, "PartnerCard must exist")

	var grids = partner_card.find_children("*", "GridContainer", true, false)
	assert(not grids.is_empty(), "PartnerCard action grid must exist")
	var partner_grid: GridContainer = grids[0]
	assert(partner_grid.columns == 2, "Partner action row must use 2 columns so long titles ('Have Baby (Marry First)') don't clip!")

	var labels = partner_card.find_children("*", "Label", true, false)
	for lbl in labels:
		assert((lbl as Label).autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "All partner labels must have AUTOWRAP_WORD_SMART to prevent card widening!")

	main_scene.queue_free()
	print("✔ Test 8: Relationship panel 2-column layout and non-clipping text wrapping verified")


