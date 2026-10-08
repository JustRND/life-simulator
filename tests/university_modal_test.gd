extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

func _ready() -> void:
	print("--- BEGIN UNIVERSITY MODAL & STUDY PATHS NESTING VERIFICATION ---")
	test_dedicated_button_in_education_modal()
	test_university_modal_enrollment_category()
	test_university_modal_study_paths_category()
	test_theme_contrast_in_university_modal()
	print("--- ALL UNIVERSITY MODAL & STUDY PATHS TESTS PASSED SUCCESSFULLY! ---")
	get_tree().quit(0)


func get_all_descendants(node: Node) -> Array[Node]:
	var result: Array[Node] = []
	for child in node.get_children():
		result.append(child)
		result.append_array(get_all_descendants(child))
	return result


func test_dedicated_button_in_education_modal() -> void:
	print("Testing Dedicated Button in Education Modal...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	# Configure test state after add_child so SaveManager.load_game() does not overwrite it
	PlayerData.reset()
	PlayerData.age = 18
	PlayerData.education_level = "High School Graduate"
	PlayerData.grades = 85
	PlayerData.smarts = 75
	PlayerData.money = 50000
	PlayerData.university_name = ""
	PlayerData.university_major = ""
	PlayerData.university_major_title = ""
	PlayerData.university_degree = ""
	PlayerData.university_tuition = 0
	PlayerData.university_years = 0
	PlayerData.degrees = []

	screen.update_ui()
	screen._show_education_modal()

	assert(screen.education_modal_overlay != null, "Education modal overlay must be instantiated")
	
	var all_nodes := get_all_descendants(screen.education_modal_overlay)
	var dedicated_btn: Button = null
	var found_inline_uni_cards: int = 0

	for node in all_nodes:
		if node is Button and "University Enrollment & Study Paths" in node.text:
			dedicated_btn = node
		if node is Label:
			if "University of Pixel State" in node.text or "University of Central Pixnology" in node.text:
				found_inline_uni_cards += 1

	assert(dedicated_btn != null, "Education modal MUST contain a dedicated 'University Enrollment & Study Paths' button")
	assert(found_inline_uni_cards == 0, "Individual university cards must NOT be inlined directly in education modal (found %d)" % found_inline_uni_cards)
	print("✔ Verified dedicated 'University Enrollment & Study Paths' button is present and inline cards are nested away.")
	screen.queue_free()


func test_university_modal_enrollment_category() -> void:
	print("Testing University Modal - Enrollment List Category...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 18
	PlayerData.education_level = "High School Graduate"
	PlayerData.grades = 85
	PlayerData.smarts = 75
	PlayerData.money = 50000
	PlayerData.university_name = ""
	PlayerData.university_major = ""
	PlayerData.university_major_title = ""
	PlayerData.university_degree = ""
	PlayerData.university_tuition = 0
	PlayerData.university_years = 0
	PlayerData.degrees = []

	screen.update_ui()
	screen._show_university_modal("enrollment")

	assert(screen.university_modal_overlay != null, "University modal overlay must be created")
	assert(screen.university_modal_overlay.visible == true, "University modal overlay must be visible")

	var all_nodes := get_all_descendants(screen.university_modal_overlay)

	# Find category tab buttons
	var tab_enroll_found: bool = false
	var tab_paths_found: bool = false
	var uni_labels := 0
	var enroll_btn: Button = null

	for node in all_nodes:
		if node is Button:
			if "Enrollment List" in node.text:
				tab_enroll_found = true
			if "Study Paths" in node.text:
				tab_paths_found = true
			if "Enroll in Business Management" in node.text:
				enroll_btn = node
		if node is Label:
			if "University of Pixel State" in node.text or "Pixel Polytechnic Institute" in node.text or "Metropolitan Medical University" in node.text:
				uni_labels += 1

	assert(tab_enroll_found, "University modal must contain 'Enrollment List' tab button")
	assert(tab_paths_found, "University modal must contain 'Study Paths' tab button")
	assert(uni_labels >= 3, "Enrollment tab must list accredited institutions (found %d)" % uni_labels)
	print("✔ Verified Enrollment List category displays accredited institutions and category tabs.")

	# Test enrollment action
	assert(enroll_btn != null, "Enroll button for Business Management must exist")
	enroll_btn.pressed.emit()

	assert(PlayerData.education_level == "University Student", "Player must be enrolled as University Student")
	assert(PlayerData.university_major == "business", "Player major must be business")
	print("✔ Verified successful enrollment via university modal.")
	screen.queue_free()


func test_university_modal_study_paths_category() -> void:
	print("Testing University Modal - Study Paths Category...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 22
	PlayerData.education_level = "University Graduate"
	PlayerData.grades = 90
	PlayerData.smarts = 80
	PlayerData.degrees = [
		{
			"university": "University of Pixel State",
			"major": "business",
			"major_title": "Business Management",
			"degree": "Bachelor of Business Administration (B.B.A.)",
			"grades": 90,
			"year_graduated": 22
		}
	]

	screen.update_ui()
	screen._show_university_modal("study_paths")

	assert(screen.university_modal_overlay != null, "University modal overlay must be created")

	var all_nodes := get_all_descendants(screen.university_modal_overlay)
	var degrees_honors_found: bool = false
	var career_trajectories_found: bool = false
	var conferred_btn_found: bool = false

	for node in all_nodes:
		if node is Label:
			if "CONFERRED DEGREES & ALUMNUS HONORS" in node.text:
				degrees_honors_found = true
			if "Career Trajectory (Job Market Unlocks)" in node.text:
				career_trajectories_found = true
		if node is Button:
			if "Degree Conferred" in node.text:
				conferred_btn_found = true

	assert(degrees_honors_found, "Study Paths tab must display Conferred Degrees honors summary card")
	assert(career_trajectories_found, "Study Paths tab must display Career Trajectory unlocks")
	assert(conferred_btn_found, "Completed study path must display 'Degree Conferred' action button")
	print("✔ Verified Study Paths category displays conferred degrees and career trajectories.")
	screen.queue_free()


func test_theme_contrast_in_university_modal() -> void:
	print("Testing Theme Contrast in University Modal (Light Mode & Dark Mode)...")
	for th in ["light", "dark"]:
		var screen = MainScreenScene.instantiate()
		add_child(screen)
		LifeLibrary.data.theme = th
		if screen.has_node("ThemeController"):
			screen.get_node("ThemeController").apply_theme()
		screen.update_ui()
		screen._show_university_modal("enrollment")

		assert(screen.university_modal_overlay != null, "Modal overlay must exist in %s mode" % th)
		var all_nodes := get_all_descendants(screen.university_modal_overlay)
		for node in all_nodes:
			if node is Label and "UNIVERSITY & STUDY PATHS" in node.text:
				var has_override: bool = node.has_theme_color_override("font_color")
				var col: Color = node.get_theme_color("font_color")
				print("Modal title in %s: has_override=%s, col=%s, lum=%f" % [th, has_override, col, col.get_luminance()])
				if th == "light":
					assert(col.get_luminance() <= 0.45 or has_override, "Modal title must be dark in light mode")
				else:
					assert(col.get_luminance() >= 0.35, "Modal title must be bright in dark mode")
				break

		screen.queue_free()

	print("✔ Verified high contrast styling in both Light and Dark themes.")
