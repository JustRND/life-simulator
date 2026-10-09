extends Node

const CollateralManagerScript = preload("res://scripts/economy/collateral_manager.gd")

func _ready() -> void:
	print("=== RUNNING COLLATERAL & BUSINESS MODAL REFRESH TESTS ===")
	test_collateral_calculations()
	test_delinquency_lifecycle()
	test_voluntary_collateral_surrender()
	test_forced_collateral_seizure()
	test_save_load_persistence()
	await test_business_modal_in_place_refresh()
	print("=== ALL COLLATERAL & BUSINESS REFRESH TESTS PASSED 100% ===")
	get_tree().quit(0)


func test_collateral_calculations() -> void:
	print("Testing collateral debt and asset appraisal calculations...")
	PlayerData.reset_player()
	PlayerData.age = 25
	PlayerData.money = 5000
	PlayerData.tax_debt = 2000
	PlayerData.loan_balance = 8000
	PlayerData.debt = 1500
	PlayerData.credit_card_balance = 500

	PlayerData.owned_assets = [
		{"name": "Sports Sedan", "category": "vehicles", "current_value": 15000, "purchase_price": 20000},
		{"name": "Downtown Condo", "category": "properties", "current_value": 120000, "purchase_price": 100000}
	]
	PlayerData.owned_businesses = [
		{
			"uid": "biz_101",
			"name": "Apex Logistics Inc",
			"valuation": 50000,
			"treasury": 10000,
			"loan_balance": 5000,
			"unpaid_taxes": 1200,
			"owner_fraction": 1.0
		}
	]

	var debt_info: Dictionary = CollateralManagerScript.get_debt_breakdown(PlayerData)
	assert(debt_info["tax_debt"] == 2000, "Tax debt match")
	assert(debt_info["loan_balance"] == 8000, "Loan balance match")
	assert(debt_info["debt"] == 1500, "General debt match")
	assert(debt_info["credit_card_balance"] == 500, "CC balance match")
	assert(debt_info["business_loans"] == 5000, "Biz loan match")
	assert(debt_info["business_unpaid_taxes"] == 1200, "Biz taxes match")
	assert(debt_info["total_personal_debt"] == 12000, "Total personal debt = 12000")
	assert(debt_info["total_business_debt"] == 6200, "Total biz debt = 6200")
	assert(debt_info["total_debt"] == 18200, "Total liabilities = 18200")

	var col_info: Dictionary = CollateralManagerScript.get_collateral_breakdown(PlayerData)
	assert(col_info["total_asset_value"] == 135000, "Total asset value = 135000")
	assert(col_info["total_seizable_items"] == 3, "2 assets + 1 biz = 3 items")
	print("✓ Collateral calculations passed!")


func test_delinquency_lifecycle() -> void:
	print("Testing delinquency lifecycle and warning event panel...")
	PlayerData.reset_player()
	PlayerData.age = 22
	PlayerData.loan_balance = 10000
	PlayerData.debt_delinquency_years = 0
	PlayerData.has_debt_warning = false

	# Year 1
	CollateralManagerScript.process_yearly_delinquency(PlayerData)
	assert(PlayerData.debt_delinquency_years == 1, "Delinquency year 1")
	var ev1: Dictionary = CollateralManagerScript.check_and_trigger_event(PlayerData, null)
	assert(ev1.is_empty(), "No event in year 1")

	# Year 2
	CollateralManagerScript.process_yearly_delinquency(PlayerData)
	assert(PlayerData.debt_delinquency_years == 2, "Delinquency year 2")
	var ev2: Dictionary = CollateralManagerScript.check_and_trigger_event(PlayerData, null)
	assert(not ev2.is_empty(), "Warning event triggered in year 2")
	assert(ev2["id"] == "event_debt_collateral_warning", "Warning event ID match")
	assert(ev2["choices"].size() >= 3, "Warning event has multiple actionable choices")

	# Test Forbearance choice
	var forbearance_choice: Dictionary = {}
	for c in ev2["choices"]:
		if "Forbearance" in str(c.get("text", "")):
			forbearance_choice = c
			break
	assert(not forbearance_choice.is_empty(), "Forbearance choice found")
	var old_credit: int = PlayerData.credit_score
	var cb_res: String = forbearance_choice["callback"].call()
	assert(PlayerData.has_debt_warning == true, "Warning flag active after forbearance")
	assert(PlayerData.credit_score == old_credit - 40, "Credit score docked 40 pts")
	assert("HARDSHIP FORBEARANCE GRANTED" in cb_res, "Forbearance callback text confirmed")
	print("✓ Delinquency lifecycle & warning panel verified!")


