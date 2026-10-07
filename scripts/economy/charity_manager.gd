class_name CharityManager
extends RefCounted

const CHARITIES: Array[Dictionary] = [
	{
		"id": "charity_food_bank",
		"name": "Metropolitan Food Bank & Homeless Relief",
		"icon": "🍲",
		"donation_amount": 100,
		"min_age": 6,
		"buff_id": "buff_philanthropist_heart",
		"buff_name": "Heartwarming Gratitude",
		"buff_desc": "Safeguards your mood against despair; happiness will never drop below 50%.",
		"hidden_karma_boost": 15,
		"happiness_boost": 15,
		"description": "Provides warm meals, hygiene kits, and emergency shelter beds to struggling families and impoverished citizens across metropolitan back alleys."
	},
	{
		"id": "charity_animal_shelter",
		"name": "City Stray Animal Rescue & Wildlife Sanctuary",
		"icon": "🐾",
		"donation_amount": 350,
		"min_age": 8,
		"buff_id": "buff_animal_guardian",
		"buff_name": "Animal Empathy",
		"buff_desc": "Grants lasting emotional calm; happiness will never drop below 55%.",
		"hidden_karma_boost": 20,
		"happiness_boost": 20,
		"description": "Rescues abandoned pets from city streets, provides veterinary care, and rehabilitates injured native wildlife in an open eco-sanctuary."
	},
	{
		"id": "charity_youth_tech",
		"name": "Underprivileged Youth STEM & Coding Academy",
		"icon": "💻",
		"donation_amount": 1200,
		"min_age": 12,
		"buff_id": "buff_youth_mentor",
		"buff_name": "Future Mentor",
		"buff_desc": "Inspires intellectual clarity; smarts will never degrade below 60%.",
		"hidden_karma_boost": 28,
		"happiness_boost": 22,
		"smarts_boost": 3,
		"description": "Sponsors free programming bootcamps, hardware workstations, and neural-interface scholarships for low-income students in industrial districts."
	},
	{
		"id": "charity_medical_aid",
		"name": "St. Jude Medical Relief & Free Indigent Clinic",
		"icon": "🩺",
		"donation_amount": 3500,
		"min_age": 16,
		"buff_id": "buff_lifesavers_blessing",
		"buff_name": "Lifesaver's Blessing",
		"buff_desc": "Bestows vitality and medical protection; health will never drop below 60%.",
		"hidden_karma_boost": 40,
		"happiness_boost": 25,
		"health_boost": 5,
		"description": "Delivers life-saving antibiotics, neonatal support, and essential trauma surgeries to destitute patients unable to afford corporate hospital care."
	},
	{
		"id": "charity_ocean_clean",
		"name": "Global Pacific Ocean & Bio-Reef Restoration",
		"icon": "🌊",
		"donation_amount": 8000,
		"min_age": 16,
		"buff_id": "buff_eco_guardian",
		"buff_name": "Ecological Harmony",
		"buff_desc": "Deep spiritual attunement with nature; happiness will never drop below 65%.",
		"hidden_karma_boost": 55,
		"happiness_boost": 30,
		"description": "Deploys autonomous solar cleaning vessels to extract tons of ocean plastic, restoring fragile bioluminescent coral barrier reefs."
	},
	{
		"id": "charity_childrens_wing",
		"name": "Grand Children's Hospital Memorial Pavilion",
		"icon": "🏛️",
		"donation_amount": 50000,
		"min_age": 18,
		"buff_id": "buff_grand_benefactor",
		"buff_name": "Grand Civic Benefactor",
		"buff_desc": "Permanent philanthropic veneration; happiness floor at 75% and health floor at 70%.",
		"hidden_karma_boost": 100,
		"happiness_boost": 40,
		"health_boost": 10,
		"description": "Permanently endows an advanced pediatric intensive care pavilion in your name, guaranteeing free medical care for generations of sick children."
	}
]

static func get_all_charities() -> Array[Dictionary]:
	return CHARITIES.duplicate(true)

