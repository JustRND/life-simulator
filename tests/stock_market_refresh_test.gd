extends Node

var failures := 0
var log_lines: Array[String] = []

func check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		log_lines.append("❌ FAILED: " + description)
	else:
		log_lines.append("✔ PASSED: " + description)


func _ready() -> void:
	seed(42891)
	LifeLibrary.profile_path = "user://stock_test_profile.json"
	PlayerData.reset_player()
	PlayerData.first_name = "Stock Tester"
	PlayerData.has_started_game = true
	PlayerData.age = 25
	PlayerData.money = 1000000
	PlayerData.bank_savings = 1000000
	
	log_lines.append("--- TEST CASE: BUY STOCK -> MARKET REFRESHES -> STOCK PERSISTS IN PORTFOLIO ---")
	FinanceMarket.ensure(PlayerData)
	check(FinanceMarket.active(PlayerData).size() == 8, "Exchange starts with 8 active listings")
	
	# 1. Player buys 100 shares of company 0
	var target_stock: Dictionary = FinanceMarket.active(PlayerData)[0]
	var target_uid: String = target_stock.uid
	var target_name: String = target_stock.name
	var buy_price: float = float(target_stock.price)
	print("Purchasing 100 shares of %s (UID: %s) at $%s/share" % [target_name, target_uid, str(buy_price)])
	
	var trade_result := FinanceMarket.trade(PlayerData, target_uid, 100, true)
	check(trade_result.begins_with("Bought 100 shares"), "Stock purchase succeeded")
	check(PlayerData.finance_market.holdings.has(target_uid), "Stock is recorded in PlayerData.finance_market.holdings")
	check(int(PlayerData.finance_market.holdings[target_uid].quantity) == 100, "100 shares held")
	
	var port_val_before: int = FinanceMarket.portfolio_value(PlayerData)
	check(port_val_before > 0, "Portfolio value before refresh is positive (%d)" % port_val_before)
	
	# 2. Simulate the stock market refreshing that specific stock
	print("\nTriggering stock market refresh on that specific stock (%s)..." % target_name)
	FinanceMarket._close(PlayerData, target_stock)
	
	# Verification immediately after refresh:
	check(not bool(target_stock.active), "Stock is no longer active on the exchange")
	check(PlayerData.finance_market.holdings.has(target_uid), "CRITICAL: Stock is STILL in player holdings after stock market refresh!")
	check(int(PlayerData.finance_market.holdings[target_uid].quantity) == 100, "Player still owns all 100 shares")
	
	# Issuer lookup check:
	var lookup_company := FinanceMarket.issuer(PlayerData, target_uid)
	check(not lookup_company.is_empty(), "Issuer is STILL retrievable via FinanceMarket.issuer")
	check(lookup_company.name == target_name, "Issuer name is preserved")
	
	# Portfolio value check:
	var port_val_after: int = FinanceMarket.portfolio_value(PlayerData)
	check(port_val_after == port_val_before, "Portfolio value is preserved regardless of market refresh (%d == %d)" % [port_val_after, port_val_before])
	
	# Refill check:
	FinanceMarket._fill(PlayerData)
	check(FinanceMarket.active(PlayerData).size() == 8, "Exchange has 8 active listings after replacement opens")
	var active_uids := []
	for c in FinanceMarket.active(PlayerData):
		active_uids.append(c.uid)
	check(not active_uids.has(target_uid), "Target stock is rotated off the active exchange listings")
	
	# 3. Advance years: Stock market continues to cycle, but player's stock remains in portfolio
	print("\nAdvancing 5 character years to test market turnover persistence...")
	for y in range(5):
		PlayerData.age += 1
		FinanceMarket.advance_year(PlayerData)
		check(PlayerData.finance_market.holdings.has(target_uid), "Year %d: Stock STILL present in holdings" % PlayerData.age)
		check(FinanceMarket.portfolio_value(PlayerData) > 0, "Year %d: Portfolio value remains positive" % PlayerData.age)
		check(FinanceMarket.active(PlayerData).size() == 8, "Year %d: Active listings remain at 8" % PlayerData.age)
	
	# 4. Save and Load Test with off-market stock
	print("\nTesting Save and Load persistence with off-market stock...")
	var save_path := "user://stock_refresh_test_save.json"
	SaveManager.save_game(save_path)
	PlayerData.finance_market = {}
	SaveManager.load_game(save_path)
	check(PlayerData.finance_market.holdings.has(target_uid), "Stock persists across save and load")
	check(not FinanceMarket.issuer(PlayerData, target_uid).is_empty(), "Issuer persists across save and load")
	check(FinanceMarket.portfolio_value(PlayerData) > 0, "Portfolio value persists across save and load")
	
	# 5. Selling off-market stock from Portfolio
	print("\nTesting selling off-market shares from portfolio...")
	var bank_before_partial: int = PlayerData.bank_savings
	var sell_partial_res := FinanceMarket.trade(PlayerData, target_uid, 40, false)
	check(sell_partial_res.begins_with("Sold 40 shares"), "Can sell custom amount (40 shares) of off-market stock")
	check(PlayerData.bank_savings > bank_before_partial, "Bank savings increased after sale")
	check(int(PlayerData.finance_market.holdings[target_uid].quantity) == 60, "60 shares remain in holding")
	
	var bank_before_all: int = PlayerData.bank_savings
	var sell_all_res := FinanceMarket.trade(PlayerData, target_uid, 60, false)
	check(sell_all_res.begins_with("Sold 60 shares"), "Can sell remaining shares of off-market stock")
	check(PlayerData.bank_savings > bank_before_all, "Bank savings increased after final sale")
	check(not PlayerData.finance_market.holdings.has(target_uid), "Holding is removed once quantity reaches 0")
	check(FinanceMarket.portfolio_value(PlayerData) == 0, "Portfolio value is 0 after selling all shares")
	
	# 6. Self-healing test for legacy saves
	print("\nTesting self-healing for legacy saves with orphaned holdings...")
	PlayerData.finance_market.holdings["legacy_orphan_1"] = {"quantity": 50, "cost": 500, "name": "Orphaned Corp", "price": 15.0}
	FinanceMarket.ensure(PlayerData)
	var healed_issuer := FinanceMarket.issuer(PlayerData, "legacy_orphan_1")
	check(not healed_issuer.is_empty(), "Self-healing restored issuer entry for orphaned holding")
	check(FinanceMarket.portfolio_value(PlayerData) == 50 * 15, "Orphaned holding value is accurately calculated (%d)" % (50 * 15))
	var sell_legacy := FinanceMarket.trade(PlayerData, "legacy_orphan_1", 50, false)
	check(sell_legacy.begins_with("Sold 50 shares"), "Player can sell healed legacy shares")
	
	DirAccess.remove_absolute(save_path)
	DirAccess.remove_absolute(LifeLibrary.profile_path)
	
	log_lines.append("STOCK_MARKET_REFRESH_TEST FINISHED: %d failures" % failures)
	var f := FileAccess.open("user://stock_test_result.log", FileAccess.WRITE)
	if f != null:
		for l in log_lines:
			f.store_line(l)
		f.close()
	get_tree().quit(failures)
