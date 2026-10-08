extends Node

func _ready() -> void:
	print("--- BEGIN TEST: NESTED CAREERS & OCCUPATIONS CATEGORIES ---")
	var main_scene = load("res://scenes/main/main_screen.tscn")
	var main = main_scene.instantiate()
	add_child(main)
	await get_tree().process_frame

	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()

	# 1. Verify JobManager categories
	var cats = JobManager.get_categories()
	print("Total categories loaded: ", cats.size())
	assert(cats.size() >= 11, "Must have at least 11 categories loaded")

	var cat_ids: Array = []
	for c in cats:
		cat_ids.append(c.id)
	assert("fast_food" in cat_ids, "F&B category must exist")
	assert("retail" in cat_ids, "Retail category must exist")
	assert("it_tech" in cat_ids, "IT Tech category must exist")
	assert("medical_healthcare" in cat_ids, "Healthcare category must exist")
	assert("trades_craft" in cat_ids, "Trades category must exist")
	assert("finance_business" in cat_ids, "Finance category must exist")
	assert("legal_public_service" in cat_ids, "Legal category must exist")
	assert("arts_entertainment" in cat_ids, "Arts category must exist")
	assert("aviation_maritime" in cat_ids, "Aviation category must exist")
	assert("entry_odd_jobs" in cat_ids, "Odd Jobs category must exist")
	assert("underworld_crime" in cat_ids, "Underworld category must exist")
	print("✔ All 11 core categories verified.")

	# 2. Verify all jobs have valid categories
	var all_jobs = JobManager.get_all_jobs()
	print("Total jobs loaded: ", all_jobs.size())
	assert(all_jobs.size() >= 60, "Must have at least 60 jobs loaded across categories")
	for j in all_jobs:
		assert(j.category in cat_ids, "Job %s has invalid category: %s" % [j.id, j.category])
	print("✔ All jobs belong to valid categories.")

	# 3. Verify F&B jobs exist and include both entry and advanced roles
	var fb_jobs = JobManager.get_jobs_in_category("fast_food")
	print("F&B jobs count: ", fb_jobs.size())
	assert(fb_jobs.size() >= 8, "F&B category must contain at least 8 nested jobs")
	var fb_ids: Array = []
	for j in fb_jobs:
		fb_ids.append(j.id)
	assert("ff_dishwasher" in fb_ids, "Must contain dishwasher")
	assert("ff_barista" in fb_ids, "Must contain barista")
	assert("fb_mixologist" in fb_ids, "Must contain mixologist")
	assert("fb_sous_chef" in fb_ids, "Must contain sous chef")
	assert("fb_head_chef" in fb_ids, "Must contain executive head chef")
	assert("fb_restaurateur" in fb_ids, "Must contain restaurateur")
	print("✔ F&B jobs list verified.")

	# 4. Verify unique requirements validation (e.g. required_license)
	PlayerData.reset()
	PlayerData.age = 22
	PlayerData.health = 80
	PlayerData.smarts = 80
	PlayerData.looks = 70
	PlayerData.happiness = 80
	PlayerData.karma = 50
	PlayerData.grades = 85
	PlayerData.education_level = "High School Graduate"
	PlayerData.licenses.clear()

	# Mixologist requires license_mixologist
	var mixo_job = JobManager.get_job_by_id("fb_mixologist")
	var eval1 = JobManager.can_apply(mixo_job, PlayerData.age, PlayerData.get_stats(), {"licenses": PlayerData.licenses})
	assert(not eval1.allowed, "Mixologist must be locked without license_mixologist")
	assert("Licensing" in eval1.reason or "Mixologist" in eval1.reason, "Must cite license requirement")
	print("✔ License gating verified for Mixologist: ", eval1.reason)

	# Grant license and re-evaluate
	PlayerData.grant_license("license_mixologist")
	var eval2 = JobManager.can_apply(mixo_job, PlayerData.age, PlayerData.get_stats(), {"licenses": PlayerData.licenses})
	assert(eval2.allowed, "Mixologist must be allowed after earning license")
	print("✔ Mixologist qualification verified with license.")

	# Head Chef requires food_science major
	var chef_job = JobManager.get_job_by_id("fb_head_chef")
	PlayerData.age = 26
	PlayerData.education_level = "University Graduate"
	PlayerData.university_major = "business"
	var eval3 = JobManager.can_apply(chef_job, PlayerData.age, PlayerData.get_stats(), {
		"grades": 85,
		"education_level": PlayerData.education_level,
		"major": PlayerData.university_major,
		"degrees": []
	})
	assert(not eval3.allowed, "Head Chef must require food_science major")
	assert("Food Science" in eval3.reason, "Reason must mention Food Science: " + eval3.reason)
	print("✔ Major requirement verified for Head Chef: ", eval3.reason)

	PlayerData.university_major = "food_science"
	PlayerData.age = 26
	var eval4 = JobManager.can_apply(chef_job, PlayerData.age, PlayerData.get_stats(), {
		"grades": 85,
		"education_level": PlayerData.education_level,
		"major": PlayerData.university_major,
		"degrees": []
	})
	assert(eval4.allowed, "Head Chef allowed with food_science major and qualifications")
	print("✔ Head Chef qualification verified.")

	# Pilot requires license_pilot
	var pilot_job = JobManager.get_job_by_id("trans_airline_pilot")
	var eval5 = JobManager.can_apply(pilot_job, PlayerData.age, PlayerData.get_stats(), {"licenses": PlayerData.licenses})
	assert(not eval5.allowed, "Pilot must be locked without license_pilot")
	PlayerData.grant_license("license_pilot")
	var eval6 = JobManager.can_apply(pilot_job, PlayerData.age, PlayerData.get_stats(), {"licenses": PlayerData.licenses})
	assert(eval6.allowed, "Pilot allowed with license_pilot")
	print("✔ Pilot license requirement verified.")

	# 5. Test UI Modal Navigation
	print("Testing Careers Hub Modal Navigation...")
	main._show_jobs_modal()
	assert(main.jobs_modal_overlay != null and is_instance_valid(main.jobs_modal_overlay), "Jobs modal overlay must be open")

	# Find category buttons inside jobs modal
	var cat_buttons: Array = []
	for node in main.jobs_modal_overlay.find_children("*", "Button", true, false):
		if "Openings" in node.text or "Positions" in node.text or "Roles" in node.text:
			cat_buttons.append(node)
	print("Found category buttons count: ", cat_buttons.size())
	assert(cat_buttons.size() >= 11, "Must render buttons for all 11 categories")

	# Open F&B category panel
	main._show_job_category_modal("fast_food")
	assert(main.job_category_modal_overlay != null and is_instance_valid(main.job_category_modal_overlay), "Category modal must open")
	var category_labels = main.job_category_modal_overlay.find_children("*", "Label", true, false)
	var found_header := false
	for l in category_labels:
		if "FOOD & BEVERAGE" in l.text or "F&B" in l.text:
			found_header = true
			break
	assert(found_header, "Category modal must display F&B header")
	print("✔ F&B dedicated category panel opened with correct header.")

	# Check back button
	var back_btn_found := false
	for btn in main.job_category_modal_overlay.find_children("*", "Button", true, false):
		if "Back to All" in btn.text:
			back_btn_found = true
			btn.emit_signal("pressed")
			break
	assert(back_btn_found, "Category modal must contain Back button")
	await get_tree().process_frame
	assert(main.jobs_modal_overlay != null and is_instance_valid(main.jobs_modal_overlay), "Back button must return to main jobs modal")
	print("✔ Back button returns to main careers hub.")

	# Apply for a job inside category modal
	main._show_job_category_modal("fast_food")
	main.apply_for_job("ff_dishwasher")
	assert(PlayerData.job_id == "ff_dishwasher", "Player must be hired as dishwasher")
	print("✔ Player successfully applied and hired: ", PlayerData.job_title)

	main.jobs_modal_overlay.queue_free()
	if main.job_category_modal_overlay != null and is_instance_valid(main.job_category_modal_overlay):
		main.job_category_modal_overlay.queue_free()
	main.queue_free()

	print("--- ALL NESTED CAREERS & OCCUPATIONS TESTS PASSED SUCCESSFULLY! ---")
	get_tree().quit()
