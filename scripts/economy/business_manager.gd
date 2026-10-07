class_name BusinessManager
extends RefCounted

const CORPORATE_TAX_RATE: float = 0.20
const BUSINESS_LOAN_INTEREST_RATE: float = 0.075

const BUSINESS_TYPES: Array[Dictionary] = [
	{
		"id": "biz_coffee_shop",
		"name": "Artisan Coffee Roastery & Cyber Cafe",
		"icon": "☕",
		"required_major": "food_science",
		"required_degree_title": "Food Science & Culinary Arts",
		"startup_cost": 35000,
		"base_revenue_min": 85000,
		"base_revenue_max": 140000,
		"base_opex": 55000,
		"description": "Roast single-origin espresso and serve synthetic cyber energy infusions in a bustling downtown tech district."
	},
	{
		"id": "biz_wholesaler",
		"name": "Wholesale Freight Distribution & Logistics",
		"icon": "📦",
		"required_major": "logistics",
		"required_degree_title": "Global Logistics & Supply Chain",
		"startup_cost": 120000,
		"base_revenue_min": 320000,
		"base_revenue_max": 580000,
		"base_opex": 230000,
		"description": "Coordinate automated container freight, bulk warehouse depots, and regional supply chain transport fleets."
	},
	{
		"id": "biz_clothing_store",
		"name": "Haute Couture & Streetwear Boutique",
		"icon": "👗",
		"required_major": "fashion",
		"required_degree_title": "Fashion & Apparel Design",
		"startup_cost": 65000,
		"base_revenue_min": 160000,
		"base_revenue_max": 310000,
		"base_opex": 105000,
		"description": "Curate runway collections, bespoke tailor-fitted suits, and avant-garde luminescent streetwear."
	},
	{
		"id": "biz_law_firm",
		"name": "Corporate & Criminal Defense Law Firm",
		"icon": "⚖️",
		"required_major": "law",
		"required_degree_title": "Legal Studies & Jurisprudence",
		"startup_cost": 85000,
		"base_revenue_min": 280000,
		"base_revenue_max": 620000,
		"base_opex": 175000,
		"description": "Represent elite corporate executives, high-stakes patent arbitrations, and high-profile criminal litigation."
	},
	{
		"id": "biz_graphic_consultancy",
		"name": "Graphic Design & Branding Consultancy",
		"icon": "🎨",
		"required_major": "graphic_design",
		"required_degree_title": "Graphic Design & Visual Communication",
		"startup_cost": 28000,
		"base_revenue_min": 95000,
		"base_revenue_max": 210000,
		"base_opex": 58000,
		"description": "Design dynamic corporate identities, 3D vector graphics, futuristic web UI/UX, and viral media campaigns."
	},
	{
		"id": "biz_medical_clinic",
		"name": "Private Urgent Care & Medical Clinic",
		"icon": "🩺",
		"required_major": "medicine",
		"required_degree_title": "Pre-Med & Healthcare Sciences",
		"startup_cost": 250000,
		"base_revenue_min": 700000,
		"base_revenue_max": 1350000,
		"base_opex": 480000,
		"description": "Deliver cutting-edge outpatient medical care, surgical recovery suites, and advanced diagnostic imaging."
	},
	{
		"id": "biz_software_studio",
		"name": "Full-Stack Software & AI Development Studio",
		"icon": "💻",
		"required_major": "it",
		"required_degree_title": "Cyber Security & IT",
		"startup_cost": 75000,
		"base_revenue_min": 260000,
		"base_revenue_max": 590000,
		"base_opex": 155000,
		"description": "Engineer enterprise cloud microservices, predictive neural models, cyber security shields, and mobile apps."
	},
	{
		"id": "biz_accounting_firm",
		"name": "Certified Public Accounting & Audit Firm",
		"icon": "📊",
		"required_major": "accounting",
		"required_degree_title": "Accounting & Forensic Audit",
		"startup_cost": 50000,
		"base_revenue_min": 175000,
		"base_revenue_max": 360000,
		"base_opex": 105000,
		"description": "Manage corporate tax compliance, forensic accounting audits, capital allocation, and executive ledgers."
	},
	{
		"id": "biz_architecture_studio",
		"name": "Architectural & Urban Planning Studio",
		"icon": "📐",
		"required_major": "architecture",
		"required_degree_title": "Architecture & Urban Planning",
		"startup_cost": 95000,
		"base_revenue_min": 300000,
		"base_revenue_max": 650000,
		"base_opex": 185000,
		"description": "Draft skyline mega-towers, eco-sustainable civic developments, and luxurious modernist villas."
	},
	{
		"id": "biz_engineering_workshop",
		"name": "Automotive & Robotics Engineering Workshop",
		"icon": "⚙️",
		"required_major": "engineering",
		"required_degree_title": "Mechanical & Electrical Engineering",
		"startup_cost": 110000,
		"base_revenue_min": 270000,
		"base_revenue_max": 520000,
		"base_opex": 170000,
		"description": "Fabricate custom vehicle powertrains, CNC robotic chassis components, and industrial automation assemblies."
	},
	{
		"id": "biz_biotech_lab",
		"name": "Biotech Synthesis & Genomics Laboratory",
		"icon": "🧬",
		"required_major": "biotech",
		"required_degree_title": "Biotechnology & Genetics",
		"startup_cost": 350000,
		"base_revenue_min": 850000,
		"base_revenue_max": 1850000,
		"base_opex": 590000,
		"description": "Pioneer synthetic drug formulas, genetic bioreactors, and proprietary cellular longevity treatments."
	},
	{
		"id": "biz_hedge_fund",
		"name": "Hedge Fund & Wealth Asset Management",
		"icon": "📈",
		"required_major": "finance",
		"required_degree_title": "Finance & Investment Banking",
		"startup_cost": 300000,
		"base_revenue_min": 750000,
		"base_revenue_max": 1650000,
		"base_opex": 460000,
		"description": "Deploy algorithmic high-frequency trading models, venture funds, and private equity investments."
	},
	{
		"id": "biz_music_studio",
		"name": "Audio Recording & Music Production Studio",
		"icon": "🎙️",
		"required_major": "music",
		"required_degree_title": "Sound Engineering & Music Production",
		"startup_cost": 48000,
		"base_revenue_min": 120000,
		"base_revenue_max": 250000,
		"base_opex": 75000,
		"description": "Mix platinum studio records, master film soundtracks, and produce commercial voice audio."
	},
	{
		"id": "biz_clean_energy",
		"name": "Renewable Energy & Solar Grid Services",
		"icon": "⚡",
		"required_major": "environmental",
		"required_degree_title": "Environmental & Renewable Energy Science",
		"startup_cost": 140000,
		"base_revenue_min": 350000,
		"base_revenue_max": 710000,
		"base_opex": 230000,
		"description": "Contract large-scale commercial solar photovoltaic arrays, megawatt battery storage, and micro-grid controls."
	},
	{
		"id": "biz_dental_practice",
		"name": "Modern Dental Surgery & Orthodontics",
		"icon": "🦷",
		"required_major": "dentistry",
		"required_degree_title": "Dental Surgery & Oral Health",
		"startup_cost": 210000,
		"base_revenue_min": 560000,
		"base_revenue_max": 1050000,
		"base_opex": 380000,
		"description": "Provide cosmetic veneer procedures, dental implants, laser periodontal surgery, and orthodontics."
	},
	{
		"id": "biz_film_studio",
		"name": "Film Studio & Multimedia Broadcast Network",
		"icon": "🎬",
		"required_major": "film",
		"required_degree_title": "Film, Cinematography & Media Production",
		"startup_cost": 160000,
		"base_revenue_min": 400000,
		"base_revenue_max": 880000,
		"base_opex": 270000,
		"description": "Produce festival feature films, streaming docuseries, 8K commercial cinema, and multimedia broadcasts."
	}
]


