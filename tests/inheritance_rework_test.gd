extends Node

const NpcLifeProgress = preload("res://scripts/core/npc_life_progress.gd")

func _ready() -> void:
	print("=== RUNNING INHERITANCE REWORK COMPREHENSIVE TESTS ===")

	# -------------------------------------------------------------
	# TEST 1: Child background life progression across ages
	# -------------------------------------------------------------
	var child := {
		"name": "David Sterling",
		"gender": "MALE",
		"age": 0,
		"smarts": 85,
		"looks": 75,
		"health": 90,
		"happiness": 80
	}
	NpcLifeProgress.ensure(child)
	assert(child.has("life_progress"), "Child must have life_progress initialized")
	assert(child.life_progress.education_level == "None", "Age 0 education is None")

	# Age up to 10 (Primary School)
	child.age = 10
	NpcLifeProgress.ensure(child)
	assert(child.life_progress.education_level == "Primary School", "Age 10 education is Primary School")
	assert(child.life_progress.job_id == "", "Age 10 child has no job")
	assert(child.life_progress.bank_savings == 0, "Age 10 child has no savings")

	# Age up to 22 (University Graduate)
	child.age = 22
	NpcLifeProgress.ensure(child)
	assert(child.life_progress.education_level == "University Graduate", "Smart child (smarts 85) must be University Graduate at 22")
	assert(child.life_progress.degrees.size() > 0, "Graduated child must have degree recorded in degrees list")
	var deg: Dictionary = child.life_progress.degrees[0]
	assert(deg.has("university") and not str(deg.university).is_empty(), "Degree must record university name")
	assert(deg.has("degree") and not str(deg.degree).is_empty(), "Degree must record degree title")
	assert(deg.has("major") and not str(deg.major).is_empty(), "Degree must record major")
	assert(float(deg.get("gpa", 0.0)) > 2.0, "Degree must record GPA")
	print("✔ Test 1.1 Passed: Education background verified (Degree: %s, GPA: %.2f)" % [deg.degree, deg.gpa])

	# Age up to 35 (Established career & personal savings)
	child.age = 35
	NpcLifeProgress.ensure(child)
	assert(not str(child.life_progress.job_id).is_empty(), "Age 35 adult must have an active career")
	assert(not str(child.life_progress.job_title).is_empty(), "Age 35 adult must have a job title")
	assert(int(child.life_progress.job_salary) > 30000, "Age 35 adult salary must be substantial (Got: $%d)" % child.life_progress.job_salary)
	assert(int(child.life_progress.bank_savings) > 5000, "Age 35 adult must have accumulated personal bank savings (Got: $%d)" % child.life_progress.bank_savings)
	assert(int(child.life_progress.credit_score) >= 650, "Age 35 adult must have a healthy credit score (Got: %d)" % child.life_progress.credit_score)
	print("✔ Test 1.2 Passed: Career & savings progression verified (Title: %s at %s, Salary: $%d, Savings: $%d, Score: %d)" % [
		child.life_progress.job_title, child.life_progress.job_company, child.life_progress.job_salary, child.life_progress.bank_savings, child.life_progress.credit_score
	])

	# Age up to 50 (Senior career rank, large personal savings, rich history)
	child.age = 50
	NpcLifeProgress.ensure(child)
	assert(child.life_progress.career_progress.years >= 15, "Age 50 adult must have extensive career tenure")
	assert(int(child.life_progress.bank_savings) > 30000, "Age 50 adult must have significant personal savings (Got: $%d)" % child.life_progress.bank_savings)
	assert(child.life_progress.history.size() >= 5, "Age 50 adult must have a lived-in history log")
	print("✔ Test 1.3 Passed: Senior adult progression verified (Tenure: %d years, Savings: $%d, History Events: %d)" % [
		child.life_progress.career_progress.years, child.life_progress.bank_savings, child.life_progress.history.size()
	])

	# -------------------------------------------------------------
	# TEST 2: Succession takeover as an adult child (Age 50)
	# -------------------------------------------------------------
	PlayerData.reset_player()
	PlayerData.first_name = "Marcus"
	PlayerData.gender = "MALE"
	PlayerData.age = 78
	PlayerData.bank_savings = 500000
	PlayerData.money = 25000

	# Parent owns a family business
	var parent_biz := {
		"uid": "parent_corp_1",
		"type_id": "biz_wholesaler",
		"name": "Sterling Logistics International",
		"icon": "📦",
		"founded_age": 40,
		"treasury": 80000,
		"employees": 12,
		"valuation": 450000
	}
	PlayerData.owned_businesses = [parent_biz]

	# Child also has their own business created
	var child_biz := {
		"uid": "child_biz_1",
		"type_id": "biz_coffee_shop",
		"name": "David's Artisan Roastery",
		"icon": "☕",
		"founded_age": 36,
		"treasury": 25000,
		"employees": 5,
		"valuation": 65000
	}
	child.life_progress.owned_businesses = [child_biz]
	var child_personal_savings: int = int(child.life_progress.bank_savings)
	var child_personal_cash: int = int(child.life_progress.money)
	var inherited_amount: int = 400000

	# Execute succession takeover
	PlayerData.takeover_as_child(child, inherited_amount, [])

	# VERIFY HEIR STATE IS FULLY LIVED-IN:
	assert(PlayerData.first_name == "David Sterling", "Player name must be heir's name")
	assert(PlayerData.age == 50, "Player age must be 50")
	assert(PlayerData.education_level == "University Graduate", "Player must NOT be High School Graduate; must retain University Graduate!")
	assert(PlayerData.degrees.size() > 0, "Player must retain university degree records!")
	assert(PlayerData.job_id == child.life_progress.job_id, "Player must retain heir's job ID")
	assert(PlayerData.job_title == child.life_progress.job_title, "Player must retain heir's job title (Current: %s)" % PlayerData.job_title)
	assert(PlayerData.job_salary == child.life_progress.job_salary, "Player must retain heir's salary")
	assert(PlayerData.career_progress.years == child.life_progress.career_progress.years, "Player must retain career tenure")

	# VERIFY FINANCIAL INTEGRATION:
	assert(PlayerData.money == child_personal_cash, "Player must retain heir's personal cash on hand ($%d)" % child_personal_cash)
	assert(PlayerData.bank_savings == inherited_amount + child_personal_savings, "Bank savings must combine inherited amount ($%d) + heir's personal savings ($%d)! Total: $%d (Got: $%d)" % [
		inherited_amount, child_personal_savings, inherited_amount + child_personal_savings, PlayerData.bank_savings
	])
	assert(PlayerData.credit_score == child.life_progress.credit_score, "Credit score must reflect heir's mature score (%d)" % child.life_progress.credit_score)

	# VERIFY BUSINESS MERGING:
	assert(PlayerData.owned_businesses.size() == 2, "Both parent's business AND heir's personal business must be active! (Got: %d)" % PlayerData.owned_businesses.size())
	var biz_names := []
	for b in PlayerData.owned_businesses:
		biz_names.append(str(b.get("name", "")))
	assert("Sterling Logistics International" in biz_names, "Parent's business inherited")
	assert("David's Artisan Roastery" in biz_names, "Heir's pre-existing business retained")

	# VERIFY LIFE LOG BACKSTORY:
	assert(PlayerData.life_log.size() >= 5, "Player life log must be populated with heir's backstory journey")
	print("✔ Test 2 Passed: Adult child takeover fully preserves education, career, merged savings ($%d), and merged businesses (%d)!" % [
		PlayerData.bank_savings, PlayerData.owned_businesses.size()
	])

	# -------------------------------------------------------------
	# TEST 3: Partner background simulation & partner succession
	# -------------------------------------------------------------
	PlayerData.reset_player()
	PlayerData.first_name = "Elena"
	PlayerData.gender = "FEMALE"
	PlayerData.age = 65
	PlayerData.add_player_child("Little Maya", "FEMALE", 15)

	var partner := {
		"name": "Adrian Kowalski",
		"gender": "MALE",
		"age": 62,
		"status": "Husband",
		"relationship": 95,
		"smarts": 80,
		"health": 85,
		"looks": 70,
		"is_alive": true
	}
	NpcLifeProgress.ensure(partner)
	PlayerData.partner = partner

	assert(partner.life_progress.education_level == "University Graduate", "Partner has university education")
	assert(not str(partner.life_progress.job_title).is_empty(), "Partner has authentic job title")
	assert(int(partner.life_progress.bank_savings) > 20000, "Partner has personal savings")

	var partner_savings: int = int(partner.life_progress.bank_savings)
	var partner_cash: int = int(partner.life_progress.money)
	var partner_job: String = str(partner.life_progress.job_title)
	var bequest: int = 300000

	# Takeover as partner
	PlayerData.takeover_as_heir(partner, bequest, [], "partner")

	assert(PlayerData.first_name == "Adrian Kowalski", "Player is now partner Adrian Kowalski")
	assert(PlayerData.age == 62, "Player age is partner's age (62)")
	assert(PlayerData.job_title == partner_job, "Player retains partner's job (%s)" % partner_job)
	assert(PlayerData.bank_savings == bequest + partner_savings, "Bank balance is bequest ($%d) + personal savings ($%d)" % [bequest, partner_savings])
	assert(PlayerData.money == partner_cash, "Retained partner's cash")
	assert(PlayerData.children.size() == 1, "Surviving children remain with surviving partner/spouse!")
	assert(PlayerData.children[0].name == "Little Maya", "Child Little Maya retained")
	print("✔ Test 3 Passed: Partner succession verified (Name: %s, Age: %d, Bank: $%d, Children: %d)" % [
		PlayerData.first_name, PlayerData.age, PlayerData.bank_savings, PlayerData.children.size()
	])

	# -------------------------------------------------------------
	# TEST 4: UI display helpers
	# -------------------------------------------------------------
	var display_child := {
		"name": "Sarah Connor",
		"gender": "FEMALE",
		"age": 30,
		"smarts": 85
	}
	NpcLifeProgress.ensure(display_child)
	var edu_str := NpcLifeProgress.get_education_display(display_child)
	var occ_str := NpcLifeProgress.get_occupation_display(display_child)
	var wealth_str := NpcLifeProgress.get_finances_display(display_child)

	assert(edu_str.begins_with("🎓"), "Education display must begin with emoji")
	assert(edu_str.contains("GPA"), "University graduate education display must contain GPA")
	assert(occ_str.begins_with("💼"), "Occupation display must begin with emoji")
	assert(occ_str.contains("$") and occ_str.contains("/yr"), "Occupation display must format salary")
	assert(wealth_str.begins_with("💰"), "Finances display must begin with emoji")
	assert(wealth_str.contains("Bank"), "Finances display must mention Bank")
	print("✔ Test 4 Passed: UI display strings formatted correctly:\n   %s\n   %s\n   %s" % [edu_str, occ_str, wealth_str])

	print("\n🎉 ALL INHERITANCE REWORK TESTS PASSED PERFECTLY!")
	get_tree().quit()
