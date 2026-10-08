extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

func _ready() -> void:
	print("--- BEGIN LIGHT MODE CONTRAST VERIFICATION ---")
	test_light_mode_activities_contrast()
	test_light_mode_assets_contrast()
	test_light_mode_infant_contrast()
	test_light_mode_event_contrast()
	test_light_mode_modal_contrast()
	test_theme_toggle_reversibility()
	print("--- ALL LIGHT MODE CONTRAST TESTS PASSED SUCCESSFULLY! ---")
	get_tree().quit(0)

func test_light_mode_activities_contrast() -> void:
	print("Testing Light Mode Activities Panel Contrast...")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	screen.update_ui()
	screen.show_tab("activities")

	var act_list: VBoxContainer = screen.get_node_or_null("ActivitiesPanel/ActMargin/ActContent/ActScroll/ActList")
	assert(act_list != null, "ActList must exist")

	var button_count := 0
	for child in act_list.get_children():
		if child is Button:
			button_count += 1
			var font_col: Color = child.get_theme_color("font_color")
			assert(font_col.get_luminance() <= 0.25, "Button '%s' font_color must have luminance <= 0.25 in Light Mode (got %f, color: %s)" % [child.text, font_col.get_luminance(), font_col.to_html()])
	
	assert(button_count >= 10, "Expected at least 10 activity buttons, found %d" % button_count)
	print("✔ Verified %d activity buttons have high-contrast text in Light Mode." % button_count)
	screen.queue_free()

func test_light_mode_assets_contrast() -> void:
	print("Testing Light Mode Assets Panel Contrast...")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	PlayerData.age = 25
	screen.update_ui()
	screen.show_tab("assets")

	var assets_list: VBoxContainer = screen.get_node_or_null("AssetsPanel/AssetsMargin/AssetsContent/AssetsScroll/AssetsList")
	assert(assets_list != null, "AssetsList must exist")

	var label_count := 0
	for node in assets_list.find_children("*", "Label", true, false):
		var lbl := node as Label
		if not lbl.visible or lbl.text.strip_edges() == "":
			continue
		var col: Color = lbl.get_theme_color("font_color")
		label_count += 1
		assert(col.get_luminance() <= 0.45, "Assets Label '%s' font_color must have high contrast in Light Mode (lum %f, col: %s)" % [lbl.text.left(30), col.get_luminance(), col.to_html()])

	print("✔ Verified %d assets labels have high-contrast text in Light Mode." % label_count)
	screen.queue_free()

func test_light_mode_infant_contrast() -> void:
	print("Testing Light Mode Infant/Overview Panel Contrast...")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	PlayerData.age = 16
	PlayerData.grades = 85
	PlayerData.job_title = "Apprentice"
	PlayerData.job_company = "Tech Corp"
	PlayerData.job_salary = 25000
	screen.update_ui()
	screen.show_tab("infant")

	var job_lbl: Label = screen.current_job_label
	if job_lbl != null:
		var col: Color = job_lbl.get_theme_color("font_color")
		assert(col.get_luminance() <= 0.45, "Job label must be high contrast (got lum %f, col %s)" % [col.get_luminance(), col.to_html()])

	var grades_lbl: Label = screen.grades_label
	if grades_lbl != null:
		var col: Color = grades_lbl.get_theme_color("font_color")
		assert(col.get_luminance() <= 0.45, "Grades label must be high contrast (got lum %f, col %s)" % [col.get_luminance(), col.to_html()])

	print("✔ Verified Infant/Overview labels have high-contrast text in Light Mode.")
	screen.queue_free()

