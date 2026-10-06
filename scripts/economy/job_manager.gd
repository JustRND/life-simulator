extends Node

const JOBS_FILE_PATH := "res://data/economy/jobs.json"

var categories: Array = []
var jobs: Array = []
var _jobs_by_id: Dictionary = {}


func _ready() -> void:
	load_jobs()


func load_jobs() -> void:
	categories.clear()
	jobs.clear()
	_jobs_by_id.clear()

	var file := FileAccess.open(JOBS_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open jobs config at %s" % JOBS_FILE_PATH)
		return

	var text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Invalid jobs JSON format: root must be a Dictionary")
		return

	categories = data.get("categories", [])
	jobs = data.get("jobs", [])

	for job in jobs:
		if job is Dictionary and job.has("id"):
			_jobs_by_id[str(job["id"])] = job

	print("Loaded %d jobs across %d categories." % [jobs.size(), categories.size()])


func get_all_jobs() -> Array:
	return jobs


func get_categories() -> Array:
	return categories


func get_job_by_id(job_id: String) -> Dictionary:
	return _jobs_by_id.get(job_id, {})


func get_jobs_in_category(category_id: String) -> Array:
	var result: Array = []
	for job in jobs:
		if job.get("category", "") == category_id:
			result.append(job)
	return result


func can_apply(job: Dictionary, age: int, stats: Dictionary, education_data: Dictionary = {}) -> Dictionary:
	var min_age: int = int(job.get("min_age", 16))
	if age < min_age:
		return {
			"allowed": false,
			"reason": "Must be at least %d years old (currently %d)." % [min_age, age]
		}

	var reqs: Dictionary = job.get("requirements", {})

	# Education & Grades Check
	if reqs.has("min_grades"):
		var req_grade: int = int(reqs["min_grades"])
		var current_grade: int = int(education_data.get("grades", 75))
		if current_grade < req_grade:
			return {
				"allowed": false,
				"reason": "Requires %d%% academic marks (Your Grade: %d%%)." % [req_grade, current_grade]
			}

	if reqs.has("min_education"):
		var req_edu: String = str(reqs["min_education"])
		var current_edu: String = str(education_data.get("education_level", "None"))
		if req_edu == "University Graduate" and current_edu != "University Graduate":
			return {
				"allowed": false,
				"reason": "Requires University Degree (Current: %s)." % current_edu
			}
		elif req_edu == "High School Graduate" and current_edu in ["None", "High School Dropout", "Kindergarten", "Primary School", "Middle School", "High School"]:
			return {
				"allowed": false,
				"reason": "Requires High School Diploma (Current: %s)." % current_edu
			}

	if reqs.has("min_health") and int(stats.get("health", 0)) < int(reqs["min_health"]):
		return {"allowed": false, "reason": "Requires at least %d Health." % int(reqs["min_health"])}
	if reqs.has("min_smarts") and int(stats.get("smarts", 0)) < int(reqs["min_smarts"]):
		return {"allowed": false, "reason": "Requires at least %d Smarts." % int(reqs["min_smarts"])}
	if reqs.has("min_looks") and int(stats.get("looks", 0)) < int(reqs["min_looks"]):
		return {"allowed": false, "reason": "Requires at least %d Looks." % int(reqs["min_looks"])}
	if reqs.has("min_happiness") and int(stats.get("happiness", 0)) < int(reqs["min_happiness"]):
		return {"allowed": false, "reason": "Requires at least %d Happiness." % int(reqs["min_happiness"])}
	if reqs.has("min_karma") and int(stats.get("karma", 0)) < int(reqs["min_karma"]):
		return {"allowed": false, "reason": "Requires higher Karma (%d)." % int(reqs["min_karma"])}
	if reqs.has("max_karma") and int(stats.get("karma", 0)) > int(reqs["max_karma"]):
		return {"allowed": false, "reason": "Requires underworld reputation (Karma <= %d)." % int(reqs["max_karma"])}

	return {"allowed": true, "reason": "Qualified"}
