extends Node

const SAVE_PATH := "user://savegame.json"


func save_game() -> void:
	var save_data := {
		"first_name": PlayerData.first_name,
		"birthplace": PlayerData.birthplace,
		"gender": PlayerData.gender,
		"ethnicity": PlayerData.ethnicity,
		"portrait_track": PlayerData.portrait_track,
		"portrait_variant": PlayerData.portrait_variant,
		"has_started_game": PlayerData.has_started_game,
		"birth_story": PlayerData.birth_story,
		"birth_month": PlayerData.birth_month,
		"birth_day": PlayerData.birth_day,
		"zodiac": PlayerData.zodiac,
		"mother_name": PlayerData.mother_name,
		"mother_job": PlayerData.mother_job,
		"mother_base_age": PlayerData.mother_base_age,
		"mother_relationship": PlayerData.mother_relationship,
		"mother_alive": PlayerData.mother_alive,
		"mother_health": PlayerData.mother_health,
		"father_name": PlayerData.father_name,
		"father_job": PlayerData.father_job,
		"father_base_age": PlayerData.father_base_age,
		"father_relationship": PlayerData.father_relationship,
		"father_alive": PlayerData.father_alive,
		"father_health": PlayerData.father_health,
		"age": PlayerData.age,
		"health": PlayerData.health,
		"happiness": PlayerData.happiness,
		"smarts": PlayerData.smarts,
		"looks": PlayerData.looks,
		"money": PlayerData.money,
		"bank_savings": PlayerData.bank_savings,
		"debt": PlayerData.debt,
		"loan_balance": PlayerData.loan_balance,
		"loan_interest_rate": PlayerData.loan_interest_rate,
		"education_level": PlayerData.education_level,
		"grades": PlayerData.grades,
		"has_scholarship": PlayerData.has_scholarship,
		"university_years": PlayerData.university_years,
		"university_name": PlayerData.university_name,
		"university_major": PlayerData.university_major,
		"university_major_title": PlayerData.university_major_title,
		"university_degree": PlayerData.university_degree,
		"university_tuition": PlayerData.university_tuition,
		"degrees": PlayerData.degrees,
		"last_school_activity_age": PlayerData.last_school_activity_age,
		"last_scholarship_applied_age": PlayerData.last_scholarship_applied_age,
		"last_ged_attempt_age": PlayerData.last_ged_attempt_age,
		"has_gym_membership": PlayerData.has_gym_membership,
		"gym_membership_annual_fee": PlayerData.gym_membership_annual_fee,
		"last_gym_activity_age": PlayerData.last_gym_activity_age,
		"last_meditation_activity_age": PlayerData.last_meditation_activity_age,
		"job_id": PlayerData.job_id,
		"job_title": PlayerData.job_title,
		"job_company": PlayerData.job_company,
		"job_salary": PlayerData.job_salary,
		"career_progress": PlayerData.career_progress,
		"underground_progress": PlayerData.underground_progress,
		"illnesses": PlayerData.illnesses,
		"is_dead": PlayerData.is_dead,
		"cause_of_death": PlayerData.cause_of_death,
		"is_in_prison": PlayerData.is_in_prison,
		"prison_sentence_years": PlayerData.prison_sentence_years,
		"event_history": PlayerData.event_history,
		"life_log": PlayerData.life_log,
		"karma": PlayerData.karma,
		"children": PlayerData.children,
		"active_debuffs": PlayerData.active_debuffs,
		"active_buffs": PlayerData.active_buffs,
		"partner": PlayerData.partner,
		"ex_partners": PlayerData.ex_partners,
		"last_parent_interact_age": PlayerData.last_parent_interact_age,
		"last_mother_spend_time_age": PlayerData.last_mother_spend_time_age,
		"last_mother_compliment_age": PlayerData.last_mother_compliment_age,
		"last_father_spend_time_age": PlayerData.last_father_spend_time_age,
		"last_father_compliment_age": PlayerData.last_father_compliment_age,
		"last_partner_interact_age": PlayerData.last_partner_interact_age
	}

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		push_error("Could not open save file.")
		return

	file.store_string(JSON.stringify(save_data, "\t"))
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

	var json_text: String = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)

	if typeof(data) != TYPE_DICTIONARY:
		push_error("Save file is invalid.")
		return false

	PlayerData.first_name = str(data.get("first_name", ""))
	PlayerData.birthplace = str(data.get("birthplace", ""))
	PlayerData.gender = str(data.get("gender", "MALE"))
	PlayerData.ethnicity = str(data.get("ethnicity", "white"))
	PlayerData.portrait_track = int(data.get("portrait_track", int(data.get("portrait_variant", 0)) % 4))
	PlayerData.portrait_variant = int(data.get("portrait_variant", PlayerData.portrait_track))
	PlayerData.has_started_game = bool(data.get("has_started_game", false))

	PlayerData.birth_story = str(data.get("birth_story", ""))
	PlayerData.birth_month = str(data.get("birth_month", "January"))
	PlayerData.birth_day = int(data.get("birth_day", 1))
	PlayerData.zodiac = str(data.get("zodiac", "Capricorn"))

	PlayerData.mother_name = str(data.get("mother_name", ""))
	PlayerData.mother_job = str(data.get("mother_job", ""))
	PlayerData.mother_base_age = int(data.get("mother_base_age", 35))
	PlayerData.mother_relationship = int(data.get("mother_relationship", 80))
	PlayerData.mother_alive = bool(data.get("mother_alive", true))
	PlayerData.mother_health = int(data.get("mother_health", 80))

	PlayerData.father_name = str(data.get("father_name", ""))
	PlayerData.father_job = str(data.get("father_job", ""))
	PlayerData.father_base_age = int(data.get("father_base_age", 37))
	PlayerData.father_relationship = int(data.get("father_relationship", 80))
	PlayerData.father_alive = bool(data.get("father_alive", true))
	PlayerData.father_health = int(data.get("father_health", 80))

	PlayerData.age = int(data.get("age", 0))
	PlayerData.health = int(data.get("health", 80))
	PlayerData.happiness = int(data.get("happiness", 75))
	PlayerData.smarts = int(data.get("smarts", 60))
	PlayerData.looks = int(data.get("looks", 65))
	PlayerData.money = int(data.get("money", 0))
	PlayerData.bank_savings = int(data.get("bank_savings", 0))
	PlayerData.debt = int(data.get("debt", 0))
	PlayerData.loan_balance = int(data.get("loan_balance", 0))
	PlayerData.loan_interest_rate = float(data.get("loan_interest_rate", 0.08))
	PlayerData.education_level = str(data.get("education_level", "None"))
	PlayerData.grades = int(data.get("grades", 75))
	PlayerData.has_scholarship = bool(data.get("has_scholarship", false))
	PlayerData.university_years = int(data.get("university_years", 0))
	PlayerData.university_name = str(data.get("university_name", ""))
	PlayerData.university_major = str(data.get("university_major", ""))
	PlayerData.university_major_title = str(data.get("university_major_title", ""))
	PlayerData.university_degree = str(data.get("university_degree", ""))
	PlayerData.university_tuition = int(data.get("university_tuition", 12000))
	PlayerData.degrees = Array(data.get("degrees", []))
	PlayerData.last_school_activity_age = int(data.get("last_school_activity_age", -1))
	PlayerData.last_scholarship_applied_age = int(data.get("last_scholarship_applied_age", -1))
	PlayerData.last_ged_attempt_age = int(data.get("last_ged_attempt_age", -1))
	PlayerData.has_gym_membership = bool(data.get("has_gym_membership", false))
	PlayerData.gym_membership_annual_fee = int(data.get("gym_membership_annual_fee", 300))
	PlayerData.last_gym_activity_age = int(data.get("last_gym_activity_age", -1))
	PlayerData.last_meditation_activity_age = int(data.get("last_meditation_activity_age", -1))
	PlayerData.karma = int(data.get("karma", 0))
	PlayerData.children = Array(data.get("children", []))
	PlayerData.active_debuffs = Array(data.get("active_debuffs", []))
	PlayerData.active_buffs = Array(data.get("active_buffs", []))
	PlayerData.enforce_buffs_and_debuffs()

	PlayerData.partner = Dictionary(data.get("partner", {}))
	preload("res://scripts/core/romance_rules.gd").normalize(PlayerData)
	PlayerData.ex_partners = Array(data.get("ex_partners", []))
	PlayerData.last_parent_interact_age = int(data.get("last_parent_interact_age", -1))
	PlayerData.last_mother_spend_time_age = int(data.get("last_mother_spend_time_age", -1))
	PlayerData.last_mother_compliment_age = int(data.get("last_mother_compliment_age", -1))
	PlayerData.last_father_spend_time_age = int(data.get("last_father_spend_time_age", -1))
	PlayerData.last_father_compliment_age = int(data.get("last_father_compliment_age", -1))
	PlayerData.last_partner_interact_age = int(data.get("last_partner_interact_age", -1))

	PlayerData.job_id = str(data.get("job_id", ""))
	PlayerData.job_title = str(data.get("job_title", ""))
	PlayerData.job_company = str(data.get("job_company", ""))
	PlayerData.job_salary = int(data.get("job_salary", 0))
	PlayerData.career_progress = Dictionary(data.get("career_progress", {}))
	PlayerData.underground_progress = Dictionary(data.get("underground_progress", {}))
	preload("res://scripts/economy/career_progression.gd").normalize(PlayerData)
	preload("res://scripts/economy/underground_progression.gd").normalize(PlayerData)

	PlayerData.illnesses = data.get("illnesses", [])
	PlayerData.is_dead = bool(data.get("is_dead", false))
	PlayerData.cause_of_death = str(data.get("cause_of_death", ""))

	PlayerData.is_in_prison = bool(data.get("is_in_prison", false))
	PlayerData.prison_sentence_years = int(data.get("prison_sentence_years", 0))

	PlayerData.event_history = data.get("event_history", [])
	PlayerData.life_log = data.get("life_log", [])

	print("Game loaded.")
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var error: Error = DirAccess.remove_absolute(
			ProjectSettings.globalize_path(SAVE_PATH)
		)

		if error != OK:
			push_error("Could not delete save file. Error code: %d" % error)
			return

	print("Save deleted.")
