class_name CollateralManager
extends RefCounted

## CollateralManager: Handles loan/debt delinquency, legal demand event warnings,
## and forced or voluntary collateral seizure of personal assets and commercial businesses.


static func get_debt_breakdown(player_data: Node) -> Dictionary:
	var tax_debt: int = maxi(0, int(player_data.get("tax_debt")))
	var loan_bal: int = maxi(0, int(player_data.get("loan_balance")))
	var gen_debt: int = maxi(0, int(player_data.get("debt")))
	var cc_bal: int = maxi(0, int(player_data.get("credit_card_balance")))

	var biz_loans: int = 0
	var biz_taxes: int = 0
	var owned_biz: Array = player_data.get("owned_businesses") if player_data.get("owned_businesses") != null else []
	for b in owned_biz:
		if b is Dictionary:
			biz_loans += maxi(0, int(b.get("loan_balance", 0)))
			biz_taxes += maxi(0, int(b.get("unpaid_taxes", 0)))

	var total_personal: int = tax_debt + loan_bal + gen_debt + cc_bal
	var total_business: int = biz_loans + biz_taxes
	var total: int = total_personal + total_business

	return {
		"tax_debt": tax_debt,
		"loan_balance": loan_bal,
		"debt": gen_debt,
		"credit_card_balance": cc_bal,
		"business_loans": biz_loans,
		"business_unpaid_taxes": biz_taxes,
		"total_personal_debt": total_personal,
		"total_business_debt": total_business,
		"total_debt": total,
		"has_debt": total > 0
	}


static func get_total_liabilities(player_data: Node) -> int:
	return int(get_debt_breakdown(player_data)["total_debt"])


static func get_collateral_breakdown(player_data: Node) -> Dictionary:
	var assets_list: Array[Dictionary] = []
	var total_asset_val: int = 0
	var owned_assets: Array = player_data.get("owned_assets") if player_data.get("owned_assets") != null else []
	for a in owned_assets:
		if a is Dictionary:
			var val: int = maxi(0, int(a.get("current_value", a.get("purchase_price", 0))))
			assets_list.append({
				"name": str(a.get("name", "Titled Asset")),
				"category": str(a.get("category", "General")),
				"value": val,
				"raw": a
			})
			total_asset_val += val

	var biz_list: Array[Dictionary] = []
	var total_biz_equity: int = 0
	var owned_biz: Array = player_data.get("owned_businesses") if player_data.get("owned_businesses") != null else []
	for b in owned_biz:
		if b is Dictionary:
			var val: int = int(b.get("valuation", 20000))
			var treasury: int = int(b.get("treasury", 0))
			var b_loan: int = int(b.get("loan_balance", 0))
			var b_tax: int = int(b.get("unpaid_taxes", 0))
			var net_equity: int = maxi(0, int((int(val * 0.75) + treasury) - (b_loan + b_tax)))
			biz_list.append({
				"uid": str(b.get("uid", "")),
				"name": str(b.get("name", "Commercial Enterprise")),
				"valuation": val,
				"net_equity": net_equity,
				"raw": b
			})
			total_biz_equity += net_equity

	return {
		"assets": assets_list,
		"businesses": biz_list,
		"total_asset_value": total_asset_val,
		"total_business_equity": total_biz_equity,
		"total_collateral_value": total_asset_val + total_biz_equity,
		"total_seizable_items": assets_list.size() + biz_list.size()
	}


static func process_yearly_delinquency(player_data: Node) -> void:
	if int(player_data.get("age")) < 18 or bool(player_data.get("is_in_prison")):
		return

	var debt_info := get_debt_breakdown(player_data)
	if bool(debt_info["has_debt"]):
		player_data.set("debt_delinquency_years", int(player_data.get("debt_delinquency_years")) + 1)
	else:
		player_data.set("debt_delinquency_years", 0)
		player_data.set("has_debt_warning", false)


static func check_and_trigger_event(player_data: Node, main_screen: Node) -> Dictionary:
	if int(player_data.get("age")) < 18 or bool(player_data.get("is_in_prison")):
		return {}

	var debt_info := get_debt_breakdown(player_data)
	if not bool(debt_info["has_debt"]):
		return {}

	var delinq: int = int(player_data.get("debt_delinquency_years"))
	var has_warn: bool = bool(player_data.get("has_debt_warning"))

	# Seizure execution: Triggered when delinquent >= 3 years, or already warned and delinquent >= 2
	if delinq >= 3 or (has_warn and delinq >= 2):
		return build_seizure_event(player_data, main_screen)

	# Warning notice: Triggered when delinquent >= 2 years and warning not yet given
	if delinq >= 2 and not has_warn:
		return build_warning_event(player_data, main_screen)

	return {}


