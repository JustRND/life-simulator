extends Node

var age: int = 0
var life_id: String = ""
var finance_market: Dictionary = {}
var learning_activities: Dictionary = {}

var health: int = 80
var happiness: int = 75
var smarts: int = 60
var looks: int = 65

var first_name: String = ""
var birthplace: String = ""
var gender: String = "MALE"
var ethnicity: String = "white"
var portrait_track: int = 0
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
var mother_education: String = "High School"
var mother_condition: String = ""

var father_name: String = ""
var father_job: String = ""
var father_base_age: int = 37
var father_relationship: int = 80
var father_alive: bool = true
var father_health: int = 80
var father_education: String = "High School"
var father_condition: String = ""

var family_wealth: String = "middle_class"
var life_milestones: Array = []

var partner: Dictionary = {}
var ex_partners: Array = []
var children: Array = []
var pregnancy: Dictionary = {}
var active_debuffs: Array = []
var active_buffs: Array = []
var total_donated_charity: int = 0
var charity_donations_count: int = 0
var last_parent_interact_age: int = -1
var last_mother_spend_time_age: int = -1
var last_mother_compliment_age: int = -1
var last_mother_ask_money_age: int = -1
var last_father_spend_time_age: int = -1
var last_father_compliment_age: int = -1
var last_father_ask_money_age: int = -1
var last_partner_interact_age: int = -1
var last_partner_spend_time_age: int = -1
var last_partner_compliment_age: int = -1
var last_partner_gift_age: int = -1
var last_partner_propose_age: int = -1
var last_breakup_age: int = -1
var last_baby_age: int = -1

var last_mother_pay_meds_age: int = -1
var last_father_pay_meds_age: int = -1
var last_mother_doctor_checkup_age: int = -1
var last_father_doctor_checkup_age: int = -1
var last_mother_vitamin_shot_age: int = -1
var last_father_vitamin_shot_age: int = -1

var last_doctor_checkup_age: int = -1
var last_doctor_vitamin_age: int = -1
var last_plastic_surgery_age: int = -1
var last_chemo_age: int = -1
var last_therapy_age: int = -1
var last_er_age: int = -1

var last_prison_activity_age: int = -1
var last_casino_age: int = -1
var casino_plays_this_year: int = 0
var last_overtime_age: int = -1
var last_childhood_gig_age: int = -1

var karma: int = 0
var money: int = 0
var bank_savings: int = 0
var debt: int = 0
var tax_debt: int = 0
var loan_balance: int = 0
var loan_interest_rate: float = 0.08
var owned_assets: Array[Dictionary] = []

var education_level: String = "None"
var grades: int = 75
var has_scholarship: bool = false
var university_years: int = 0
var university_name: String = ""
var university_major: String = ""
var university_major_title: String = ""
var university_degree: String = ""
var university_tuition: int = 12000
var degrees: Array = []
var licenses: Array = []
var active_freelance_jobs: Array = []
var freelance_reputation: Dictionary = {}
var owned_businesses: Array = []
var last_freelance_pitch_age: Dictionary = {}
var last_school_activity_age: int = -1
var last_scholarship_applied_age: int = -1
var last_ged_attempt_age: int = -1
var has_gym_membership: bool = false
var gym_membership_annual_fee: int = 300
var last_gym_activity_age: int = -1
var last_meditation_activity_age: int = -1
var last_salon_activity_age: int = -1
var last_spa_activity_age: int = -1
var last_dating_app_age: int = -1
var last_pet_adoption_age: int = -1
var last_charity_donation_age: Dictionary = {}

var job_id: String = ""
var job_title: String = ""
var job_company: String = ""
var job_salary: int = 0
var career_progress: Dictionary = {}
var underground_progress: Dictionary = {}

var illnesses: Array = []
var is_dead: bool = false
var cause_of_death: String = ""

var is_in_prison: bool = false
var prison_sentence_years: int = 0

var event_history: Array = []
var life_log: Array = []

var social_media: Dictionary = {}
var pets: Array = []
var will_recipient: String = "CHILDREN"


