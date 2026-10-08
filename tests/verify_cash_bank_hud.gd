extends Node

func _ready() -> void:
	print("--- VERIFYING CASH & BANK BALANCE HUD & INHERITANCE ---")
	SaveManager.delete_save()
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)

	PlayerData.first_name = "Marcus Vance"
	PlayerData.age = 28
	PlayerData.money = 12500 # $12,500 Cash
	PlayerData.bank_savings = 84000 # $84,000 Bank Balance
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.visible = false
	if main_scene.loading_screen != null:
		main_scene.loading_screen.visible = false
	main_scene.update_ui()

	var balance_lbl: Label = main_scene.get_node_or_null("ProfileStrip/ProfileMargin/ProfileRow/BalanceLabel")
	assert(balance_lbl != null, "BalanceLabel must exist")
	print("BalanceLabel Text before inheritance:\n", balance_lbl.text)

	assert(balance_lbl.text.contains("💵 $12,500 CASH"), "Must show Cash")
	assert(balance_lbl.text.contains("🏦 $84,000 BANK"), "Must show Bank Balance")

	await get_tree().process_frame
	await get_tree().process_frame

	var img = get_viewport().get_texture().get_image()
	img.save_png("C:/Users/ACER PREDATOR/.gemini/antigravity-ide/brain/4330c300-f5e3-496f-a063-ffea5accf5b7/verify_cash_and_bank_hud.png")
	print("Saved initial HUD screenshot.")

	# Test Inheritance Takeover
	var heir := {
		"name": "Valerie Vance",
		"gender": "FEMALE",
		"age": 19,
		"ethnicity": "white",
		"portrait_track": 0,
		"portrait_variant": 2,
		"health": 92,
		"happiness": 88,
		"smarts": 85,
		"looks": 80
	}
	# Liquid estate = $12,500 (cash) + $84,000 (bank) = $96,500
	var liquid_total: int = PlayerData.money + PlayerData.bank_savings
	PlayerData.takeover_as_child(heir, liquid_total, PlayerData.owned_assets)

	assert(PlayerData.money == 0, "Inherited money must NOT be straight cash! Cash must be 0.")
	assert(PlayerData.bank_savings == 96500, "Cash must be converted into Bank Balance upon inheritance! Bank Savings must be 96500.")

	main_scene.update_ui()
	if main_scene.new_game_panel != null:
		main_scene.new_game_panel.visible = false
	print("BalanceLabel Text after inheritance:\n", balance_lbl.text)
	assert(balance_lbl.text.contains("💵 $0 CASH"), "Must show $0 CASH for heir")
	assert(balance_lbl.text.contains("🏦 $96,500 BANK"), "Must show $96,500 BANK BALANCE for heir")

	await get_tree().process_frame
	await get_tree().process_frame

	var img2 = get_viewport().get_texture().get_image()
	img2.save_png("C:/Users/ACER PREDATOR/.gemini/antigravity-ide/brain/4330c300-f5e3-496f-a063-ffea5accf5b7/verify_inheritance_bank_hud.png")
	print("Saved inheritance HUD screenshot.")

	print("✔ CASH AND BANK BALANCE HUD & INHERITANCE FULLY VERIFIED!")
	get_tree().quit(0)