static func build_warning_event(player_data: Node, main_screen: Node) -> Dictionary:
	var debt_info := get_debt_breakdown(player_data)
	var col_info := get_collateral_breakdown(player_data)
	var total_debt: int = int(debt_info["total_debt"])
	var avail_funds: int = int(player_data.get_available_funds()) if player_data.has_method("get_available_funds") else int(player_data.get("money")) + int(player_data.get("bank_savings"))
	var delinq: int = int(player_data.get("debt_delinquency_years"))

	var breakdown_lines: Array[String] = []
	if int(debt_info["tax_debt"]) > 0:
		breakdown_lines.append("• Personal Income & Property Taxes: $%s" % _fmt(int(debt_info["tax_debt"])))
	if int(debt_info["loan_balance"]) > 0:
		breakdown_lines.append("• Outstanding Personal Bank Loans: $%s" % _fmt(int(debt_info["loan_balance"])))
	if int(debt_info["debt"]) > 0:
		breakdown_lines.append("• General Liabilities & Collections: $%s" % _fmt(int(debt_info["debt"])))
	if int(debt_info["credit_card_balance"]) > 0:
		breakdown_lines.append("• Delinquent Credit Card Usage: $%s" % _fmt(int(debt_info["credit_card_balance"])))
	if int(debt_info["business_loans"]) > 0:
		breakdown_lines.append("• Commercial Business Debt: $%s" % _fmt(int(debt_info["business_loans"])))
	if int(debt_info["business_unpaid_taxes"]) > 0:
		breakdown_lines.append("• Overdue Corporate Business Taxes: $%s" % _fmt(int(debt_info["business_unpaid_taxes"])))

	var desc: String = (
		"🏛️ FINAL LEGAL DEMAND NOTICE\n\n" +
		"The Department of Financial Oversight and Bank Creditors have issued a formal demand for overdue liabilities totalling $%s.\n\n" % _fmt(total_debt) +
		"Breakdown of Delinquent Obligations:\n%s\n\n" % "\n".join(breakdown_lines) +
		"Your accounts have remained delinquent for %d consecutive years. Under statutory commercial and lending codes, failure to settle these liabilities will result in FORCED FORECLOSURE AND SEIZURE of your titled assets (vehicles, real estate) and commercial businesses as collateral!\n\n" % delinq +
		"• Liquid Personal Funds Available: $%s\n" % _fmt(avail_funds) +
		"• Estimated Collateral Value: $%s (%d Assets, %d Enterprises)" % [
			_fmt(int(col_info["total_collateral_value"])),
			int(col_info["assets"].size()),
			int(col_info["businesses"].size())
		]
	)

	var cb_settle_full := func() -> String:
		settle_debts_from_funds(player_data, total_debt)
		player_data.set("debt_delinquency_years", 0)
		player_data.set("has_debt_warning", false)
		return "🏛️ DEBT SETTLEMENT COMPLETED: You paid $%s in full to settle all personal and business liabilities. All court foreclosure orders and legal demands have been completely dismissed!" % _fmt(total_debt)

	var cb_settle_partial := func() -> String:
		settle_debts_from_funds(player_data, avail_funds)
		player_data.set("has_debt_warning", true)
		return "💵 GOOD-FAITH PAYMENT ACCEPTED: You paid $%s towards your delinquent debts. Creditors accepted your payment and granted a strict 1-year reprieve to clear remaining balances before foreclosure!" % _fmt(avail_funds)

	var cb_zero_funds := func() -> String:
		player_data.set("has_debt_warning", true)
		return "⚠️ ZERO FUNDS ACKNOWLEDGED: You had $0 liquid funds available. Creditors gave notice that collateral liquidation or emergency forbearance must be executed."

	var cb_surrender := func() -> String:
		var res: Dictionary = execute_seizure(player_data, true)
		return str(res.get("narrative", "Voluntary liquidation completed."))

	var cb_forbearance := func() -> String:
		player_data.set("has_debt_warning", true)
		if player_data.has_method("modify_credit_score"):
			player_data.modify_credit_score(-40)
		return "📜 HARDSHIP FORBEARANCE GRANTED: Creditors approved a strict 1-year emergency stay. You have exactly one year to resolve your liabilities before mandatory collateral seizure! Credit score dropped by 40 points."

	var cb_refuse := func() -> String:
		player_data.set("debt_delinquency_years", 3)
		player_data.set("has_debt_warning", true)
		return "❌ COLLECTION CONTESTED: You refused to comply with the creditor demand. The bank immediately expedited an emergency writ of execution for hostile collateral seizure!"

	var choices: Array[Dictionary] = []

	# Choice 1: Settle from liquid funds
	if avail_funds >= total_debt:
		choices.append({
			"text": "Settle All Overdue Debts in Full ($%s)" % _fmt(total_debt),
			"description": "Pay off all outstanding liabilities from your cash and bank savings.",
			"callback": cb_settle_full
		})
	elif avail_funds > 0:
		choices.append({
			"text": "Make Good-Faith Partial Settlement ($%s)" % _fmt(avail_funds),
			"description": "Pay all available funds towards debts to earn a 1-year court reprieve.",
			"callback": cb_settle_partial
		})
	else:
		choices.append({
			"text": "Explain Inability to Pay (Zero Funds Available)",
			"description": "Acknowledge lack of liquid funds and request creditor options.",
			"callback": cb_zero_funds
		})

	# Choice 2: Voluntarily Liquidate Collateral
	if int(col_info["total_seizable_items"]) > 0:
		choices.append({
			"text": "Voluntarily Liquidate Collateral to Settle Debt",
			"description": "Surrender assets/businesses at fair market value to clear liabilities without foreclosure penalties.",
			"callback": cb_surrender
		})

	# Choice 3: Emergency Hardship Forbearance
	choices.append({
		"text": "File for 1-Year Hardship Forbearance (-40 Credit Score)",
		"description": "Petition for a temporary stay on foreclosure to arrange finances.",
		"callback": cb_forbearance
	})

	# Choice 4: Refuse / Contest
	choices.append({
		"text": "Contest Demand & Refuse Payment",
		"description": "Defiantly reject the bank's collection order.",
		"callback": cb_refuse
	})

	return {
		"id": "event_debt_collateral_warning",
		"title": "🏛️ FINAL DEMAND: BANK FORECLOSURE & COLLATERAL WARNING",
		"text": desc,
		"category": "finance",
		"choices": choices
	}