func test_light_mode_event_contrast() -> void:
	print("Testing Light Mode Event Popup Contrast...")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	screen.update_ui()

	screen.current_event = {
		"id": "test_event",
		"title": "A Turning Point",
		"description": "You encounter a major opportunity in life."
	}
	screen.current_event_choices = [{"text": "Accept Offer"}, {"text": "Decline Offer"}]
	screen.show_event_popup()

	var title_lbl: Label = screen.event_title
	assert(title_lbl != null, "event_title must exist")
	assert(title_lbl.get_theme_color("font_color").get_luminance() <= 0.45, "event_title must be high contrast in Light Mode")

	var desc_lbl: RichTextLabel = screen.event_description
	assert(desc_lbl != null, "event_description must exist")
	assert(desc_lbl.get_theme_color("default_color").get_luminance() <= 0.35, "event_description must be high contrast in Light Mode")

	for btn in [screen.event_choice_1, screen.event_choice_2, screen.event_choice_3, screen.event_choice_4]:
		if btn != null and btn.visible:
			assert(btn.get_theme_color("font_color").get_luminance() <= 0.25, "Event choice button must be high contrast in Light Mode")

	screen.hide_event_popup()
	print("✔ Verified Event Popup text has high-contrast in Light Mode.")
	screen.queue_free()

func test_light_mode_modal_contrast() -> void:
	print("Testing Light Mode Cyber Modal Contrast...")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	var modal: Dictionary = screen._create_cyber_modal("CYBER MODAL TITLE", "Cyber Subtitle Explanation", Color("#06b6d4"))
	var title_lbl: Label = modal["title"]
	var sub_lbl: Label = modal["subtitle"]
	assert(title_lbl.get_theme_color("font_color").get_luminance() <= 0.45, "Modal title must be high contrast in Light Mode")
	assert(sub_lbl.get_theme_color("font_color").get_luminance() <= 0.45, "Modal subtitle must be high contrast in Light Mode")

	var buttons: Array = modal["overlay"].find_children("*", "Button", true, false)
	assert(buttons.size() > 0, "Close button must be found")
	for b in buttons:
		var btn := b as Button
		assert(btn.get_theme_color("font_color").get_luminance() <= 0.25, "Close button font must be high-contrast in Light Mode")

	var cyber_btn: Button = screen._create_cyber_button("Action Option", Color("#06b6d4"))
	modal["list"].add_child(cyber_btn)
	assert(cyber_btn.get_theme_color("font_color").get_luminance() <= 0.25, "Cyber button must have high-contrast font in Light Mode")

	var disabled_btn: Button = screen._create_disabled_cyber_button("Locked Option", "Level 10 required")
	modal["list"].add_child(disabled_btn)
	assert(disabled_btn.get_theme_color("font_color").get_luminance() <= 0.35, "Disabled cyber button must have legible font in Light Mode")

	modal["overlay"].queue_free()
	print("✔ Verified Cyber Modal components have high-contrast in Light Mode.")
	screen.queue_free()

func test_theme_toggle_reversibility() -> void:
	print("Testing Theme Switch Reversibility (Dark -> Light -> Dark)...")
	LifeLibrary.data.theme = "dark"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	screen.update_ui()
	screen.show_tab("activities")

	var act_list: VBoxContainer = screen.get_node("ActivitiesPanel/ActMargin/ActContent/ActScroll/ActList")
	var first_btn: Button = null
	for child in act_list.get_children():
		if child is Button:
			first_btn = child
			break
	assert(first_btn != null, "Must find first activity button")

	# Check dark font color
	var dark_col: Color = first_btn.get_theme_color("font_color")
	assert(dark_col.get_luminance() >= 0.70, "Dark mode button must have bright font (lum %f)" % dark_col.get_luminance())

	# Switch to Light
	LifeLibrary.data.theme = "light"
	screen.get_node("ThemeController").apply_theme()
	screen.update_ui()
	screen.show_tab("activities")
	var light_col: Color = first_btn.get_theme_color("font_color")
	assert(light_col.get_luminance() <= 0.25, "Light mode button must have dark font (lum %f)" % light_col.get_luminance())

	# Switch back to Dark
	LifeLibrary.data.theme = "dark"
	screen.get_node("ThemeController").apply_theme()
	screen.update_ui()
	screen.show_tab("activities")
	var restored_col: Color = first_btn.get_theme_color("font_color")
	assert(restored_col.get_luminance() >= 0.70, "Restored dark mode button must have bright font (lum %f)" % restored_col.get_luminance())

	print("✔ Verified Theme switching is fully reversible and preserves dark originals.")
	screen.queue_free()