func reset() -> void:
	reset_player()


func reset_player() -> void:
	finance_market = {}
	learning_activities = {}
	life_id = Crypto.new().generate_random_bytes(16).hex_encode()
	first_name = ""
	birthplace = ""
	gender = "MALE"
	ethnicity = "white"
	portrait_track = 0
	portrait_variant = 0
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
	mother_education = "High School"
	mother_condition = ""

	father_name = ""
	father_job = ""
	father_base_age = 37
	father_relationship = 80
	father_alive = true
	father_health = 80
	father_education = "High School"
	father_condition = ""

	family_wealth = "middle_class"
	life_milestones.clear()

	partner = {}
	ex_partners = []
	last_parent_interact_age = -1
	last_mother_spend_time_age = -1
	last_mother_compliment_age = -1
	last_mother_ask_money_age = -1
	last_father_spend_time_age = -1
	last_father_compliment_age = -1
	last_father_ask_money_age = -1
	last_partner_interact_age = -1
	last_partner_spend_time_age = -1
	last_partner_compliment_age = -1
	last_partner_gift_age = -1
	last_partner_propose_age = -1
	last_breakup_age = -1
	last_baby_age = -1

	last_mother_pay_meds_age = -1
	last_father_pay_meds_age = -1
	last_mother_doctor_checkup_age = -1
	last_father_doctor_checkup_age = -1
	last_mother_vitamin_shot_age = -1
	last_father_vitamin_shot_age = -1

	last_doctor_checkup_age = -1
	last_doctor_vitamin_age = -1
	last_plastic_surgery_age = -1
	last_chemo_age = -1
	last_therapy_age = -1
	last_er_age = -1

	last_prison_activity_age = -1
	last_casino_age = -1
	casino_plays_this_year = 0
	last_overtime_age = -1
	last_childhood_gig_age = -1

	age = 0

	health = 80
	happiness = 75
	smarts = 60
	looks = 65

	karma = 0
	money = 0
	bank_savings = 0
	debt = 0
	tax_debt = 0
	loan_balance = 0
	owned_assets.clear()

	education_level = "None"
	grades = 75
	has_scholarship = false
	university_years = 0
	university_name = ""
	university_major = ""
	university_major_title = ""
	university_degree = ""
	university_tuition = 12000
	last_school_activity_age = -1
	last_scholarship_applied_age = -1
	last_ged_attempt_age = -1
	has_gym_membership = false
	gym_membership_annual_fee = 300
	last_gym_activity_age = -1
	last_meditation_activity_age = -1
	last_salon_activity_age = -1
	last_spa_activity_age = -1
	last_dating_app_age = -1
	last_pet_adoption_age = -1
	last_charity_donation_age.clear()

	job_id = ""
	job_title = ""
	job_company = ""
	job_salary = 0
	career_progress = {}
	underground_progress = {}

	illnesses.clear()
	is_dead = false
	cause_of_death = ""

	is_in_prison = false
	prison_sentence_years = 0

	event_history.clear()
	life_log.clear()
	degrees.clear()
	licenses.clear()
	active_freelance_jobs.clear()
	freelance_reputation.clear()
	owned_businesses.clear()
	last_freelance_pitch_age.clear()
	children.clear()
	pregnancy = {}
	active_debuffs.clear()
	active_buffs.clear()
	total_donated_charity = 0
	charity_donations_count = 0
	social_media.clear()
	pets.clear()
	will_recipient = "CHILDREN"


func _extract_leading_emoji(text: String) -> Dictionary:
	var t := text.strip_edges()
	var emojis := [
		"🚀", "📜", "🎓", "👶", "🍼", "💼", "🎖️", "🎖", "💍", "🏡", "✈️", "✈",
		"🧸", "🎒", "🏫", "📘", "🎾", "🦮", "🩺", "🌈", "📱", "☑️", "⚠️", "📈",
		"💬", "🗑️", "🏛️", "🏦", "💰", "💵", "⚖️", "✨", "🌟", "🏢", "🏆"
	]
	for e in emojis:
		if t.begins_with(e):
			var rem := t.substr(e.length()).strip_edges()
			return {"emoji": e, "text": rem}
	return {"emoji": "", "text": t}