static func get_all_business_types() -> Array[Dictionary]:
	return BUSINESS_TYPES


static func get_business_type_by_id(id: String) -> Dictionary:
	for b in BUSINESS_TYPES:
		if str(b.get("id", "")) == id:
			return b
	return {}


static func player_has_required_degree(req_major: String) -> bool:
	var req_m := req_major.to_lower()

	# Check currently active university major if graduated
	if PlayerData.education_level == "University Graduate":
		if PlayerData.university_major.to_lower() == req_m:
			return true
		if PlayerData.university_major_title.to_lower().contains(req_m):
			return true

	# Check all completed degrees in PlayerData.degrees
	for d in PlayerData.degrees:
		if d is Dictionary:
			var d_major: String = str(d.get("major", "")).to_lower()
			var d_title: String = str(d.get("major_title", "")).to_lower()
			if d_major == req_m or d_major.contains(req_m) or d_title.contains(req_m):
				return true

	return false


static func can_found_business(biz_id: String) -> Dictionary:
	var def := get_business_type_by_id(biz_id)
	if def.is_empty():
		return {"allowed": false, "reason": "Business enterprise definition not found."}

	if PlayerData.age < 18:
		return {"allowed": false, "reason": "Age Restricted: Must be at least 18 years old to incorporate an enterprise."}

	var req_major: String = str(def.get("required_major", ""))
	var deg_title: String = str(def.get("required_degree_title", req_major.capitalize()))
	if not player_has_required_degree(req_major):
		return {
			"allowed": false,
			"reason": "Requires a Bachelor's Degree in %s. Complete your degree at University first!" % deg_title
		}

	var cost: int = int(def.get("startup_cost", 50000))
	var total_player_funds: int = PlayerData.money + PlayerData.bank_savings
	if total_player_funds < cost:
		return {
			"allowed": false,
			"reason": "Insufficient capital: Startup incorporation cost is $%d (Available Funds: $%d)." % [cost, total_player_funds]
		}

	return {"allowed": true, "reason": "Qualified to incorporate."}


