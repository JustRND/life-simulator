extends Node

var failures := 0
var log_lines: Array[String] = []


func check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		log_lines.append("❌ FAILED: " + description)
		push_error("FAILED: " + description)
	else:
		log_lines.append("✔ PASSED: " + description)


func _ready() -> void:
	print("=== RUNNING CREDIT SYSTEM & BANKING COMPREHENSIVE TESTS ===")
	LifeLibrary.profile_path = "user://credit_test_profile.json"
	
	# -------------------------------------------------------------
	# 1. SHARES PURCHASES CANNOT BE MADE WITH CASH (BANK BALANCE ONLY)
	# -------------------------------------------------------------
	PlayerData.reset_player()
	PlayerData.first_name = "Finance Tester"
	PlayerData.has_started_game = true
	PlayerData.age = 25
	PlayerData.money = 500000 # Cash only!
	PlayerData.bank_savings = 0
	
	FinanceMarket.ensure(PlayerData)
	var active_listings := FinanceMarket.active(PlayerData)
	check(active_listings.size() > 0, "Market has active listings")
	var stock: Dictionary = active_listings[0]
	
	# Attempt to buy shares with cash only:
	var cash_result := FinanceMarket.trade(PlayerData, stock.uid, 10, true)
	check(cash_result.begins_with("Insufficient bank balance"), "Shares purchase with cash alone must be declined (%s)" % cash_result)
	check(not PlayerData.finance_market.holdings.has(stock.uid), "No shares purchased with cash")
	check(PlayerData.money == 500000, "Cash untouched by rejected trade")
	
	# Fund bank savings and buy:
	PlayerData.deposit_cash(200000)
	check(PlayerData.bank_savings == 200000 and PlayerData.money == 300000, "Deposited cash into bank")
	var bank_before := PlayerData.bank_savings
	var buy_result := FinanceMarket.trade(PlayerData, stock.uid, 10, true)
	check(buy_result.begins_with("Bought 10 shares"), "Shares purchase succeeds using bank balance (%s)" % buy_result)
	check(PlayerData.bank_savings < bank_before, "Bank balance debited for stock purchase")
	check(PlayerData.money == 300000, "Cash was completely untouched by stock purchase")
	
	# Selling shares deposits back into bank balance:
	var bank_before_sell := PlayerData.bank_savings
	var sell_result := FinanceMarket.trade(PlayerData, stock.uid, 10, false)
	check(sell_result.begins_with("Sold 10 shares"), "Shares sold successfully")
	check(PlayerData.bank_savings > bank_before_sell, "Sale proceeds deposited into bank balance")
	check(PlayerData.money == 300000, "Cash remained untouched on stock sale")
	
	# -------------------------------------------------------------
	# 1b. PURCHASING IN-GAME PRIORITIZES BANK BALANCE FIRST THEN CASH
	# -------------------------------------------------------------
	PlayerData.bank_savings = 1000
	PlayerData.money = 500
	check(PlayerData.debit_funds(400), "Can debit 400")
	check(PlayerData.bank_savings == 600 and PlayerData.money == 500, "Debit prioritized bank balance (bank: 600, cash: 500)")
	
	# Debit more than remaining bank balance:
	check(PlayerData.debit_funds(800), "Can debit 800")
	check(PlayerData.bank_savings == 0 and PlayerData.money == 300, "Remaining 200 taken from cash after bank exhausted (bank: 0, cash: 300)")
	check(not PlayerData.debit_funds(301), "Cannot debit more than total available funds")
	check(PlayerData.debit_funds(300), "Can debit all remaining cash")
	check(PlayerData.bank_savings == 0 and PlayerData.money == 0, "All funds zeroed")
	
	# -------------------------------------------------------------
	# 2. NEW BANK LOAN OPTIONS: $250,000 AND $500,000
	# -------------------------------------------------------------
	PlayerData.money = 0
	PlayerData.bank_savings = 0
	PlayerData.loan_balance = 0
	
	check(PlayerData.take_bank_loan(250000, 0.12), "Borrowing $250,000 corporate loan succeeded")
	check(PlayerData.loan_balance == 250000, "Loan balance recorded as $250,000")
	check(is_equal_approx(PlayerData.loan_interest_rate, 0.12), "Loan interest rate recorded as 12%")
	check(not PlayerData.take_bank_loan(500000, 0.14), "Cannot borrow second loan while loan is active")
	
	# Repay full loan and test $500,000 tier:
	PlayerData.bank_savings = 300000
	var paid := PlayerData.repay_bank_loan(250000)
	check(paid == 250000, "Repaid $250,000 loan")
	check(PlayerData.loan_balance == 0, "Loan balance is zero")
	
	check(PlayerData.take_bank_loan(500000, 0.14), "Borrowing $500,000 jumbo loan succeeded")
	check(PlayerData.loan_balance == 500000, "Loan balance recorded as $500,000")
	check(is_equal_approx(PlayerData.loan_interest_rate, 0.14), "Loan interest rate recorded as 14%")
	PlayerData.bank_savings = 600000
	PlayerData.repay_bank_loan(500000)
	check(PlayerData.loan_balance == 0, "Cleaned up loan balance")
	
	# -------------------------------------------------------------
	# 3. CREDIT CARD SYSTEM: STRICT APPLICATION APPROVAL/DECLINE
	# -------------------------------------------------------------
	PlayerData.reset_player()
	PlayerData.first_name = "Credit Applicant"
	PlayerData.age = 25
	PlayerData.has_started_game = true
	PlayerData.credit_score = 720
	PlayerData.money = 50000
	PlayerData.bank_savings = 50000
	
	# Case A: Character has active loan -> MUST DECLINE
	PlayerData.loan_balance = 5000
	var check_loan := PlayerData.can_apply_credit_card("Gold")
	check(not bool(check_loan.get("eligible", false)), "Credit card application MUST be declined when player has loan balance")
	PlayerData.loan_balance = 0
	
	# Case B: Character has unpaid taxes -> MUST DECLINE
	PlayerData.tax_debt = 200
	var check_tax := PlayerData.can_apply_credit_card("Gold")
	check(not bool(check_tax.get("eligible", false)), "Credit card application MUST be declined when player has unpaid taxes")
	PlayerData.tax_debt = 0
	
	# Case C: Character has other debt -> MUST DECLINE
	PlayerData.debt = 500
	var check_debt := PlayerData.can_apply_credit_card("Gold")
	check(not bool(check_debt.get("eligible", false)), "Credit card application MUST be declined when player has general debt")
	PlayerData.debt = 0
	
	# Case D: Underage character -> MUST DECLINE
	PlayerData.age = 17
	var check_age := PlayerData.can_apply_credit_card("Silver")
	check(not bool(check_age.get("eligible", false)), "Credit card application MUST be declined for underage player")
	PlayerData.age = 25
	
	# Case E: Insufficient Credit Score -> MUST DECLINE
	PlayerData.credit_score = 550
	var check_score := PlayerData.can_apply_credit_card("Silver")
	check(not bool(check_score.get("eligible", false)), "Credit card application MUST be declined with low credit score (< 600)")
	
	# Case F: Insufficient Net Worth -> MUST DECLINE
	PlayerData.credit_score = 750
	PlayerData.money = 100
	PlayerData.bank_savings = 100
	var check_nw := PlayerData.can_apply_credit_card("Gold")
	check(not bool(check_nw.get("eligible", false)), "Gold card declined when net worth < $30,000")
	
	# Case G: Clean profile, qualifies for Gold card -> MUST APPROVE
	PlayerData.money = 20000
	PlayerData.bank_savings = 25000
	var check_gold := PlayerData.can_apply_credit_card("Gold")
	check(bool(check_gold.get("eligible", false)), "Gold card approved when debt=0, tax=0, net worth and score qualify")
	
	var approve_gold := PlayerData.approve_credit_card("Gold")
	check(approve_gold, "Successfully approved and opened Gold Credit Card")
	check(PlayerData.has_credit_card, "Player now has credit card")
	check(PlayerData.credit_card_tier == "Gold", "Tier is Gold")
	check(PlayerData.credit_card_limit == 25000, "Limit is $25,000")
	check(PlayerData.credit_card_balance == 0, "Initial balance is 0")
	check(PlayerData.get_credit_card_available() == 25000, "Full $25,000 available")
	
	# -------------------------------------------------------------
	# 3b. CREDIT CARD TRANSACTIONS & REPAYMENT
	# -------------------------------------------------------------
	var draw_ok := PlayerData.draw_credit_card_advance(5000)
	check(draw_ok, "Drew $5,000 cash advance from credit card")
	check(PlayerData.credit_card_balance == 5000, "Card balance is now $5,000")
	check(PlayerData.get_credit_card_available() == 20000, "Available credit is $20,000")
	check(PlayerData.get_total_debt() == 5000, "Total debt reflects credit card balance")
	
	# Cannot cancel card with active balance:
	check(not PlayerData.cancel_credit_card(), "Cannot cancel credit card with outstanding balance")
	
	# Repay part:
	var score_before := PlayerData.credit_score
	var repaid_part := PlayerData.repay_credit_card(2000)
	check(repaid_part == 2000, "Repaid $2,000 of card balance")
	check(PlayerData.credit_card_balance == 3000, "Remaining card balance is $3,000")
	check(PlayerData.credit_score >= score_before, "Credit score maintained or improved on repayment")
	
	# Repay full:
	var repaid_full := PlayerData.repay_credit_card(3000)
	check(repaid_full == 3000, "Repaid remaining $3,000 balance")
	check(PlayerData.credit_card_balance == 0, "Card balance is 0")
	check(PlayerData.get_total_debt() == 0, "Total debt is 0")
	check(PlayerData.cancel_credit_card(), "Card cancelled successfully after full repayment")
	check(not PlayerData.has_credit_card, "Player has no active credit card after cancellation")
	
	# -------------------------------------------------------------
	# 4. CREDIT SCORE SYSTEM & NON-INHERITANCE TO CHILDREN
	# -------------------------------------------------------------
	# Set parent's score to 820 with Platinum card
	PlayerData.credit_score = 820
	check(PlayerData.get_credit_rating() == "Exceptional", "Rating is Exceptional for score 820")
	check(PlayerData.get_credit_score_color() == Color("#10b981"), "Color is green for Exceptional")
	PlayerData.has_credit_card = true
	PlayerData.credit_card_tier = "Platinum"
	PlayerData.credit_card_limit = 100000
	PlayerData.credit_card_balance = 15000
	
	# Child takeover:
	var heir := {"name": "New Generation", "age": 18, "gender": "FEMALE"}
	PlayerData.takeover_as_child(heir, 50000, [])
	
	check(PlayerData.credit_score == 650, "CRITICAL: Child DOES NOT inherit parent's credit score! Starts at default 650 (Current: %d)" % PlayerData.credit_score)
	check(not PlayerData.has_credit_card, "CRITICAL: Child DOES NOT inherit credit card account!")
	check(PlayerData.credit_card_tier == "None", "Child card tier is None")
	check(PlayerData.credit_card_limit == 0, "Child card limit is 0")
	check(PlayerData.credit_card_balance == 0, "Child DOES NOT inherit parent's credit card debt!")
	check(PlayerData.get_credit_rating() == "Fair", "Rating for 650 is Fair")
	
	# -------------------------------------------------------------
	# SUMMARY
	# -------------------------------------------------------------
	for line in log_lines:
		print(line)
		
	if failures == 0:
		print("\n🎉 ALL CREDIT SYSTEM & BANKING TESTS PASSED PERFECTLY!")
	else:
		print("\n❌ SOME TESTS FAILED (%d failures)" % failures)
		assert(failures == 0, "Credit system & banking test had %d failures!" % failures)
	
	get_tree().quit()
