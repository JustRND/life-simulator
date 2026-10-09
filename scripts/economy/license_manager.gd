class_name LicenseManager
extends RefCounted

const CATEGORIES: Array[Dictionary] = [
	{
		"id": "fnb",
		"name": "F&B LICENSE",
		"icon": "🍸",
		"color": "#f59e0b",
		"description": "Hospitality certifications, spirits craft mixology, and commercial culinary standards."
	},
	{
		"id": "vehicle",
		"name": "VEHICLE LICENSE",
		"icon": "🚗",
		"color": "#38bdf8",
		"description": "State driver qualification, motorcycle operation, coastal yachting, and aviation pilot credentials."
	},
	{
		"id": "firearm",
		"name": "FIREARM LICENSE",
		"icon": "🎯",
		"color": "#ef4444",
		"description": "Concealed carry permits, tactical defense qualifications, and licensed investigative credentials."
	},
	{
		"id": "services",
		"name": "SERVICES LICENSE",
		"icon": "🛠️",
		"color": "#10b981",
		"description": "State trade boards, certified contracting, freelance media, appraisal, and forensic accounting credentials."
	}
]

const LICENSES: Array[Dictionary] = [
	# --- VEHICLE LICENSES ---
	{
		"id": "license_motorcycle",
		"name": "Motorcycle Operator License (Class M)",
		"icon": "🏍️",
		"category": "vehicle",
		"fee": 350,
		"min_age": 16,
		"unlocked_feature": "Motorcycle Riding",
		"description": "Standard state road qualification permitting the legal operation of motorcycles, scooters, and high-powered sportbikes."
	},
	{
		"id": "license_car",
		"name": "Driver's License (Class C)",
		"icon": "🚗",
		"category": "vehicle",
		"fee": 450,
		"min_age": 16,
		"unlocked_feature": "Car Driving",
		"description": "Certified driver's license permitting the legal operation of motor automobiles, coupes, and utility pickup trucks."
	},
	{
		"id": "flight_school",
		"name": "Flight School",
		"icon": "✈️",
		"category": "vehicle",
		"fee": 6000,
		"min_age": 18,
		"is_course": true,
		"unlocked_feature": "Eligibility for the Pilot License Exam",
		"description": "Complete ground school and supervised flight training. This course awards a completion certificate; you must then earn a separate pilot license before operating aircraft."
	},
	{
		"id": "license_pilot",
		"name": "Private Pilot & Rotorcraft License",
		"icon": "✈️",
		"category": "vehicle",
		"fee": 4500,
		"requires_license": "flight_school",
		"min_age": 18,
		"unlocked_feature": "Airplane & Helicopter Piloting",
		"description": "Federal aviation authority flight license permitting the legal operation of private propeller aircraft, business jets, and turbine helicopters."
	},
	{
		"id": "license_boating",
		"name": "Master Coastal Boater & Yachting License",
		"icon": "🛥️",
		"category": "vehicle",
		"fee": 1200,
		"min_age": 18,
		"unlocked_feature": "Yacht & Marine Vessel Piloting",
		"description": "Maritime safety qualification permitting the legal navigation and commanding of power speedboats, cruisers, and luxury ocean yachts."
	},

	# --- F&B LICENSES ---
	{
		"id": "license_mixologist",
		"name": "Professional Mixologist & Spirits License",
		"icon": "🍸",
		"category": "fnb",
		"fee": 500,
		"min_age": 21,
		"unlocked_feature": "Freelance Event Mixologist",
		"job_id": "freelance_mixologist",
		"description": "Beverage control commission certification allowing high-end cocktail craft, mixology catering, and private event bar service."
	},
	{
		"id": "license_food_safety",
		"name": "Commercial Food Safety & Kitchen Manager License",
		"icon": "🍽️",
		"category": "fnb",
		"fee": 300,
		"min_age": 18,
		"unlocked_feature": "Commercial Kitchen & Catering Operations",
		"description": "Department of Public Health certification for food safety standards, culinary sanitation, and commercial kitchen leadership."
	},

	# --- FIREARM LICENSES ---
	{
		"id": "license_firearm",
		"name": "Concealed Carry & Tactical Firearms License",
		"icon": "🎯",
		"category": "firearm",
		"fee": 600,
		"min_age": 21,
		"unlocked_feature": "Legal Concealed Carry & Tactical Defense",
		"description": "State qualification certifying firearms safety, tactical range proficiency, and legal concealed carry authorization."
	},
	{
		"id": "license_pi",
		"name": "Private Investigator License",
		"icon": "🕵️",
		"category": "firearm",
		"fee": 1200,
		"min_age": 21,
		"unlocked_feature": "Freelance Private Investigator",
		"job_id": "freelance_pi",
		"description": "Department of Licensing detective credential permitting covert surveillance, missing person skips, and corporate counter-espionage."
	},

	# --- SERVICES LICENSES ---
	{
		"id": "license_photographer",
		"name": "Commercial Photographer License",
		"icon": "📷",
		"category": "services",
		"fee": 750,
		"min_age": 18,
		"unlocked_feature": "Freelance Commercial Photographer",
		"job_id": "freelance_photographer",
		"description": "State commercial photography permit granting legal rights for client portraiture, commercial sets, and editorial publishing."
	},
	{
		"id": "license_drone",
		"name": "Commercial Remote Drone Pilot License",
		"icon": "🛸",
		"category": "services",
		"fee": 850,
		"min_age": 18,
		"unlocked_feature": "Freelance Aerial Drone Surveyor",
		"job_id": "freelance_drone_surveyor",
		"description": "Civil aviation authority certification for high-resolution aerial mapping, infrastructure inspection, and cinema drone piloting."
	},
	{
		"id": "license_electrician",
		"name": "Certified Journeyman Electrician License",
		"icon": "⚡",
		"category": "services",
		"fee": 950,
		"min_age": 18,
		"unlocked_feature": "Freelance Master Electrician",
		"job_id": "freelance_electrician",
		"description": "Board-certified electrical contractor license authorizing residential and industrial high-voltage wiring and solar microgrids."
	},
	{
		"id": "license_plumber",
		"name": "Master Plumbing & Gasfitter License",
		"icon": "🔧",
		"category": "services",
		"fee": 900,
		"min_age": 18,
		"unlocked_feature": "Freelance Master Plumber",
		"job_id": "freelance_plumber",
		"description": "Licensed tradesman certification authorizing commercial piping, high-pressure gas lines, and municipal sewer retrofits."
	},
	{
		"id": "license_appraiser",
		"name": "Certified Real Estate Appraiser License",
		"icon": "🏢",
		"category": "services",
		"fee": 1100,
		"min_age": 18,
		"unlocked_feature": "Freelance Real Estate Appraiser",
		"job_id": "freelance_appraiser",
		"description": "National appraisal foundation credential authorizing legal property valuation, commercial lease audits, and mortgage appraisals."
	},
	{
		"id": "license_fitness",
		"name": "Certified Personal Fitness Trainer License",
		"icon": "💪",
		"category": "services",
		"fee": 650,
		"min_age": 18,
		"unlocked_feature": "Freelance Personal Fitness Trainer",
		"job_id": "freelance_fitness_trainer",
		"description": "Accredited athletic training certification authorizing one-on-one conditioning, strength programming, and corporate wellness coaching."
	},
	{
		"id": "license_tattoo",
		"name": "Professional Tattoo & Body Art License",
		"icon": "🖋️",
		"category": "services",
		"fee": 800,
		"min_age": 18,
		"unlocked_feature": "Freelance Tattoo & Body Artist",
		"job_id": "freelance_tattoo_artist",
		"description": "Department of Health certification for sterile dermal needlework, custom cyber-ink tattoo artistry, and body modification."
	},
	{
		"id": "license_cyber",
		"name": "Certified Ethical Hacker & Pen-Tester License",
		"icon": "🛡️",
		"category": "services",
		"fee": 1500,
		"min_age": 18,
		"unlocked_feature": "Freelance Cyber Security Pen-Tester",
		"job_id": "freelance_cyber_pentester",
		"description": "Accredited cyber security certification permitting defensive white-hat network penetration tests and security vulnerability audits."
	},
	{
		"id": "license_interpreter",
		"name": "Certified Legal Court Interpreter License",
		"icon": "🗣️",
		"category": "services",
		"fee": 700,
		"min_age": 18,
		"unlocked_feature": "Freelance Legal Court Interpreter",
		"job_id": "freelance_court_interpreter",
		"description": "Judicial qualification allowing sworn simultaneous translation and testimony interpretation in civil and federal courtrooms."
	},
	{
		"id": "license_bookkeeper",
		"name": "Certified Public Bookkeeper License",
		"icon": "📚",
		"category": "services",
		"fee": 950,
		"min_age": 18,
		"unlocked_feature": "Freelance Certified Bookkeeper",
		"job_id": "freelance_bookkeeper",
		"description": "National accounting board certification for corporate ledger balancing, accounts payable reconciliation, and tax documentation."
	}
]


