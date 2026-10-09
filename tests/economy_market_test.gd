extends Node

var failures := 0


func check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)


func _ready() -> void:
	seed(87412)
	LifeLibrary.profile_path = "user://economy_test_profile.json"
	LifeLibrary.data.language = "en"
	LifeLibrary.data.currency = "USD"
	PlayerData.reset_player()
	PlayerData.first_name = "Market Test"
	PlayerData.has_started_game = true
	PlayerData.age = 25
	PlayerData.money = 100000000
	PlayerData.bank_savings = 0
	FinanceMarket.ensure(PlayerData)
	check(FinanceMarket.active(PlayerData).size() == 8, "Exactly eight initial companies")
	check(FinanceMarket.SECTORS.size() == 24, "24 company archetypes")
	var company: Dictionary = FinanceMarket.active(PlayerData)[0]
	var cash_attempt := FinanceMarket.trade(PlayerData, company.uid, 100, true)
	check(cash_attempt.begins_with("Insufficient bank balance"), "Shares purchases cannot be made with cash alone")
	PlayerData.bank_savings = 100000000
	var bank_before: int = PlayerData.bank_savings
	FinanceMarket.trade(PlayerData, company.uid, 100, true)
	check(int(PlayerData.finance_market.holdings[company.uid].quantity) == 100, "Shares purchased with bank balance")
	check(PlayerData.bank_savings < bank_before, "Bank savings debited for stock purchase")
	FinanceMarket.trade(PlayerData, company.uid, 100, false)
	check(PlayerData.bank_savings < bank_before, "Immediate round trip pays fees rather than generating money")
	var unchanged := SaveManager.capture_data().duplicate(true)
	FinanceMarket.trade(PlayerData, company.uid, -10, true)
	FinanceMarket.trade(PlayerData, company.uid, 100, false)
	check(PlayerData.bank_savings == int(unchanged.bank_savings), "Invalid transactions are side-effect free")
	var rose := false
	var fell := false
	var npc_sold := false
	var initial_serial: int = PlayerData.finance_market.serial
	for year in range(40):
		PlayerData.age += 1
		FinanceMarket.advance_year(PlayerData)
		check(FinanceMarket.active(PlayerData).size() == 8, "Eight active companies after turnover")
		for c in FinanceMarket.active(PlayerData):
			rose = rose or float(c.price) > float(c.previous)
			fell = fell or float(c.price) < float(c.previous)
			npc_sold = npc_sold or int(c.npc_sells) > 0
			var shares: int = int(c.available) + int(PlayerData.finance_market.holdings.get(c.uid, {}).get("quantity", 0))
			for trader in PlayerData.finance_market.traders:
				shares += int(trader.positions.get(c.uid, 0))
				check(float(trader.cash) >= -0.001, "NPC budgets stay nonnegative")
			check(shares == FinanceMarket.FLOAT, "Public shares are conserved")
	var market_copy := JSON.stringify(PlayerData.finance_market)
	FinanceMarket.advance_year(PlayerData)
	check(JSON.stringify(PlayerData.finance_market) == market_copy, "Same year cannot reroll prices")
	check(rose and fell and npc_sold, "Prices rise and fall; NPCs sell actual holdings")
	check(int(PlayerData.finance_market.serial) > initial_serial, "Closures create new issuers")
	company = FinanceMarket.active(PlayerData)[0]
	FinanceMarket.trade(PlayerData, company.uid, 100, true)
	var acquisition_cost := FinanceMarket.acquisition_price(PlayerData, company)
	var savings_before := PlayerData.bank_savings
	FinanceMarket.acquire(PlayerData, company.uid)
	check(PlayerData.bank_savings == savings_before - acquisition_cost, "Acquisition cost credits existing shares and debits bank savings")
	check(PlayerData.owned_businesses.size() == 1 and PlayerData.licenses.is_empty(), "Acquisition requires no license")
	check(not PlayerData.finance_market.holdings.has(company.uid), "Acquired shares are not double counted")
	var business: Dictionary = PlayerData.owned_businesses[0]
	business.cumulative_net_profit = 1000000
	FinanceMarket.request_ipo(PlayerData, business)
	check(not business.has("listing_uid"), "Exactly one million is below IPO threshold")
	business.cumulative_net_profit = 1000001
	FinanceMarket.request_ipo(PlayerData, business)
	check(business.has("listing_uid") and float(business.owner_fraction) == 0.8, "IPO creates a public listing with dilution")
	var treasury := int(business.treasury)
	FinanceMarket.request_ipo(PlayerData, business)
	check(int(business.treasury) == treasury, "IPO cannot be repeated")
	PlayerData.age += 1
	FinanceMarket.advance_year(PlayerData)
	var listed := FinanceMarket.issuer(PlayerData, business.listing_uid)
	check(int(listed.npc_buys) > 0, "NPCs trade the player IPO")
	var path := "user://economy_test_save.json"
	check(SaveManager.save_game(path), "Finance state saves")
	PlayerData.finance_market = {}
	PlayerData.owned_businesses = []
	check(SaveManager.load_game(path), "Finance state loads")
	check(PlayerData.owned_businesses.size() == 1 and FinanceMarket.active(PlayerData).size() == 8, "Business and exchange persist")
	var shares_before: int = FinanceMarket.portfolio_value(PlayerData)
	PlayerData.takeover_as_child({"name": "Test Heir", "age": 20}, 1234, [])
	check(PlayerData.bank_savings == 1234 and PlayerData.money == 0 and PlayerData.owned_businesses.size() == 1, "Heir receives bank balance and intact businesses, not duplicate cash")
	check(FinanceMarket.portfolio_value(PlayerData) == shares_before, "Heir receives portfolio")
	check(int(PlayerData.finance_market.last_age) == 20, "Inherited market clock rebased")
	var result := BusinessManager.liquidate_business(PlayerData.owned_businesses[0].uid)
	check(result.success and PlayerData.owned_businesses.is_empty(), "Acquired business can be resold")
	PlayerData.money = 100
	PlayerData.bank_savings = 0
	PlayerData.debt = 0
	PlayerData.owned_businesses.append({"uid": "insolvent_test", "name": "Insolvent Test", "valuation": 100, "treasury": 0, "loan_balance": 1000, "unpaid_taxes": 0})
	BusinessManager.liquidate_business("insolvent_test")
	check(PlayerData.money == 0 and PlayerData.debt == 800, "Resale cannot erase unpaid liabilities")
	PlayerData.money = 1000
	PlayerData.smarts = 50
	BalanceRules.learn(PlayerData, "reading")
	check(PlayerData.smarts == 53 and PlayerData.last_school_activity_age == PlayerData.age, "Free learning protects mental maintenance")
	BalanceRules.learn(PlayerData, "reading")
	check(PlayerData.smarts == 53, "Learning cannot be spammed")
	check(BalanceRules.event_effects({"smarts": 40, "money": 50000}, 12).money == 150, "Child event cash rewards capped")
	check(BalanceRules.salary(20000, "retail") == 22400, "Entry salaries improved")
	for lang in ["en", "id", "ru"]:
		check(GameLocale.set_preferences(lang, "IDR"), "Language preference persists")
		check(not GameLocale.translate("FINANCE MARKET").is_empty(), "Market title translated")
		check(not GameLocale.translate("Owner: %s • Price: %s (%+.1f%%)").is_empty(), "Formatted translation valid")
	check(GameLocale.money(1) == "Rp 16,000", "Fixed fictional currency conversion")
	check(PlayerData.money == 1000, "Currency preferences do not change money")
	check(GameLocale.display("Loss $-20").contains("Rp 320,000"), "Signed currency amounts convert")
	check(not GameLocale.display("Cash: $100 • Portfolio: $200").contains("Cash:"), "Formatted currency labels translate")
	GameLocale.set_preferences("en", "USD")
	DirAccess.remove_absolute(path)
	DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("ECONOMY_MARKET_TEST: %d failures" % failures)
	get_tree().quit(failures)