func _detect_milestone_icon(text: String) -> String:
	var l := text.to_lower()
	if "flight school" in l or "pilot" in l or "aviation" in l or "flight" in l:
		return "✈️"
	if "enterprise" in l or "founded" in l or "incorporated" in l or "business" in l:
		return "🏢"
	if "graduated" in l or "degree" in l or "diploma" in l or "scholarship" in l:
		return "🎓"
	if "kindergarten" in l:
		return "🧸"
	if "primary school" in l or "middle school" in l or "high school" in l or "school" in l:
		return "🎒"
	if "born" in l or "baby" in l or "child" in l:
		return "🍼"
	if "married" in l or "wedding" in l:
		return "💍"
	if "promoted" in l or "promotion" in l:
		return "🎖️"
	if "started career" in l or "started working" in l or "freelance" in l or "job" in l:
		return "💼"
	if "real estate" in l or "house" in l or "apartment" in l or "property" in l:
		return "🏡"
	if "license" in l:
		return "📜"
	if "passed away" in l:
		return "🌈"
	if "will" in l or "beneficiary" in l:
		return "⚖️"
	if "social media" in l or "verified" in l:
		return "📱"
	if "pet" in l:
		return "🦮"
	return "🏆"


func is_life_milestone(entry: Dictionary) -> bool:
	if str(entry.get("kind", "")) == "milestone":
		return true

	var txt := str(entry.get("text", "")).to_lower()
	if "born" in txt and ("world" in txt or "parents" in txt or "hospital" in txt or "birth" in txt or "born in" in txt):
		return true
	if "enrolled in kindergarten" in txt or "enrolled in primary" in txt:
		return true
	if "entered primary school" in txt or "entered middle school" in txt or "entered high school" in txt:
		return true
	if "graduated from high school" in txt or "graduated from university" in txt or "graduated from" in txt:
		return true
	if "diploma earned" in txt or "degree:" in txt:
		return true
	if "enrolled at" in txt or "enrolled in university" in txt:
		return true
	if "started working as" in txt or "started career as" in txt:
		return true
	if "promoted to" in txt:
		return true
	if "enterprise incorporated" in txt or "founded enterprise" in txt or "founded '" in txt or "business sold" in txt:
		return true
	if "flight school" in txt or "license exam passed" in txt or ("earned your" in txt and "license" in txt):
		return true
	if "freelance roster" in txt:
		return true
	if "verified creator" in txt:
		return true
	if "married" in txt or "wedding" in txt or "welcomed baby" in txt or "gave birth" in txt:
		return true
	if "purchased real estate" in txt:
		return true
	if "passed away" in txt:
		return true
	if "scholarship awarded" in txt:
		return true
	if "released from prison" in txt:
		return true
	if "diagnosed with" in txt:
		return true
	if "cured of" in txt:
		return true
	if "notarized will" in txt:
		return true

	return false


func add_milestone(m_text: String, milestone_age: int = -1, icon: String = "🏆") -> void:
	var raw_text := m_text.strip_edges()
	if raw_text == "":
		return

	var a: int = age if milestone_age < 0 else milestone_age
	var extracted := _extract_leading_emoji(raw_text)
	var final_icon := icon
	var clean_text := str(extracted.get("text", raw_text))

	if str(extracted.get("emoji", "")) != "":
		final_icon = str(extracted.get("emoji"))
	elif final_icon == "" or final_icon == "🏆":
		final_icon = _detect_milestone_icon(clean_text)

	var c_lower := clean_text.to_lower()
	for m in life_milestones:
		if not (m is Dictionary):
			continue
		var existing_age: int = int(m.get("age", -1))
		if existing_age == a:
			var existing_text: String = str(m.get("text", "")).strip_edges()
			if existing_text == clean_text or existing_text == raw_text:
				return
			var e_lower := existing_text.to_lower()
			if e_lower == c_lower:
				return
			if ("flight school" in e_lower and "flight school" in c_lower) or \
			   ("kindergarten" in e_lower and "kindergarten" in c_lower) or \
			   ("high school" in e_lower and "high school" in c_lower and "graduated" in e_lower and "graduated" in c_lower):
				return
			if "enterprise incorporated" in c_lower and "founded" in e_lower:
				m["text"] = clean_text
				m["icon"] = final_icon
				return
			if "founded" in c_lower and "enterprise incorporated" in e_lower:
				return

	life_milestones.append({
		"text": clean_text,
		"age": a,
		"icon": final_icon
	})

	life_milestones.sort_custom(func(x, y):
		return int(x.get("age", 0)) < int(y.get("age", 0))
	)