static func build_seizure_event(player_data: Node, main_screen: Node) -> Dictionary:
	var seizure_res: Dictionary = execute_seizure(player_data, false)
	var narrative: String = str(seizure_res.get("narrative", "Foreclosure proceedings executed."))

	var cb_ack := func() -> String:
		return "⚖️ FORECLOSURE RECORDED: The court foreclosure order has been finalized and entered into civil public records."

	var choices: Array[Dictionary] = [
		{
			"text": "Acknowledge Court Foreclosure Order",
			"description": "Sign receipt of the sheriff's liquidation and collateral auction order.",
			"callback": cb_ack
		}
	]

	return {
		"id": "event_debt_collateral_seizure",
		"title": "🏛️ FORECLOSURE: BANK COLLATERAL SEIZURE EXECUTED",
		"text": narrative,
		"category": "finance",
		"choices": choices
	}


static func settle_debts_from_funds(player_data: Node, amount_to_pay: int) -> int:
	var remaining_payment: int = amount_to_pay
	if remaining_payment <= 0:
		return 0

	# 1. Tax debt (highest legal priority)
	var t_debt: int = int(player_data.get("tax_debt"))
	if t_debt > 0 and remaining_payment > 0:
		var pay: int = mini(remaining_payment, t_debt)
		player_data.set("tax_debt", t_debt - pay)
		remaining_payment -= pay

	# 2. Bank loan
	var l_bal: int = int(player_data.get("loan_balance"))
	if l_bal > 0 and remaining_payment > 0:
		var pay: int = mini(remaining_payment, l_bal)
		player_data.set("loan_balance", l_bal - pay)
		remaining_payment -= pay

	# 3. General debt
	var g_debt: int = int(player_data.get("debt"))
	if g_debt > 0 and remaining_payment > 0:
		var pay: int = mini(remaining_payment, g_debt)
		player_data.set("debt", g_debt - pay)
		remaining_payment -= pay

	# 4. Credit card balance
	var cc_bal: int = int(player_data.get("credit_card_balance"))
	if cc_bal > 0 and remaining_payment > 0:
		var pay: int = mini(remaining_payment, cc_bal)
		player_data.set("credit_card_balance", cc_bal - pay)
		remaining_payment -= pay

	# 5. Business corporate taxes & commercial loans
	var owned_biz: Array = player_data.get("owned_businesses") if player_data.get("owned_businesses") != null else []
	for b in owned_biz:
		if b is Dictionary and remaining_payment > 0:
			var b_tax: int = int(b.get("unpaid_taxes", 0))
			if b_tax > 0 and remaining_payment > 0:
				var pay: int = mini(remaining_payment, b_tax)
				b["unpaid_taxes"] = b_tax - pay
				remaining_payment -= pay
			var b_loan: int = int(b.get("loan_balance", 0))
			if b_loan > 0 and remaining_payment > 0:
				var pay: int = mini(remaining_payment, b_loan)
				b["loan_balance"] = b_loan - pay
				remaining_payment -= pay

	var actually_paid: int = amount_to_pay - remaining_payment
	if actually_paid > 0:
		if player_data.has_method("debit_funds"):
			player_data.debit_funds(actually_paid)
		else:
			var cash: int = int(player_data.get("money"))
			if cash >= actually_paid:
				player_data.set("money", cash - actually_paid)
			else:
				player_data.set("money", 0)
				var savings: int = int(player_data.get("bank_savings"))
				player_data.set("bank_savings", maxi(0, savings - (actually_paid - cash)))

	return actually_paid