static func get_all_licenses() -> Array[Dictionary]:
	return LICENSES


static func get_categories() -> Array[Dictionary]:
	return CATEGORIES


static func get_category_by_id(id: String) -> Dictionary:
	for cat in CATEGORIES:
		if str(cat.get("id", "")) == id:
			return cat
	return {}


static func get_licenses_in_category(category_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for lic in LICENSES:
		if str(lic.get("category", "")) == category_id:
			result.append(lic)
	return result


static func get_license_by_id(id: String) -> Dictionary:
	for lic in LICENSES:
		if str(lic.get("id", "")) == id:
			return lic
	return {}


static func can_take_license(license_id: String) -> Dictionary:
	var lic := get_license_by_id(license_id)
	if lic.is_empty():
		return {"allowed": false, "reason": "License not found."}

	if PlayerData.has_license(license_id):
		return {"allowed": false, "reason": "You already hold this certified license!"}

	var min_age: int = int(lic.get("min_age", 18))
	if PlayerData.age < min_age:
		return {"allowed": false, "reason": "Age Restricted: Must be at least Age %d (Current Age: %d)." % [min_age, PlayerData.age]}

	var prerequisite: String = str(lic.get("requires_license", ""))
	if not prerequisite.is_empty() and not PlayerData.has_license(prerequisite):
		return {"allowed": false, "reason": "Complete Flight School before taking the pilot license exam."}

	var fee: int = int(lic.get("fee", 0))
	var total_funds: int = PlayerData.money + PlayerData.bank_savings
	if total_funds < fee:
		return {"allowed": false, "reason": "Insufficient funds: Required fee is $%d (Available: $%d)." % [fee, total_funds]}

	return {"allowed": true, "reason": "Eligible to certify."}


static func take_license(license_id: String) -> Dictionary:
	var eval := can_take_license(license_id)
	if not bool(eval.get("allowed", false)):
		return eval

	var lic := get_license_by_id(license_id)
	var fee: int = int(lic.get("fee", 0))

	# Deduct fee: pocket cash first, then bank savings
	PlayerData.debit_funds(fee)

	PlayerData.grant_license(license_id)
	var lic_name: String = str(lic.get("name", "License"))
	var unlocked: String = str(lic.get("unlocked_feature", ""))
	if bool(lic.get("is_course", false)):
		var message := "You completed Flight School for $%d! You can now take the separate pilot license exam." % fee
		return {"allowed": true, "message": message, "license": lic}

	var success_msg := "📜 LICENSE EXAM PASSED: You paid the $%d exam fee and officially earned your %s! Unlocked: %s." % [
		fee,
		lic_name,
		unlocked
	]
	return {
		"allowed": true,
		"message": success_msg,
		"license": lic
	}