func sync_milestones_from_log() -> void:
	for entry in life_log:
		if entry is Dictionary and is_life_milestone(entry):
			var entry_text: String = str(entry.get("text", "")).strip_edges()
			var entry_age: int = int(entry.get("age", 0))
			if entry_text != "":
				add_milestone(entry_text, entry_age)


func has_license(license_id: String) -> bool:
	return licenses.has(license_id)


func grant_license(license_id: String) -> void:
	if not licenses.has(license_id):
		licenses.append(license_id)


func has_degree(major_or_title: String) -> bool:
	var target := major_or_title.to_lower()
	if education_level == "University Graduate":
		if university_major.to_lower() == target or university_major_title.to_lower().contains(target):
			return true
	for d in degrees:
		if d is Dictionary:
			var d_major: String = str(d.get("major", "")).to_lower()
			var d_title: String = str(d.get("major_title", "")).to_lower()
			if d_major == target or d_major.contains(target) or d_title.contains(target):
				return true
	return false


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
	elif grades > 0:
		return "F (Failing)"
	else:
		return "0% (Course Required)"



func get_education_display_string() -> String:
	match education_level:
		"None":
			return "None (Early Childhood)" if age < 3 else "No Formal Education"
		"Kindergarten":
			return "Kindergarten"
		"Primary School":
			return "Primary School (Elementary)"
		"Middle School":
			return "Middle School (Junior High)"
		"High School":
			return "High School"
		"High School Dropout":
			return "High School Dropout (No Diploma)"
		"High School Graduate":
			return "High School Graduate (Diploma)"
		"University Student":
			var yr_str := "Year %d of 4" % maxi(1, university_years + 1)
			if university_name != "" and university_major_title != "":
				return "University Student (%s - %s @ %s)" % [yr_str, university_major_title, university_name]
			elif university_name != "":
				return "University Student (%s @ %s)" % [yr_str, university_name]
			else:
				return "University Student (%s)" % yr_str
		"University Graduate":
			if university_degree != "" and university_name != "":
				return "%s (%s)" % [university_degree, university_name]
			elif university_major_title != "":
				return "Bachelor's Degree in %s" % university_major_title
			else:
				return "University Graduate (Bachelor's Degree)"
		"University Dropout":
			if degrees.size() > 0:
				var last_deg: Dictionary = degrees[-1] if degrees[-1] is Dictionary else {}
				var d_title: String = str(last_deg.get("degree", "Degree"))
				var m_title: String = str(last_deg.get("major_title", "Major"))
				return "%s in %s (University Dropout)" % [d_title, m_title]
			return "University Dropout (College Leaver)"
		_:
			return education_level


func has_major(major_id: String) -> bool:
	var m := major_id.to_lower()
	if university_major.to_lower() == m:
		return true
	for deg in degrees:
		if deg is Dictionary and str(deg.get("major", "")).to_lower() == m:
			return true
	return false


func has_completed_degree() -> bool:
	return education_level == "University Graduate" or degrees.size() > 0


func get_total_asset_value() -> int:
	var total: int = 0
	for item in owned_assets:
		total += int(item.get("current_value", item.get("purchase_price", 0)))
	return total


