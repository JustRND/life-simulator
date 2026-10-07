extends Node
const Career = preload("res://scripts/economy/career_progression.gd")
const Underground = preload("res://scripts/economy/underground_progression.gd")

func _ready() -> void:
	var player = load("res://scripts/player/player_data.gd").new()
	add_child(player)
	assert(Career.paths().size() == JobManager.jobs.size())
	for job in JobManager.jobs:
		assert(Career.paths().has(job.id))
		player.reset_player()
		player.age = int(job.min_age)
		player.job_id = job.id
		player.job_title = job.title
		player.job_company = job.workplace
		player.job_salary = int(job.salary)
		Career.begin(player)
		var last_years := 0
		var last_salary: int = player.job_salary
		for stage in Career.paths()[job.id]:
			assert(int(stage.years) > last_years and int(stage.salary) > last_salary)
			last_years = int(stage.years)
			last_salary = int(stage.salary)
		for year in range(35):
			player.age += 1
			Career.advance_year(player)
			assert(Career.advance_year(player).is_empty())
		assert(int(player.career_progress.rank) == Career.paths()[job.id].size())
		assert(player.job_salary == last_salary)
		assert(player.job_company == job.workplace)
		var completed: int = player.career_progress.years
		player.age += 1
		player.is_in_prison = true
		Career.advance_year(player)
		assert(int(player.career_progress.years) == completed)
		player.is_in_prison = false
		player.age += 1
		Career.advance_year(player, true)
		assert(int(player.career_progress.years) == completed)
	player.reset_player()
	player.age = 16
	player.job_id = "ret_cashier"
	player.job_salary = 21500
	Career.begin(player)
	player.age = 17
	Career.advance_year(player)
	player.age = 18
	assert(not Career.advance_year(player).is_empty())
	assert(player.job_title == "Front-End Manager" and player.job_salary == 32000)
	player.career_progress = JSON.parse_string(JSON.stringify(player.career_progress))
	assert(Career.advance_year(player).is_empty())
	player.job_id = "ff_barista"
	Career.begin(player)
	assert(player.career_progress.years == 0 and player.career_progress.rank == 0)
	player.reset_player()
	player.age = 16
	assert(not Underground.join(player))
	player.age = 17
	assert(Underground.join(player))
	assert(not Underground.join(player))
	assert(Underground.attempt(player, "wire_fraud", 1.0, 0.5).is_empty())
	assert(Underground.attempt(player, "missing", 1.0, 0.5).is_empty())
	for count in range(5):
		assert(not Underground.attempt(player, "pickpocket", 1.0, 0.5).is_empty())
	assert(Underground.rank_for(int(player.underground_progress.completed)) == 1)
	assert(Underground.attempts_left(player) == 0)
	assert(Underground.attempt(player, "pickpocket", 1.0, 0.5).is_empty())
	player.underground_progress = JSON.parse_string(JSON.stringify(player.underground_progress))
	assert(Underground.attempts_left(player) == 0)
	player.age += 1
	assert(Underground.attempts_left(player) == 5)
	player.job_id = "ret_cashier"
	player.job_title = "Retail Cashier"
	Career.begin(player)
	assert(Underground.attempt(player, "shoplift", 0.0, 0.5).contains("ARRESTED"))
	assert(player.is_in_prison and player.job_id.is_empty() and player.career_progress.is_empty())
	assert(player.underground_progress.completed == 5)
	assert(Underground.attempt(player, "pickpocket", 1.0, 0.5).is_empty())
	player.is_in_prison = false
	player.age = 30
	player.underground_progress.completed = 70
	assert(Underground.rank_for(70) == 6)
	for activity in Underground.catalog().activities:
		assert(Underground.requirement(player, activity).is_empty())
	var job: Dictionary = JobManager.get_job_by_id("crime_underboss")
	var stats := {"health": 100, "smarts": 100, "looks": 100, "happiness": 100, "karma": -100, "underground_completed": 0}
	assert(not JobManager.can_apply(job, 30, stats).allowed)
	stats.underground_completed = 70
	assert(JobManager.can_apply(job, 30, stats).allowed)
	assert(JobManager.minimum_age(JobManager.get_job_by_id("crime_lookout")) == 17)
	assert(not JobManager.can_apply(JobManager.get_job_by_id("crime_lookout"), 16, stats).allowed)
	for rank in Underground.catalog().ranks:
		var required := int(rank.completed)
		if required > 0:
			assert(Underground.rank_for(required) > Underground.rank_for(required - 1))
	player.reset_player()
	assert(player.career_progress.is_empty() and player.underground_progress.is_empty())
	print("PROGRESSION_PASS: all 33 ladders, tenure reset, prison exclusions, cashier promotion, JSON persistence, criminal ranks, locks, yearly cap, arrest, reset")
	get_tree().quit()