func test_voluntary_collateral_surrender() -> void:
	print("Testing voluntary collateral surrender to eliminate debt...")
	PlayerData.reset_player()
	PlayerData.age = 30
	PlayerData.tax_debt = 5000
	PlayerData.debt_delinquency_years = 2
	PlayerData.has_debt_warning = true
	PlayerData.bank_savings = 0
	PlayerData.owned_assets = [
		{"name": "Vintage Motorcycle", "category": "vehicles", "current_value": 8000, "purchase_price": 8000}
	]

	var res: Dictionary = CollateralManagerScript.execute_seizure(PlayerData, true) # voluntary
	assert(res["success"] == true, "Voluntary liquidation success")
	assert(PlayerData.tax_debt == 0, "Debt fully cleared")
	assert(PlayerData.owned_assets.is_empty(), "Asset surrendered")
	assert(PlayerData.bank_savings == 3000, "Surplus $3,000 refunded to bank savings")
	assert(PlayerData.debt_delinquency_years == 0, "Delinquency reset to 0")
	assert(PlayerData.has_debt_warning == false, "Warning reset")
	print("✓ Voluntary collateral surrender passed!")


func test_forced_collateral_seizure() -> void:
	print("Testing forced hostile bank collateral seizure...")
	PlayerData.reset_player()
	PlayerData.age = 35
	PlayerData.loan_balance = 20000
	PlayerData.debt_delinquency_years = 3
	PlayerData.has_debt_warning = true
	PlayerData.owned_assets = [
		{"name": "Luxury Yacht", "category": "vehicles", "current_value": 30000, "purchase_price": 40000}
	]

	var ev: Dictionary = CollateralManagerScript.check_and_trigger_event(PlayerData, null)
	assert(not ev.is_empty(), "Seizure event triggered")
	assert(ev["id"] == "event_debt_collateral_seizure", "Seizure event ID match")
	assert(PlayerData.loan_balance == 0, "Loan balance cleared by seized yacht auction")
	assert(PlayerData.owned_assets.is_empty(), "Yacht seized")
	assert(PlayerData.debt_delinquency_years == 0, "Delinquency cleared after foreclosure")
	print("✓ Forced collateral seizure passed!")


func test_save_load_persistence() -> void:
	print("Testing SaveManager persistence for delinquency fields...")
	PlayerData.reset_player()
	PlayerData.debt_delinquency_years = 2
	PlayerData.has_debt_warning = true

	var captured := SaveManager.capture_data()
	assert(captured["debt_delinquency_years"] == 2, "Delinquency years captured")
	assert(captured["has_debt_warning"] == true, "Warning captured")

	PlayerData.debt_delinquency_years = 0
	PlayerData.has_debt_warning = false
	SaveManager.apply_data(captured)
	assert(PlayerData.debt_delinquency_years == 2, "Delinquency restored")
	assert(PlayerData.has_debt_warning == true, "Warning restored")
	print("✓ SaveManager persistence verified!")


func test_business_modal_in_place_refresh() -> void:
	print("Testing business modal in-place refresh (zero blinking / zero overlay recreations)...")
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	await get_tree().process_frame

	PlayerData.reset_player()
	PlayerData.age = 28
	PlayerData.money = 50000
	PlayerData.owned_businesses = [
		{
			"uid": "test_biz_1",
			"name": "CyberTech Solutions",
			"valuation": 150000,
			"treasury": 40000,
			"loan_balance": 10000,
			"unpaid_taxes": 2000,
			"employees": 5,
			"quality": 75,
			"product_strategy": "standard"
		}
	]

	# First open creates the modal
	main_scene._show_business_modal("enterprises")
	var original_overlay: Control = main_scene.business_modal_overlay
	assert(original_overlay != null and is_instance_valid(original_overlay), "Business modal overlay created")
	var original_id: int = original_overlay.get_instance_id()
	var original_tab_bar: HBoxContainer = main_scene.business_modal_tab_bar
	assert(original_tab_bar != null and is_instance_valid(original_tab_bar), "Tab bar created")

	# Switching tabs must NOT recreate or destroy overlay (ZERO BLINKING!)
	main_scene._show_business_modal("financials", "test_biz_1")
	assert(is_instance_valid(original_overlay), "Overlay must stay valid")
	assert(main_scene.business_modal_overlay.get_instance_id() == original_id, "Overlay instance ID must be identical (no re-creation)")

	# Calling financial action (e.g. repayment refresh) must NOT recreate or destroy overlay
	main_scene._show_business_modal("financials", "test_biz_1")
	assert(main_scene.business_modal_overlay.get_instance_id() == original_id, "Overlay instance ID still identical after financial action")

	# Switching to incorporate tab must NOT recreate overlay
	main_scene._show_business_modal("incorporate")
	assert(main_scene.business_modal_overlay.get_instance_id() == original_id, "Overlay instance ID still identical on incorporate tab")

	main_scene.queue_free()
	print("✓ Business modal in-place refresh verified: 0 re-creations, 0 blinking!")
