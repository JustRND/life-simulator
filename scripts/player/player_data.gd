extends Node

var age: int = 0

var health: int = 80
var happiness: int = 75
var smarts: int = 60
var looks: int = 65

var first_name: String = ""
var birthplace: String = ""
var gender: String = "MALE"
var portrait_variant: int = 0
var has_started_game: bool = false

var birth_story: String = ""
var birth_month: String = "January"
var birth_day: int = 1
var zodiac: String = "Capricorn"

var mother_name: String = ""
var mother_job: String = ""
var mother_base_age: int = 35
var mother_relationship: int = 80
var mother_alive: bool = true
var mother_health: int = 80

var father_name: String = ""
var father_job: String = ""
var father_base_age: int = 37
var father_relationship: int = 80
var father_alive: bool = true
var father_health: int = 80

var karma: int = 0
var money: int = 0
var bank_savings: int = 0
var debt: int = 0
var loan_balance: int = 0
var loan_interest_rate: float = 0.08

var education_level: String = "None"
var grades: int = 75
var has_scholarship: bool = false
var university_years: int = 0

var job_id: String = ""
var job_title: String = ""
var job_company: String = ""
var job_salary: int = 0

var illnesses: Array = []
var is_dead: bool = false
var cause_of_death: String = ""

var is_in_prison: bool = false
var prison_sentence_years: int = 0

var event_history: Array = []
var life_log: Array = []


func reset_player() -> void:
	first_name = ""
	birthplace = ""
	gender = "MALE"
	portrait_variant = randi_range(0, 1)
	has_started_game = false

	birth_story = ""
	birth_month = "January"
	birth_day = 1
	zodiac = "Capricorn"

	mother_name = ""
	mother_job = ""
	mother_base_age = 35
	mother_relationship = 80
	mother_alive = true
	mother_health = 80

	father_name = ""
	father_job = ""
	father_base_age = 37
	father_relationship = 80
	father_alive = true
	father_health = 80

	age = 0

	health = 80
	happiness = 75
	smarts = 60
	looks = 65

	karma = 0
	money = 0
	bank_savings = 0
	debt = 0
	loan_balance = 0

	education_level = "None"
	grades = 75
	has_scholarship = false
	university_years = 0

	job_id = ""
	job_title = ""
	job_company = ""
	job_salary = 0

	illnesses.clear()
	is_dead = false
	cause_of_death = ""

	is_in_prison = false
	prison_sentence_years = 0

	event_history.clear()
	life_log.clear()


func is_doctor() -> bool:
	var j_id := job_id.to_lower()
	var j_title := job_title.to_lower()
	return "doctor" in j_id or "doctor" in j_title or "surgeon" in j_id or "surgeon" in j_title or "physician" in j_title


func get_letter_grade() -> String:
	if grades >= 93:
		return "A+"
	elif grades >= 85:
		return "A"
	elif grades >= 75:
		return "B"
	elif grades >= 65:
		return "C"
	elif grades >= 55:
		return "D"
	else:
		return "F"


func get_net_worth() -> int:
	return money + bank_savings - get_total_debt()


func has_illness(illness_id: String) -> bool:
	for ill in illnesses:
		if ill is Dictionary and ill.get("id", "") == illness_id:
			return true
	return false


func get_illness(illness_id: String) -> Dictionary:
	for ill in illnesses:
		if ill is Dictionary and ill.get("id", "") == illness_id:
			return ill
	return {}


func add_illness(illness_id: String, illness_name: String, stage: int = 1) -> void:
	if has_illness(illness_id):
		return
	illnesses.append({
		"id": illness_id,
		"name": illness_name,
		"stage": stage
	})


func cure_illness(illness_id: String) -> bool:
	for i in range(illnesses.size() - 1, -1, -1):
		var ill: Dictionary = illnesses[i]
		if ill.get("id", "") == illness_id:
			illnesses.remove_at(i)
			return true
	return false


func get_total_debt() -> int:
	return debt + loan_balance


func get_stage_name() -> String:
	if age == 0:
		return "Infant"
	elif age <= 4:
		return "Toddler"
	elif age <= 12:
		return "Child"
	elif age <= 19:
		return "Teenager"
	elif age <= 64:
		return "Adult"
	else:
		return "Elder"


func get_stage_icon() -> String:
	if age == 0:
		return "🍼"
	elif age <= 4:
		return "🧸"
	elif age <= 12:
		return "🎒"
	elif age <= 19:
		return "🎧"
	elif age <= 64:
		return "💼"
	else:
		return "👓"


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
	karma += int(effects.get("karma", 0))

	var delta_money: int = int(effects.get("money", 0))
	if delta_money >= 0:
		money += delta_money
	else:
		if money + delta_money >= 0:
			money += delta_money
		else:
			var deficit: int = -(money + delta_money)
			money = 0
			if bank_savings >= deficit:
				bank_savings -= deficit
			else:
				var unpaid: int = deficit - bank_savings
				bank_savings = 0
				debt += unpaid

	health = clamp(health, 0, 100)
	happiness = clamp(happiness, 0, 100)
	smarts = clamp(smarts, 0, 100)
	looks = clamp(looks, 0, 100)
	karma = clamp(karma, -100, 100)


func add_life_log_entry(text: String, kind: String = "event") -> void:
	if text.strip_edges() == "":
		return

	life_log.append({
		"age": age,
		"text": text,
		"kind": kind
	})


func has_seen_event(event_id: String) -> bool:
	return event_history.has(event_id)


func record_event(event_id: String) -> void:
	if event_id == "":
		return

	if not event_history.has(event_id):
		event_history.append(event_id)
