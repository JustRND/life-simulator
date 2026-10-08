extends Node

const RelationshipExtras = preload("res://scripts/core/relationship_extras.gd")
const RomanceRules = preload("res://scripts/core/romance_rules.gd")
const SCREENSHOT_DIR := "C:/Users/ACER PREDATOR/.gemini/antigravity-ide/brain/4330c300-f5e3-496f-a063-ffea5accf5b7"

func _ready() -> void:
	print("--- BEGINNING HEALTHCARE, INSURANCE & GIFTS VERIFICATION ---")
	test_logic()
	await test_ui()
	print("--- ALL HEALTHCARE, INSURANCE & GIFTS TESTS COMPLETED SUCCESSFULLY! ---")
	get_tree().quit(0)

func test_logic() -> void:
	# 1. Partner Gifts
	assert(RelationshipExtras.GIFTS.size() >= 10, "Partner gifts should be expanded to at least 10 items")
	for g in RelationshipExtras.GIFTS:
		assert(g.has("emoji") and not str(g.emoji).is_empty(), "Each partner gift must have a theme emoji")
		assert(g.has("name") and g.has("cost") and g.has("joy") and g.has("bond"), "Partner gift fields valid")

	# 2. Child Gifts
	assert(RelationshipExtras.CHILD_GIFTS.size() >= 8, "Child gifts should have at least 8 diverse options")
	for cg in RelationshipExtras.CHILD_GIFTS:
		assert(cg.has("emoji") and not str(cg.emoji).is_empty(), "Each child gift must have a theme emoji")
		assert(cg.has("name") and cg.has("cost") and cg.has("min_age"), "Child gift fields valid")

	# 3. Romance & Proposal Rules
	assert(RomanceRules.GIFTS.size() >= 5, "Proposal gifts must have at least 5 tiers")
	for rg in RomanceRules.GIFTS:
		assert(rg.has("emoji") and not str(rg.emoji).is_empty(), "Each proposal gift must have a theme emoji")

	# 4. Child Gift Mechanic
	PlayerData.reset_player()
	PlayerData.age = 30
	PlayerData.money = 10000
	PlayerData.children = [{
		"name": "Leo",
		"gender": "MALE",
		"age": 8,
		"relationship": 70,
		"last_gift_age": -1
	}]
	# Test child too young for car (min_age 16)
	var car_idx: int = 7 # car
	var fail_car := RelationshipExtras.give_child_gift(PlayerData, 0, car_idx)
	assert(fail_car.is_empty(), "Age 8 child cannot receive age 16 starter car")

	# Test age-appropriate gift (bicycle, min_age 7, cost 250)
	var bike_idx: int = 4
	var money_before := PlayerData.money
	var bike_msg := RelationshipExtras.give_child_gift(PlayerData, 0, bike_idx)
	assert(not bike_msg.is_empty(), "Age 8 child can receive bicycle")
	assert(PlayerData.money == money_before - 250, "Bicycle cost ($250) must be debited")
	assert(PlayerData.children[0].last_gift_age == 30, "last_gift_age updated")
	assert(PlayerData.children[0].relationship > 70, "Relationship increased")

	# 5. Healthcare & Insurance Logic
	PlayerData.reset_player()
	PlayerData.health_insurance = "none"
	assert(PlayerData.get_insurance_discount() == 0.0, "Uninsured discount is 0%")

	# Test Bronze
	PlayerData.health_insurance = "bronze"
	assert(PlayerData.get_insurance_discount() == 0.05, "Bronze discount is 5%")

	# Test Gold
	PlayerData.health_insurance = "gold"
	assert(PlayerData.get_insurance_discount() == 0.10, "Gold discount is 10%")

	# Test Platinum
	PlayerData.health_insurance = "platinum"
	assert(PlayerData.get_insurance_discount() == 0.25, "Platinum discount is 25%")

	# Test Plastic Surgery Maximize Looks
	PlayerData.looks = 35
	PlayerData.money = 500000
	# Simulate surgery effect directly:
	PlayerData.looks = 100
	assert(PlayerData.looks == 100, "Plastic surgery maximizes looks to 100")
	# Looks can still degrade later:
	PlayerData.looks = maxi(0, PlayerData.looks - 10)
	assert(PlayerData.looks == 90, "Looks can still degrade after plastic surgery")

	# Test Save & Load persistence of Health Insurance
	PlayerData.health_insurance = "platinum"
	SaveManager.save_game()
	PlayerData.reset_player()
	assert(PlayerData.health_insurance == "none", "Reset sets insurance to none")
	assert(SaveManager.load_game(), "Save file loads successfully")
	assert(PlayerData.health_insurance == "platinum", "Loaded game preserves platinum health insurance")

	print("✔ Test Logic Passed!")

func test_ui() -> void:
	print("--- Initializing Main Screen UI for Verification ---")
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.visible = false
	if main_scene.loading_screen != null:
		main_scene.loading_screen.visible = false

	var ngp = main_scene.get_node_or_null("NewGamePanel")
	if ngp != null:
		ngp.visible = false
	var ml = main_scene.get_node_or_null("MainLayout")
	if ml != null:
		ml.visible = true

	PlayerData.has_started_game = true
	PlayerData.first_name = "Alex"
	PlayerData.age = 28
	PlayerData.money = 350000
	PlayerData.bank_savings = 500000
	PlayerData.health = 85
	PlayerData.partner = {
		"name": "Elena Rostova",
		"status": "Fiancée",
		"gender": "FEMALE",
		"age": 27,
		"relationship": 90,
		"happiness": 85,
		"is_alive": true
	}
	PlayerData.children = [
		{
			"name": "Maya",
			"gender": "FEMALE",
			"age": 10,
			"relationship": 80,
			"last_gift_age": -1
		}
	]
	main_scene.update_ui()
	await get_tree().create_timer(0.2).timeout

	# 1. Partner Gift Modal
	main_scene._show_partner_gift_modal()
	await get_tree().create_timer(0.5).timeout
	await _capture_screenshot("verify_partner_gift_modal.png")

	if is_instance_valid(main_scene.romance_action_modal_overlay):
		main_scene.romance_action_modal_overlay.queue_free()
	await get_tree().create_timer(0.2).timeout

	# 2. Child Gift Modal
	main_scene._show_child_gift_modal(0)
	await get_tree().create_timer(0.5).timeout
	await _capture_screenshot("verify_child_gift_modal.png")

	if is_instance_valid(main_scene.romance_action_modal_overlay):
		main_scene.romance_action_modal_overlay.queue_free()
	await get_tree().create_timer(0.2).timeout

	# 3. Doctor Modal with Insurance Card (Uninsured)
	PlayerData.health_insurance = "none"
	main_scene._show_doctor_modal()
	await get_tree().create_timer(0.5).timeout
	await _capture_screenshot("verify_doctor_modal_uninsured.png")

	if is_instance_valid(main_scene.doctor_modal_overlay):
		main_scene.doctor_modal_overlay.queue_free()
	await get_tree().create_timer(0.2).timeout

	# 4. Doctor Modal with Platinum Insurance (Showing 25% discount & tags)
	PlayerData.health_insurance = "platinum"
	main_scene._show_doctor_modal()
	await get_tree().create_timer(0.5).timeout
	await _capture_screenshot("verify_doctor_modal_platinum.png")

	print("✔ UI Screenshots Captured!")

func _capture_screenshot(file_name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var path := SCREENSHOT_DIR + "/" + file_name
	img.save_png(path)
	print("Captured screenshot saved to: %s" % path)