static func execute_seizure(player_data: Node, is_voluntary: bool = false) -> Dictionary:
	var debt_info_before := get_debt_breakdown(player_data)
	var initial_total_debt: int = int(debt_info_before["total_debt"])
	var remaining_liability: int = initial_total_debt

	var seized_items: Array[String] = []
	var total_recovered: int = 0
	var discount_factor: float = 1.0 if is_voluntary else 0.85

	# 1. Seize personal owned assets (vehicles, real estate, jewelry, etc.)
	var owned_assets: Array = player_data.get("owned_assets") if player_data.get("owned_assets") != null else []
	# Sort assets: vehicles/items first, real estate last
	var sorted_indices: Array[int] = []
	for i in range(owned_assets.size()):
		sorted_indices.append(i)
	sorted_indices.sort_custom(func(a: int, b: int) -> bool:
		var cat_a: String = str(owned_assets[a].get("category", ""))
		var cat_b: String = str(owned_assets[b].get("category", ""))
		if cat_a != "properties" and cat_b == "properties":
			return true
		return false
	)

	var assets_to_remove: Array[int] = []
	for idx in sorted_indices:
		if remaining_liability <= 0:
			break
		var item: Dictionary = owned_assets[idx]
		var val: int = maxi(0, int(item.get("current_value", item.get("purchase_price", 0))))
		var recovered: int = int(val * discount_factor)
		if recovered <= 0:
			recovered = 100
		total_recovered += recovered
		remaining_liability -= recovered
		assets_to_remove.append(idx)
		seized_items.append("%s '%s' (Recovered $%s)" % [
			str(item.get("category", "Asset")).capitalize(),
			str(item.get("name", "Asset")),
			_fmt(recovered)
		])

	# Remove seized assets in reverse index order
	assets_to_remove.sort()
	assets_to_remove.reverse()
	for idx in assets_to_remove:
		owned_assets.remove_at(idx)

	# 2. Seize commercial businesses if liabilities still remain
	var owned_biz: Array = player_data.get("owned_businesses") if player_data.get("owned_businesses") != null else []
	var biz_to_remove: Array[int] = []
	for i in range(owned_biz.size()):
		if remaining_liability <= 0:
			break
		var b: Dictionary = owned_biz[i]
		var b_val: int = int(b.get("valuation", 20000))
		var treasury: int = int(b.get("treasury", 0))
		var b_loan: int = int(b.get("loan_balance", 0))
		var b_tax: int = int(b.get("unpaid_taxes", 0))
		var net_proceeds: int = int(((int(b_val * (0.80 if is_voluntary else 0.70)) + treasury) - (b_loan + b_tax)) * float(b.get("owner_fraction", 1.0)))

		if ResourceLoader.exists("res://scripts/economy/finance_market.gd"):
			load("res://scripts/economy/finance_market.gd").release_business(player_data, b)

		var effective_recovery: int = maxi(500, net_proceeds)
		total_recovered += effective_recovery
		remaining_liability -= effective_recovery
		biz_to_remove.append(i)
		seized_items.append("Commercial Enterprise '%s' (Recovered $%s)" % [str(b.get("name", "Enterprise")), _fmt(effective_recovery)])

	biz_to_remove.sort()
	biz_to_remove.reverse()
	for idx in biz_to_remove:
		owned_biz.remove_at(idx)

	# 3. Apply proceeds to eliminate debts
	var surplus: int = 0
	if remaining_liability <= 0:
		# Debt completely eliminated! Surplus refunded to player
		surplus = -remaining_liability
		player_data.set("tax_debt", 0)
		player_data.set("loan_balance", 0)
		player_data.set("debt", 0)
		player_data.set("credit_card_balance", 0)
		# Clear any remaining business debts on surviving businesses
		for b in owned_biz:
			if b is Dictionary:
				b["unpaid_taxes"] = 0
				b["loan_balance"] = 0

		if surplus > 0:
			var current_savings: int = int(player_data.get("bank_savings"))
			player_data.set("bank_savings", current_savings + surplus)

		player_data.set("debt_delinquency_years", 0)
		player_data.set("has_debt_warning", false)

		if player_data.has_method("modify_credit_score"):
			player_data.modify_credit_score(-15 if is_voluntary else -50)
	else:
		# Partial satisfaction: Reduce debts in priority order
		var debt_to_clear: int = total_recovered
		# 1. Tax debt
		var cur_tax: int = int(player_data.get("tax_debt"))
		var paid_tax: int = mini(debt_to_clear, cur_tax)
		player_data.set("tax_debt", cur_tax - paid_tax)
		debt_to_clear -= paid_tax

		# 2. Bank loan
		var cur_loan: int = int(player_data.get("loan_balance"))
		var paid_loan: int = mini(debt_to_clear, cur_loan)
		player_data.set("loan_balance", cur_loan - paid_loan)
		debt_to_clear -= paid_loan

		# 3. General debt
		var cur_debt: int = int(player_data.get("debt"))
		var paid_debt: int = mini(debt_to_clear, cur_debt)
		player_data.set("debt", cur_debt - paid_debt)
		debt_to_clear -= paid_debt

		# 4. Credit card balance
		var cur_cc: int = int(player_data.get("credit_card_balance"))
		var paid_cc: int = mini(debt_to_clear, cur_cc)
		player_data.set("credit_card_balance", cur_cc - paid_cc)
		debt_to_clear -= paid_cc

		player_data.set("debt_delinquency_years", 0)
		player_data.set("has_debt_warning", false)
		if player_data.has_method("modify_credit_score"):
			player_data.modify_credit_score(-90)

	# 4. Construct rich narrative
	var narrative: String = ""
	if seized_items.is_empty():
		# Player had no seizable collateral
		player_data.set("debt_delinquency_years", 1)
		player_data.set("has_debt_warning", true)
		if player_data.has_method("modify_credit_score"):
			player_data.modify_credit_score(-60)
		narrative = (
			"⚖️ COURT DEFAULT JUDGMENT ISSUED\n\n" +
			"You defaulted on $%s in overdue liabilities. Because you own ZERO seizable titled vehicles, properties, or commercial businesses, creditors were unable to seize physical collateral.\n\n" % _fmt(initial_total_debt) +
			"The civil court entered a default judgment on your record. Your credit score dropped by 60 points and collections remain actively enforced against your estate."
		)
	else:
		var mode_str := "Voluntary Collateral Liquidation" if is_voluntary else "Foreclosure & Sheriff's Auction"
		narrative = (
			"🏛️ COLLATERAL SEIZURE SUMMARY (%s)\n\n" % mode_str.to_upper() +
			"Collateral Liquidated to Satisfy Creditors:\n" +
			"• " + "\n• ".join(seized_items) + "\n\n" +
			"Financial Settlement Result:\n" +
			"• Initial Overdue Debt: $%s\n" % _fmt(initial_total_debt) +
			"• Total Proceeds Recovered: $%s\n" % _fmt(total_recovered)
		)
		if remaining_liability <= 0:
			narrative += "• Debt Settlement: 100% FULLY SATISFIED AND CLEARED!\n"
			if surplus > 0:
				narrative += "• Surplus Refund: $%s deposited into your bank savings account.\n" % _fmt(surplus)
			narrative += "• Credit Impact: %s (%s pts)." % [
				"Mild penalty for voluntary relief" if is_voluntary else "Foreclosure public record filed",
				"-15" if is_voluntary else "-50"
			]
		else:
			narrative += (
				"• Partial Recovery: $%s paid off.\n" % _fmt(total_recovered) +
				"• Remaining Unsatisfied Debt: $%s remains in collections.\n" % _fmt(remaining_liability) +
				"• Credit Impact: Severe bankruptcy & default rating (-90 pts)."
			)

	return {
		"success": true,
		"seized_items": seized_items,
		"initial_debt": initial_total_debt,
		"total_recovered": total_recovered,
		"surplus": surplus,
		"remaining_liability": maxi(0, remaining_liability),
		"narrative": narrative
	}


static func _fmt(num: int) -> String:
	var s := str(num)
	var res := ""
	var cnt := 0
	for i in range(s.length() - 1, -1, -1):
		res = s[i] + res
		cnt += 1
		if cnt % 3 == 0 and i > 0 and s[i - 1] != "-":
			res = "," + res
	return res
