extends Node

var failures := 0
var log_lines: Array[String] = []

func check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		log_lines.append("❌ FAILED: " + description)
	else:
		log_lines.append("✔ PASSED: " + description)


func _ready() -> void:
	seed(54321)
	LifeLibrary.profile_path = "user://job_test_profile.json"
	
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	
	PlayerData.reset_player()
	PlayerData.first_name = "Job Retention Tester"
	PlayerData.has_started_game = true
	PlayerData.age = 24
	PlayerData.money = 10000
	PlayerData.bank_savings = 5000
	PlayerData.health = 100
	PlayerData.happiness = 100
	PlayerData.education_level = "University Graduate"
	PlayerData.university_major = "it"
	PlayerData.grades = 90
	PlayerData.smarts = 90
	
	log_lines.append("--- TEST: JOB RETENTION REGARDLESS OF GRADES / SMARTS DECAY ---")
	
	# 1. Apply for a high-requirement job
	var tech_job: Dictionary = JobManager.get_job_by_id("it_software_engineer")
	check(not tech_job.is_empty(), "Full-Stack Software Engineer job exists in catalog")
	
	main_scene.apply_for_job("it_software_engineer")
	check(PlayerData.job_id == "it_software_engineer", "Player successfully hired as Full-Stack Software Engineer")
	var initial_job_title: String = PlayerData.job_title
	var initial_salary: int = PlayerData.job_salary
	check(initial_job_title != "", "Job title is set: %s" % initial_job_title)
	check(initial_salary > 0, "Job salary is set: $%d" % initial_salary)
	
	# 2. Artificially degrade grades and smarts far below requirements
	# Full-Stack Software Engineer requires min_grades: 80, min_smarts: 75.
	# We degrade grades to 0% and smarts to 15.
	PlayerData.grades = 0
	PlayerData.smarts = 15
	check(PlayerData.grades == 0, "Grades set to 0% (below requirements)")
	check(PlayerData.smarts == 15, "Smarts set to 15 (below requirements)")
	
	# 3. Advance multiple character years (e.g. 15 years from age 24 to 39)
	# Employed players must NEVER be fired or downsized even when grades/smarts drop.
	print("Simulating 15 years with 0% grades and 15 smarts...")
	for y in range(15):
		var savings_before: int = PlayerData.bank_savings
		main_scene.current_event = null  # Prevent popup modal lock
		PlayerData.health = 100          # Ensure survival during test loop
		main_scene.age_up()
		
		# Ensure grades stay at 0% and smarts stay low (15)
		PlayerData.grades = 0
		PlayerData.smarts = 15
		
		# Verification for each year
		check(PlayerData.job_id != "", "Year %d (Age %d): Player still employed (job_id: %s)" % [y + 1, PlayerData.age, PlayerData.job_id])
		check(PlayerData.job_title != "", "Year %d (Age %d): Job title preserved (%s)" % [y + 1, PlayerData.age, PlayerData.job_title])
		check(PlayerData.bank_savings >= savings_before, "Year %d: Player received salary despite 0%% grades" % (y + 1))
	
	check(PlayerData.job_id == "it_software_engineer", "Player is STILL employed in career after 15 years of sub-requirement grades/smarts")
	
	# 4. Clean up
	main_scene.queue_free()
	DirAccess.remove_absolute(LifeLibrary.profile_path)
	
	log_lines.append("JOB_SECURITY_TEST FINISHED: %d failures" % failures)
	var f := FileAccess.open("user://job_security_test_result.log", FileAccess.WRITE)
	if f != null:
		for l in log_lines:
			f.store_line(l)
		f.close()
	get_tree().quit(failures)