static func get_charity_by_id(charity_id: String) -> Dictionary:
	for c in CHARITIES:
		if str(c.get("id", "")) == charity_id:
			return c.duplicate(true)
	return {}

static func can_donate(player_data: Node, charity_id: String) -> Dictionary:
	var def := get_charity_by_id(charity_id)
	if def.is_empty():
		return {"allowed": false, "reason": "Charity organization not found."}

	var min_age: int = int(def.get("min_age", 6))
	if player_data.age < min_age:
		return {
			"allowed": false,
			"reason": "Age Restricted: Must be at least Age %d+ to make this donation (Current Age: %d)." % [min_age, player_data.age]
		}

	if player_data.get("last_charity_donation_age") is Dictionary and int(player_data.last_charity_donation_age.get(charity_id, -1)) == player_data.age:
		return {
			"allowed": false,
			"reason": "Annual Contribution Made: You have already supported this charity for Age %d. Contributions reset next year." % player_data.age
		}

	var cost: int = int(def.get("donation_amount", 100))
	var total_funds: int = player_data.money + player_data.bank_savings
	if total_funds < cost:
		return {
			"allowed": false,
			"reason": "Insufficient funds: Donation is $%d (Available Funds: $%d)." % [cost, total_funds]
		}

	return {"allowed": true, "reason": "Ready to donate."}

static func donate(player_data: Node, charity_id: String) -> Dictionary:
	var eval := can_donate(player_data, charity_id)
	if not bool(eval.get("allowed", false)):
		return eval

	var def := get_charity_by_id(charity_id)
	var cost: int = int(def.get("donation_amount", 100))

	# Debit funds: cash first, then bank savings
	if player_data.money >= cost:
		player_data.money -= cost
	else:
		var rem: int = cost - player_data.money
		player_data.money = 0
		player_data.bank_savings = maxi(0, player_data.bank_savings - rem)

	if not player_data.get("last_charity_donation_age") is Dictionary:
		player_data.last_charity_donation_age = {}
	player_data.last_charity_donation_age[charity_id] = player_data.age

	# Karma and Happiness boosts (KARMA VALUE IS KEPT STRICTLY HIDDEN)
	var karma_boost: int = int(def.get("hidden_karma_boost", 15))
	var hap_boost: int = int(def.get("happiness_boost", 15))
	var smarts_boost: int = int(def.get("smarts_boost", 0))
	var health_boost: int = int(def.get("health_boost", 0))

	player_data.karma = clampi(player_data.karma + karma_boost, 0, 100)
	player_data.happiness = clampi(player_data.happiness + hap_boost, 0, 100)
	if smarts_boost > 0:
		player_data.smarts = clampi(player_data.smarts + smarts_boost, 0, 100)
	if health_boost > 0:
		player_data.health = clampi(player_data.health + health_boost, 0, 100)

	# Grant unique permanent buff
	var buff_id: String = str(def.get("buff_id", ""))
	var is_first_donation: bool = false
	if buff_id != "" and not player_data.has_buff(buff_id):
		player_data.add_buff(buff_id)
		is_first_donation = true

	# Track donation history if properties exist
	if "total_donated_charity" in player_data:
		player_data.total_donated_charity += cost
	if "charity_donations_count" in player_data:
		player_data.charity_donations_count += 1

	var c_name: String = str(def.get("name", "Charity"))
	var buff_name: String = str(def.get("buff_name", ""))
	var msg: String = ""
	if is_first_donation:
		msg = "You contributed $%d to %s.\nYour generous donation profoundly purified your spirit and unlocked the '%s' cosmic buff!" % [cost, c_name, buff_name]
	else:
		msg = "You contributed $%d to %s.\nYour continued generosity profoundly blesses your spirit and brings boundless happiness." % [cost, c_name]

	return {
		"allowed": true,
		"success": true,
		"message": msg,
		"charity": def,
		"buff_name": buff_name,
		"is_new_buff": is_first_donation
	}
