extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

func capture_screenshot(path: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	if img != null and not img.is_empty():
		img.save_png(path)
		print("Saved %s" % path)

func _ready() -> void:
	print("=== VISUAL VERIFICATION: CHARACTER PROFILE, LIFE MILESTONES & BLIND BOX ===")

	var main_scene = MainScreenScene.instantiate()
	add_child(main_scene)
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.hide()
	if main_scene.loading_screen != null:
		main_scene.loading_screen.hide()
	if main_scene.new_game_panel != null:
		main_scene.new_game_panel.hide()
	if main_scene.action_bar != null:
		main_scene.action_bar.show()
	if main_scene.age_button != null:
		main_scene.age_button.show()

	# Set up a rich character profile
	PlayerData.reset_player()
	PlayerData.first_name = "Kaito Takahashi"
	PlayerData.gender = "MALE"
	PlayerData.birthplace = "Japan"
	PlayerData.birth_month = "October"
	PlayerData.birth_day = 8
	PlayerData.zodiac = "Libra"
	PlayerData.age = 24
	PlayerData.family_wealth = "middle_class"

	PlayerData.mother_name = "Aoi Takahashi"
	PlayerData.mother_base_age = 48
	PlayerData.mother_job = "elementary school teacher"
	PlayerData.mother_education = "Bachelor's Degree"
	PlayerData.mother_condition = "Stage 2 Lymphoma Cancer"
	PlayerData.mother_health = 45

	PlayerData.father_name = "Kenji Takahashi"
	PlayerData.father_base_age = 51
	PlayerData.father_job = "electrical engineer"
	PlayerData.father_education = "Master's Degree"
	PlayerData.father_condition = "Hypertension"
	PlayerData.father_health = 70

	PlayerData.money = 12500
	PlayerData.bank_savings = 34000
	PlayerData.karma = 85

	# Populate Life Milestones
	PlayerData.add_milestone("Born in Tokyo, Japan.", 0, "👶")
	PlayerData.add_milestone("Graduated from High School with High Honors (Grade: 94%).", 18, "🎓")
	PlayerData.add_milestone("You graduated from University of Tokyo as a summa cum laude with a GPA of 3.95.", 22, "🎓")
	PlayerData.add_milestone("Started career as Junior Software Engineer at Cyberdyne Systems.", 22, "💼")
	PlayerData.add_milestone("Promoted to Senior Software Engineer at Cyberdyne Systems.", 24, "🎖️")
	PlayerData.add_milestone("Purchased real estate: Modern Urban Apartment.", 24, "🏡")

	# 1. Capture Character Profile
	main_scene.show_tab("character")
	main_scene.update_character_panel()

	for f in range(5):
		await get_tree().process_frame

	await capture_screenshot("res://tests/verify_character_profile_milestones.png")

	# 2. Capture Clinic Blind Box Modal
	main_scene._show_doctor_modal()
	for f in range(5):
		await get_tree().process_frame

	await capture_screenshot("res://tests/verify_clinic_blind_box.png")

	print("=== VISUAL SCREENSHOTS CAPTURED SUCCESSFULLY ===")
	get_tree().quit(0)
