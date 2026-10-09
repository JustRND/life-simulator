extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://banking_rework_test_profile.json"
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.money = 5000
	PlayerData.bank_savings = 0
	PlayerData.loan_balance = 0
	PlayerData.tax_debt = 80
	PlayerData.debt = 50
	assert(PlayerData.take_bank_loan(1000, 0.05))
	assert(PlayerData.money == 6000)
	assert(not PlayerData.take_bank_loan(5000, 0.07))
	assert(PlayerData.money == 6000 and PlayerData.loan_balance == 1000)
	assert(is_equal_approx(PlayerData.loan_interest_rate, 0.05))
	assert(PlayerData.repay_bank_loan(-20) == 0)
	assert(PlayerData.repay_bank_loan(300) == 300)
	assert(PlayerData.loan_balance == 700 and PlayerData.money == 5700)
	assert(PlayerData.tax_debt == 80 and PlayerData.debt == 50)
	assert(not PlayerData.take_bank_loan(1000, 0.05))
	main.show_tab("bank")
	await get_tree().create_timer(0.5).timeout
	var borrow_count := 0
	for button in main.bank_panel.find_children("*", "Button", true, false):
		if button.text.begins_with("Borrow $"):
			assert(button.disabled)
			borrow_count += 1
	assert(borrow_count == 6)
	main._show_loan_repayment()
	await get_tree().create_timer(0.5).timeout
	var field = main.find_child("LoanRepaymentAmount", true, false)
	assert(field != null and field.virtual_keyboard_enabled)
	assert(field.virtual_keyboard_type == LineEdit.KEYBOARD_TYPE_NUMBER)
	assert(field.has_meta("mobile_kb_attached"))
	field.text = "250"
	field.text_changed.emit(field.text)
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://work/banking-repayment.png")
	else:
		await get_tree().create_timer(0.1).timeout
	for invalid in ["", "0", "-1", "1.5", "1e3", "$100", "99999999999999999"]:
		assert(main._parse_loan_payment(invalid) == 0)
	assert(main._parse_loan_payment(" 250 ") == 250)
	assert(PlayerData.repay_bank_loan(9999) == 700)
	assert(PlayerData.loan_balance == 0)
	assert(PlayerData.take_bank_loan(5000, 0.07))
	assert(PlayerData.loan_balance == 5000)
	PlayerData.money = 20
	assert(PlayerData.repay_bank_loan(100) == 20)
	assert(PlayerData.money == 0 and PlayerData.loan_balance == 4980)
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("BANKING_REWORK_TEST: PASS — loan lock, partial/full payments, validation and keyboard setup")
	get_tree().quit()