static func found_business(biz_id: String, business_name: String = "") -> Dictionary:
	var eval := can_found_business(biz_id)
	if not bool(eval.get("allowed", false)):
		return eval

	var def := get_business_type_by_id(biz_id)
	var cost: int = int(def.get("startup_cost", 50000))

	# Deduct startup cost from player funds
	if PlayerData.money >= cost:
		PlayerData.money -= cost
	else:
		var rem: int = cost - PlayerData.money
		PlayerData.money = 0
		PlayerData.bank_savings = maxi(0, PlayerData.bank_savings - rem)

	var default_name: String = business_name if business_name.strip_edges() != "" else str(def.get("name", "Enterprise"))

	var new_biz: Dictionary = {
		"uid": "biz_%d_%d" % [PlayerData.age, randi() % 10000],
		"type_id": biz_id,
		"name": default_name,
		"icon": str(def.get("icon", "🏢")),
		"founded_age": PlayerData.age,
		"treasury": 10000, # Initial seed liquidity inside business bank account
		"employees": 4,
		"marketing_budget": 5000,
		"annual_revenue": 0,
		"annual_opex": 0,
		"net_profit": 0,
		"unpaid_taxes": 0,
		"last_tax_paid_year": -1,
		"loan_balance": 0,
		"loan_interest_rate": BUSINESS_LOAN_INTEREST_RATE,
		"valuation": int(cost * 1.25),
		"reputation": 75
	}

	PlayerData.owned_businesses.append(new_biz)

	PlayerData.add_life_log_entry("🚀 ENTERPRISE INCORPORATED: You invested $%d to officially launch '%s'! Business treasury initialized with $10,000 working capital." % [cost, default_name], "milestone")

	return {
		"allowed": true,
		"message": "Congratulations! Your enterprise '%s' has been legally incorporated." % default_name,
		"business": new_biz
	}


static func get_total_business_valuation() -> int:
	var total: int = 0
	for b in PlayerData.owned_businesses:
		total += int(b.get("valuation", 0)) + int(b.get("treasury", 0))
	return total