func get_net_worth() -> int:
	var business_value := 0
	for business in owned_businesses:
		business_value += int(maxi(0, int(business.get("valuation", 0)) + int(business.get("treasury", 0)) - int(business.get("loan_balance", 0)) - int(business.get("unpaid_taxes", 0))) * float(business.get("owner_fraction", 1.0)))
	return money + bank_savings + get_total_asset_value() + business_value + preload("res://scripts/economy/finance_market.gd").portfolio_value(self) - get_total_debt()


func get_owned_assets_by_category(category: String) -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for item in owned_assets:
		if item.get("category", "") == category:
			list.append(item)
	return list


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
	return debt + tax_debt + loan_balance


func pay_outstanding_tax() -> int:
	if tax_debt <= 0 or money < tax_debt:
		return 0
	var paid := tax_debt
	money -= paid
	tax_debt = 0
	return paid


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
		"karma": karma,
		"underground_completed": int(underground_progress.get("completed", 0))
	}


func apply_effects(effects: Dictionary) -> void:
	health += int(effects.get("health", 0))
	happiness += int(effects.get("happiness", 0))
	smarts += int(effects.get("smarts", 0))
	looks += int(effects.get("looks", 0))
	karma += int(effects.get("karma", 0))

	if effects.has("grades"):
		grades = clamp(grades + int(effects.get("grades", 0)), 0, 100)
		last_school_activity_age = age

	if effects.has("bank_savings"):
		bank_savings = maxi(0, bank_savings + int(effects.get("bank_savings", 0)))

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
	grades = clamp(grades, 0, 100)

	enforce_buffs_and_debuffs()



static func sanitize_stat_spoilers(text: String) -> String:
	var s := text
	# Remove parenthetical stat deltas, e.g. "(Health -12%, Happiness -8%)", "(Happiness +8)"
	var reg_paren := RegEx.new()
	reg_paren.compile("\\s*\\(\\s*(?:Health|Happiness|Smarts|Looks|Grades|Relationship|Partner happiness|Pet Health|Academic Marks|Academic sharpness)\\s*[:+-]\\s*\\d+%?(?:\\s*[,•&]\\s*(?:Health|Happiness|Smarts|Looks|Grades|Relationship|Partner happiness|Pet Health|Academic Marks|Academic sharpness)\\s*[:+-]?\\s*\\d*%?)*\\s*\\)")
	s = reg_paren.sub(s, "", true)

	# Remove unparenthesized stat delta phrases, e.g. "Smarts +2, Happiness +2."
	var reg_stat := RegEx.new()
	reg_stat.compile("\\b(?:Health|Happiness|Smarts|Looks|Grades|Relationship|Partner happiness|Pet Health)\\s*[:+-]\\s*\\d+%?")
	s = reg_stat.sub(s, "", true)

	# Clean up leftover comma-chains, dangling punctuation, or trailing exclamation/dots
	var reg_cleanup := RegEx.new()
	reg_cleanup.compile("[,;]\\s*[,;]+")
	s = reg_cleanup.sub(s, ",", true)
	reg_cleanup.compile("\\s*[,;]\\s*(\\.|!|\\?)")
	s = reg_cleanup.sub(s, "$1", true)
	reg_cleanup.compile("\\(\\s*\\)")
	s = reg_cleanup.sub(s, "", true)
	reg_cleanup.compile("\\s{2,}")
	s = reg_cleanup.sub(s, " ", true)
	return s.strip_edges()


func add_life_log_entry(text: String, kind: String = "event") -> void:
	var clean_text := sanitize_stat_spoilers(text).strip_edges()
	if clean_text == "":
		return

	if not life_log.is_empty():
		var last_entry: Dictionary = life_log.back()
		if int(last_entry.get("age", -1)) == age and str(last_entry.get("text", "")).strip_edges() == clean_text:
			return

	var entry := {
		"age": age,
		"text": clean_text,
		"kind": kind
	}
	life_log.append(entry)

	if is_life_milestone(entry):
		add_milestone(clean_text, age)


func has_seen_event(event_id: String) -> bool:
	return event_history.has(event_id)


func record_event(event_id: String) -> void:
	if event_id == "":
		return

	if not event_history.has(event_id):
		event_history.append(event_id)


