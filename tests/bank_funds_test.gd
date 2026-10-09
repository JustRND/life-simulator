extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://bank_funds_test_profile.json"
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.money = 200
	PlayerData.bank_savings = 500
	assert(PlayerData.deposit_cash(120) == 120)
	assert(PlayerData.money == 80 and PlayerData.bank_savings == 620)
	assert(PlayerData.withdraw_cash(220) == 220)
	assert(PlayerData.money == 300 and PlayerData.bank_savings == 400)
	assert(PlayerData.deposit_cash(-10) == 0)
	assert(PlayerData.withdraw_cash(-10) == 0)
	assert(PlayerData.get_available_funds() == 700)
	PlayerData.receive_salary(1000)
	assert(PlayerData.money == 300 and PlayerData.bank_savings == 1400)
	assert(PlayerData.debit_funds(400))
	assert(PlayerData.money == 0 and PlayerData.bank_savings == 1300)
	assert(not PlayerData.debit_funds(1301))
	assert(not PlayerData.debit_funds(-10))
	assert(PlayerData.bank_savings == 1300)
	PlayerData.loan_balance = 500
	assert(PlayerData.repay_bank_loan(250) == 250)
	assert(PlayerData.bank_savings == 1050 and PlayerData.loan_balance == 250)
	PlayerData.tax_debt = 80
	assert(PlayerData.pay_outstanding_tax() == 80)
	assert(PlayerData.bank_savings == 970 and PlayerData.money == 0)
	PlayerData.age = 30
	PlayerData.is_dead = false
	PlayerData.is_in_prison = false
	PlayerData.learning_activities = {}
	BalanceRules.learn(PlayerData, "chess")
	assert(PlayerData.bank_savings == 940 and PlayerData.money == 0)
	var company := {"name": "Test Business", "treasury": 0, "loan_balance": 100, "unpaid_taxes": 40}
	BusinessManager.repay_business_loan(company, 60)
	assert(company.loan_balance == 40 and PlayerData.bank_savings == 880)
	BusinessManager.pay_business_taxes(company)
	assert(company.unpaid_taxes == 0 and PlayerData.bank_savings == 840)
	for deposit in [true, false]:
		main._show_bank_transfer(deposit)
		await get_tree().create_timer(0.4).timeout
		var field = main.find_child("BankTransferAmount", true, false)
		assert(field != null and field.virtual_keyboard_enabled)
		assert(field.virtual_keyboard_type == LineEdit.KEYBOARD_TYPE_NUMBER)
		assert(field.has_meta("mobile_kb_attached"))
		var overlay = field
		while overlay.get_parent() != main:
			overlay = overlay.get_parent()
		overlay.queue_free()
		await get_tree().process_frame
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("BANK_FUNDS_TEST: PASS — transfers, salary, cash/bank spending, debt, tax, activities, mobile input")
	get_tree().quit()