# Yearly financial simulation across all owned businesses
static func simulate_yearly_businesses() -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for b in PlayerData.owned_businesses:
		var type_id: String = str(b.get("type_id", ""))
		var def := get_business_type_by_id(type_id)
		if def.is_empty():
			continue

		var min_rev: int = int(def.get("base_revenue_min", 100000))
		var max_rev: int = int(def.get("base_revenue_max", 200000))
		var base_opex: int = int(def.get("base_opex", 60000))

		var emp_count: int = int(b.get("employees", 4))
		var mkt: int = int(b.get("marketing_budget", 5000))

		# Revenue modifiers: marketing multiplier, employee capacity, market fluctuation
		var mkt_mult: float = 1.0 + (float(mkt) / 50000.0)
		var emp_mult: float = 0.8 + (float(emp_count) * 0.05)
		var market_roll: float = randf_range(0.85, 1.25)

		var generated_revenue: int = int(float(randi_range(min_rev, max_rev)) * mkt_mult * emp_mult * market_roll)

		# Expenses: Base OpEx + Employee payroll ($25k each) + Marketing budget + Loan interest
		var payroll: int = emp_count * 25000
		var loan_bal: int = int(b.get("loan_balance", 0))
		var loan_interest: int = int(float(loan_bal) * float(b.get("loan_interest_rate", BUSINESS_LOAN_INTEREST_RATE)))
		var total_opex: int = base_opex + payroll + mkt + loan_interest

		var net_profit: int = generated_revenue - total_opex

		# Taxes on positive net profit
		var tax_accrued: int = 0
		if net_profit > 0:
			tax_accrued = int(float(net_profit) * CORPORATE_TAX_RATE)
			b["unpaid_taxes"] = int(b.get("unpaid_taxes", 0)) + tax_accrued

		# Treasury impact
		b["treasury"] = int(b.get("treasury", 0)) + net_profit
		b["annual_revenue"] = generated_revenue
		b["annual_opex"] = total_opex
		b["net_profit"] = net_profit

		# Update business valuation based on revenue and net profit
		var base_val: int = int(generated_revenue * 1.5) + maxi(0, net_profit * 3)
		b["valuation"] = maxi(25000, base_val)

		var b_name: String = str(b.get("name", "Enterprise"))
		var profit_str: String = ("+$%d" % net_profit) if net_profit >= 0 else ("-$%d" % abs(net_profit))

		PlayerData.add_life_log_entry("🏢 %s Annual Report: Revenue: $%d | OpEx: $%d | Net Profit: %s | Treasury: $%d (Taxes Accrued: $%d)" % [
			b_name,
			generated_revenue,
			total_opex,
			profit_str,
			int(b.get("treasury", 0)),
			tax_accrued
		], "finance")

		results.append({
			"name": b_name,
			"revenue": generated_revenue,
			"opex": total_opex,
			"net_profit": net_profit,
			"tax_accrued": tax_accrued,
			"treasury": int(b.get("treasury", 0))
		})

	return results


# Financial Operations
static func pay_business_taxes(b: Dictionary, amount: int = -1) -> Dictionary:
	var unpaid: int = int(b.get("unpaid_taxes", 0))
	if unpaid <= 0:
		return {"success": false, "message": "No corporate taxes currently due."}

	var to_pay: int = unpaid if (amount <= 0 or amount > unpaid) else amount
	var treasury: int = int(b.get("treasury", 0))

	if treasury >= to_pay:
		b["treasury"] = treasury - to_pay
		b["unpaid_taxes"] = unpaid - to_pay
	else:
		# Can draw from owner personal cash if treasury is insufficient
		var rem: int = to_pay - treasury
		if PlayerData.money >= rem:
			b["treasury"] = 0
			PlayerData.money -= rem
			b["unpaid_taxes"] = unpaid - to_pay
		else:
			return {"success": false, "message": "Insufficient funds in treasury ($%d) and personal cash to pay $%d taxes." % [treasury, to_pay]}

	b["last_tax_paid_year"] = PlayerData.age
	PlayerData.add_life_log_entry("🏛️ CORPORATE TAXES PAID: %s paid $%d in state corporate taxes. Unpaid balance: $%d." % [
		str(b.get("name", "Business")),
		to_pay,
		int(b.get("unpaid_taxes", 0))
	], "finance")

	return {"success": true, "message": "Successfully paid $%d in corporate taxes." % to_pay}


static func take_business_loan(b: Dictionary, principal: int) -> Dictionary:
	if principal <= 0:
		return {"success": false, "message": "Invalid loan amount."}

	var cur_loan: int = int(b.get("loan_balance", 0))
	var val: int = int(b.get("valuation", 50000))
	var max_credit_limit: int = maxi(100000, val * 2)

	if cur_loan + principal > max_credit_limit:
		return {"success": false, "message": "Commercial credit limit exceeded! Max borrowing limit is $%d (Current Loan: $%d)." % [max_credit_limit, cur_loan]}

	b["loan_balance"] = cur_loan + principal
	b["treasury"] = int(b.get("treasury", 0)) + principal

	PlayerData.add_life_log_entry("🏦 COMMERCIAL LOAN APPROVED: %s secured a $%d bank loan at 7.5%% APR. Disbursed into business treasury." % [
		str(b.get("name", "Business")),
		principal
	], "finance")

	return {"success": true, "message": "Loan of $%d disbursed to business treasury." % principal}