func has_partner() -> bool:
	return partner != null and not partner.is_empty() and bool(partner.get("is_alive", false))


func get_partner_name() -> String:
	return str(partner.get("name", ""))


func get_partner_status() -> String:
	return str(partner.get("status", "Partner"))


func get_partner_relationship() -> int:
	return int(partner.get("relationship", 0))


func set_partner_relationship(val: int) -> void:
	if has_partner():
		partner["relationship"] = clampi(val, 0, 100)


func enforce_buffs_and_debuffs() -> void:
	if "health_cap_50" in active_debuffs:
		health = clampi(health, 0, 50)
	if "stuck_happiness" in active_debuffs:
		happiness = clampi(happiness, 0, 15)
	if "super_smarts" in active_buffs:
		smarts = maxi(smarts, 100)
	if "radiant_vitality" in active_buffs:
		health = maxi(health, 85)
	if "divine_looks" in active_buffs:
		looks = maxi(looks, 90)
	if "blessed_mind" in active_buffs:
		happiness = maxi(happiness, 80)
	# Philanthropy & Charity Cosmic Buffs
	if "buff_philanthropist_heart" in active_buffs:
		happiness = maxi(happiness, 50)
	if "buff_animal_guardian" in active_buffs:
		happiness = maxi(happiness, 55)
	if "buff_youth_mentor" in active_buffs:
		smarts = maxi(smarts, 60)
	if "buff_lifesavers_blessing" in active_buffs:
		health = maxi(health, 60)
	if "buff_eco_guardian" in active_buffs:
		happiness = maxi(happiness, 65)
	if "buff_grand_benefactor" in active_buffs:
		happiness = maxi(happiness, 75)
		health = maxi(health, 70)


func add_buff(buff_id: String) -> void:
	if not buff_id in active_buffs:
		active_buffs.append(buff_id)
		enforce_buffs_and_debuffs()


func has_buff(buff_id: String) -> bool:
	return buff_id in active_buffs


func has_debuff(debuff_id: String) -> bool:
	return debuff_id in active_debuffs


func has_living_children() -> bool:
	for c in children:
		if c is Dictionary and bool(c.get("is_alive", true)):
			return true
	return false


func get_living_children() -> Array:
	var living: Array = []
	for c in children:
		if c is Dictionary and bool(c.get("is_alive", true)):
			living.append(c)
	return living


func add_player_child(c_name: String, c_gender: String, c_age: int = 0) -> Dictionary:
	var child_data := {
		"name": c_name,
		"gender": c_gender,
		"age": c_age,
		"ethnicity": ethnicity,
		"portrait_track": randi() % 2,
		"portrait_variant": randi() % 5,
		"relationship": 85,
		"health": 90,
		"happiness": 80,
		"smarts": randi_range(50, 85),
		"looks": randi_range(50, 85),
		"is_alive": true
	}
	children.append(child_data)
	return child_data


func start_reincarnated_life(identity: Dictionary, debuffs: Array, buffs: Array) -> void:
	reset_player()
	active_debuffs = debuffs.duplicate()
	active_buffs = buffs.duplicate()

	first_name = str(identity.get("first_name", "Reborn Soul"))
	gender = str(identity.get("gender", "MALE"))
	ethnicity = str(identity.get("ethnicity", "white"))
	birthplace = str(identity.get("birthplace", "New York"))
	portrait_track = int(identity.get("portrait_track", 0))
	portrait_variant = int(identity.get("portrait_variant", 0))
	has_started_game = true

	# Parents setup
	if "no_parents" in active_debuffs:
		mother_name = "Deceased"
		mother_alive = false
		mother_health = 0
		father_name = "Deceased"
		father_alive = false
		father_health = 0
	else:
		mother_name = "Elena"
		mother_job = "Retail Associate"
		mother_alive = true
		mother_health = 80
		father_name = "Marcus"
		father_job = "Mechanic"
		father_alive = true
		father_health = 80

	if "golden_pedigree" in active_buffs:
		mother_job = "Chief Surgeon"
		father_job = "Venture Capitalist"
		mother_relationship = 100
		father_relationship = 100

	# Base stats
	if "bad_stats" in active_debuffs:
		health = randi_range(15, 25)
		happiness = randi_range(10, 20)
		smarts = randi_range(15, 25)
		looks = randi_range(15, 25)
	else:
		health = 80
		happiness = 75
		smarts = 60
		looks = 65

	# Illnesses
	if "random_illness" in active_debuffs:
		var illness_pool := [
			{"id": "chronic_asthma", "name": "Chronic Severe Asthma"},
			{"id": "heart_murmur", "name": "Congenital Heart Defect"},
			{"id": "migraines", "name": "Chronic Migraine Syndrome"}
		]
		var chosen_ill: Dictionary = illness_pool[randi() % illness_pool.size()]
		add_illness(str(chosen_ill["id"]), str(chosen_ill["name"]), 1)

	# Finances
	if "crazy_debt" in active_debuffs:
		debt = randi_range(60000, 100000)
		money = 0
	elif "poverty" in active_debuffs:
		money = 0
		bank_savings = 0
	elif "silver_spoon" in active_buffs:
		money = 0
		bank_savings = randi_range(100000, 150000)
	else:
		money = 0

	karma = 0
	enforce_buffs_and_debuffs()

	var desc_karmic := "⚖️ REINCARNATION: You were judged by the Cosmic Arbiter."
	if active_debuffs.size() > 0:
		desc_karmic += " Bound by karmic penalties: %s." % ", ".join(active_debuffs)
	elif active_buffs.size() > 0:
		desc_karmic += " Blessed with cosmic gifts: %s." % ", ".join(active_buffs)
	add_life_log_entry(desc_karmic, "event")


func takeover_as_child(child: Dictionary, inherited_money: int, inherited_assets: Array = []) -> void:
	var inherited_businesses := owned_businesses.duplicate(true)
	var inherited_market := finance_market.duplicate(true)
	var prev_parent_name: String = first_name
	var prev_gender: String = gender
	var assets_copy: Array = inherited_assets.duplicate(true)
	reset_player()
	owned_businesses = inherited_businesses
	finance_market = inherited_market

	first_name = str(child.get("name", "Child"))
	gender = str(child.get("gender", "MALE"))
	ethnicity = str(child.get("ethnicity", "white"))
	portrait_track = int(child.get("portrait_track", 0))
	portrait_variant = int(child.get("portrait_variant", 0))
	age = int(child.get("age", 18))
	if not finance_market.is_empty():
		finance_market.last_age = age
		finance_market.history = []
		for company in finance_market.get("issuers", []):
			company.opened_age = age
			if not str(company.get("business_uid", "")).is_empty():
				company.owner = first_name
	has_started_game = true

	health = int(child.get("health", 85))
	happiness = int(child.get("happiness", 75))
	smarts = int(child.get("smarts", 65))
	looks = int(child.get("looks", 65))
	money = 0
	bank_savings = maxi(0, inherited_money)
	debt = 0
	tax_debt = 0
	karma = 0

	owned_assets.clear()
	for a in assets_copy:
		if a is Dictionary:
			owned_assets.append(a.duplicate(true))

	if prev_gender == "FEMALE":
		mother_name = prev_parent_name
		mother_alive = false
		mother_health = 0
	else:
		father_name = prev_parent_name
		father_alive = false
		father_health = 0

	if age >= 18:
		education_level = "High School Graduate"
		grades = 80
	elif age >= 12:
		education_level = "Middle School"
		grades = 75
	elif age >= 6:
		education_level = "Primary School"
		grades = 75
	else:
		education_level = "None"

	var asset_text := " and %d property/vehicle assets" % owned_assets.size() if owned_assets.size() > 0 else ""
	add_life_log_entry("📜 LEGACY: You inherited your late parent %s's estate ($%d deposited into your Bank Balance%s) and continue the family bloodline at age %d." % [prev_parent_name, bank_savings, asset_text, age], "event")