static func repay_business_loan(b: Dictionary, amount: int) -> Dictionary:
	var cur_loan: int = int(b.get("loan_balance", 0))
	if cur_loan <= 0:
		return {"success": false, "message": "No active commercial loan to repay."}

	var to_repay: int = mini(cur_loan, amount)
	var treasury: int = int(b.get("treasury", 0))

	if treasury >= to_repay:
		b["treasury"] = treasury - to_repay
		b["loan_balance"] = cur_loan - to_repay
	else:
		var rem: int = to_repay - treasury
		if PlayerData.money >= rem:
			b["treasury"] = 0
			PlayerData.money -= rem
			b["loan_balance"] = cur_loan - to_repay
		else:
			return {"success": false, "message": "Insufficient funds in treasury ($%d) and personal cash to repay $%d." % [treasury, to_repay]}

	PlayerData.add_life_log_entry("🏦 LOAN PRINCIPAL REPAID: %s repaid $%d towards its commercial loan balance. Remaining: $%d." % [
		str(b.get("name", "Business")),
		to_repay,
		int(b.get("loan_balance", 0))
	], "finance")

	return {"success": true, "message": "Repaid $%d towards commercial loan." % to_repay}


static func withdraw_owner_dividend(b: Dictionary, amount: int) -> Dictionary:
	var treasury: int = int(b.get("treasury", 0))
	if amount <= 0:
		return {"success": false, "message": "Invalid dividend amount."}
	if treasury < amount:
		return {"success": false, "message": "Insufficient funds in business treasury (Current: $%d)." % treasury}

	b["treasury"] = treasury - amount
	PlayerData.money += amount

	PlayerData.add_life_log_entry("💰 OWNER DIVIDEND: You withdrew $%d from %s into your personal pocket cash." % [
		amount,
		str(b.get("name", "Business"))
	], "finance")

	return {"success": true, "message": "Withdrew $%d dividend to personal cash." % amount}


static func deposit_owner_capital(b: Dictionary, amount: int) -> Dictionary:
	if amount <= 0:
		return {"success": false, "message": "Invalid capital amount."}
	if PlayerData.money < amount:
		return {"success": false, "message": "Insufficient personal cash to inject capital."}

	PlayerData.money -= amount
	b["treasury"] = int(b.get("treasury", 0)) + amount

	PlayerData.add_life_log_entry("💵 CAPITAL INJECTION: You contributed $%d personal funds into %s treasury." % [
		amount,
		str(b.get("name", "Business"))
	], "finance")

	return {"success": true, "message": "Injected $%d capital into business treasury." % amount}


static func adjust_staff(b: Dictionary, delta: int) -> Dictionary:
	var cur: int = int(b.get("employees", 4))
	var new_count: int = cur + delta
	if new_count < 1:
		return {"success": false, "message": "A business must maintain at least 1 employee to operate."}
	if new_count > 50:
		return {"success": false, "message": "Maximum facility employee headcount reached."}

	b["employees"] = new_count
	var act_str: String = "hired %d additional staff" % delta if delta > 0 else "laid off %d staff" % abs(delta)
	return {"success": true, "message": "Headcount adjusted: %s. Total staff: %d." % [act_str, new_count]}


static func liquidate_business(biz_uid: String) -> Dictionary:
	var found_idx: int = -1
	for i in range(PlayerData.owned_businesses.size()):
		if str(PlayerData.owned_businesses[i].get("uid", "")) == biz_uid:
			found_idx = i
			break

	if found_idx == -1:
		return {"success": false, "message": "Enterprise not found."}

	var b: Dictionary = PlayerData.owned_businesses[found_idx]
	var val: int = int(b.get("valuation", 20000))
	var treasury: int = int(b.get("treasury", 0))
	var loan: int = int(b.get("loan_balance", 0))
	var unpaid_tax: int = int(b.get("unpaid_taxes", 0))

	# Net liquidation proceeds: Valuation + Treasury - Loan - Unpaid taxes
	var net_proceeds: int = (val + treasury) - (loan + unpaid_tax)
	if net_proceeds > 0:
		PlayerData.money += net_proceeds
	else:
		PlayerData.money = maxi(0, PlayerData.money + net_proceeds)

	var b_name: String = str(b.get("name", "Enterprise"))
	PlayerData.owned_businesses.remove_at(found_idx)

	PlayerData.add_life_log_entry("💼 BUSINESS SOLD: You liquidated '%s' for net cash proceeds of $%d." % [b_name, net_proceeds], "milestone")

	return {"success": true, "message": "Successfully liquidated '%s' for $%d net proceeds." % [b_name, net_proceeds]}
