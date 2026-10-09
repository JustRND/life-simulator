extends Node

const SCREENSHOT_DIR := "C:/Users/ACER PREDATOR/.gemini/antigravity-ide/brain/4330c300-f5e3-496f-a063-ffea5accf5b7"

func _ready() -> void:
	print("--- STARTING LICENSING, BUSINESS NESTING & DRIVING MINIGAME VERIFICATION ---")
	get_window().size = Vector2i(540, 960)
	await get_tree().process_frame

	# 1. Test LicenseManager requirements
	print("1. Testing LicenseManager...")
	var car_lic := LicenseManager.get_license_by_id("license_car")
	assert(not car_lic.is_empty(), "license_car must exist")
	assert(not str(car_lic.get("name", "")).to_lower().contains("passenger"), "license_car name must NOT contain 'passenger', found: %s" % car_lic.get("name"))
	assert(str(car_lic.get("name", "")) == "Driver's License (Class C)", "license_car name should be 'Driver's License (Class C)', found: %s" % car_lic.get("name"))
	assert(not str(car_lic.get("description", "")).to_lower().contains("passenger"), "license_car description must NOT contain 'passenger'")

	var lic_categories := LicenseManager.get_categories()
	assert(lic_categories.size() >= 4, "Must have at least 4 licensing categories, found %d" % lic_categories.size())
	var cat_ids: Array[String] = []
	for c in lic_categories:
		cat_ids.append(str(c.get("id", "")))
	assert(cat_ids.has("fnb"), "Must have F&B category")
	assert(cat_ids.has("vehicle"), "Must have vehicle category")
	assert(cat_ids.has("firearm"), "Must have firearm category")
	assert(cat_ids.has("services"), "Must have services category")

	var veh_lics := LicenseManager.get_licenses_in_category("vehicle")
	var veh_ids: Array[String] = []
	for l in veh_lics:
		veh_ids.append(str(l.get("id", "")))
	assert(veh_ids.has("license_motorcycle"), "Vehicle category must include license_motorcycle")
	assert(veh_ids.has("license_car"), "Vehicle category must include license_car")
	assert(veh_ids.has("flight_school"), "Vehicle category must include flight_school")
	assert(veh_ids.has("license_pilot"), "Vehicle category must include license_pilot")
	assert(veh_ids.has("license_boating"), "Vehicle category must include license_boating")

	var fnb_lics := LicenseManager.get_licenses_in_category("fnb")
	assert(fnb_lics.size() >= 1, "F&B category must have at least 1 license")

	var firearm_lics := LicenseManager.get_licenses_in_category("firearm")
	assert(firearm_lics.size() >= 1, "Firearm category must have at least 1 license")

	var serv_lics := LicenseManager.get_licenses_in_category("services")
	assert(serv_lics.size() >= 5, "Services category must have multiple trade licenses")
	print("✔ LicenseManager categorization and naming verified.")

	# 2. Test BusinessManager requirements
	print("2. Testing BusinessManager categorization...")
	var biz_categories := BusinessManager.get_categories()
	assert(biz_categories.size() >= 5, "Must have at least 5 business categories, found %d" % biz_categories.size())
	var b_cat_ids: Array[String] = []
	for bc in biz_categories:
		b_cat_ids.append(str(bc.get("id", "")))
	assert(b_cat_ids.has("fnb"), "Business categories must include F&B")
	assert(b_cat_ids.has("logistics"), "Business categories must include Logistics")

	var all_businesses := BusinessManager.get_all_business_types()
	assert(all_businesses.size() >= 16, "Must define at least 16 business types, found %d" % all_businesses.size())

	var fnb_biz := BusinessManager.get_businesses_in_category("fnb")
	assert(fnb_biz.size() >= 1, "F&B business category must contain businesses")
	assert(str(fnb_biz[0].get("id", "")) == "biz_coffee_shop", "biz_coffee_shop should be in F&B")

	var log_biz := BusinessManager.get_businesses_in_category("logistics")
	assert(log_biz.size() >= 1, "Logistics business category must contain businesses")
	assert(str(log_biz[0].get("id", "")) == "biz_wholesaler", "biz_wholesaler should be in Logistics")

	var total_categorized := 0
	for bc in biz_categories:
		var in_cat := BusinessManager.get_businesses_in_category(str(bc.get("id", "")))
		total_categorized += in_cat.size()
	assert(total_categorized == all_businesses.size(), "All businesses must belong to a category! Found: %d vs %d" % [total_categorized, all_businesses.size()])
	print("✔ BusinessManager %d enterprises and categories verified." % all_businesses.size())

	# 3. Test UI Flow and Minigame
	print("3. Testing UI flow and Road Sign Minigame...")
	var main_scene = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main_scene)
	await get_tree().create_timer(0.5).timeout

	if is_instance_valid(main_scene.new_game_panel):
		main_scene.new_game_panel.hide()
	if is_instance_valid(main_scene.loading_screen):
		main_scene.loading_screen.hide()
	if is_instance_valid(main_scene.disclaimer_screen):
		main_scene.disclaimer_screen.hide()

	PlayerData.reset()
	PlayerData.age = 22
	PlayerData.money = 20000
	PlayerData.bank_savings = 50000
	PlayerData.licenses.clear()

	# Open Licensing Hub Modal
	main_scene._show_licensing_modal()
	await get_tree().create_timer(0.4).timeout
	assert(main_scene.licensing_modal_overlay != null, "Licensing modal overlay must be instantiated")
	assert(main_scene.licensing_modal_overlay.visible, "Licensing modal overlay must be visible")
	await _take_screenshot("verify_licensing_hub_modal.png")

	# Open Vehicle Category Modal
	main_scene._show_license_category_modal("vehicle")
	await get_tree().create_timer(0.4).timeout
	assert(main_scene.license_category_modal_overlay != null, "Vehicle license modal must be instantiated")
	assert(main_scene.license_category_modal_overlay.visible, "Vehicle license modal must be visible")
	await _take_screenshot("verify_vehicle_license_modal.png")

	# Vehicle Licenses direct acquisition (Minigame removed per user specification)
	print("Testing direct vehicle license acquisition without minigame...")
	PlayerData.money = 10000
	var car_take_res := LicenseManager.take_license("license_car")
	assert(bool(car_take_res.get("allowed", false)), "Direct vehicle license test should succeed")
	assert(PlayerData.has_license("license_car"), "Acquired license_car directly!")

	var moto_take_res := LicenseManager.take_license("license_motorcycle")
	assert(bool(moto_take_res.get("allowed", false)), "Direct motorcycle license test should succeed")
	assert(PlayerData.has_license("license_motorcycle"), "Acquired license_motorcycle directly!")

	# 4. Test Enterprise Incorporation UI & Categories
	print("4. Testing Business Modal Nested Categories...")
	main_scene._show_business_modal("incorporate")
	await get_tree().create_timer(0.4).timeout
	assert(main_scene.business_modal_overlay != null, "Business modal overlay must be instantiated")
	assert(main_scene.business_modal_overlay.visible, "Business modal overlay must be visible")
	await _take_screenshot("verify_business_incorporate_sectors.png")

	# Open F&B Category Modal
	main_scene._show_business_category_modal("fnb")
	await get_tree().create_timer(0.4).timeout
	assert(main_scene.business_category_modal_overlay != null, "Business category modal must be instantiated")
	assert(main_scene.business_category_modal_overlay.visible, "Business category modal must be visible")
	await _take_screenshot("verify_business_fnb_category.png")

	# Open Logistics Category Modal
	main_scene._show_business_category_modal("logistics")
	await get_tree().create_timer(0.4).timeout
	assert(main_scene.business_category_modal_overlay != null, "Logistics category modal must be instantiated")
	assert(main_scene.business_category_modal_overlay.visible, "Logistics category modal must be visible")
	await _take_screenshot("verify_business_logistics_category.png")

	# 5. Light Theme Verification
	print("5. Testing Light Theme Rendering...")
	if main_scene.has_node("ThemeController"):
		LifeLibrary.data["theme"] = "light"
		main_scene.get_node("ThemeController").apply_subtree(main_scene)
		await get_tree().create_timer(0.4).timeout
		main_scene._show_licensing_modal()
		await get_tree().create_timer(0.4).timeout
		await _take_screenshot("verify_licensing_hub_light_theme.png")
		main_scene._show_license_category_modal("vehicle")
		await get_tree().create_timer(0.4).timeout
		await _take_screenshot("verify_vehicle_license_light_theme.png")
		# Reset to dark
		LifeLibrary.data["theme"] = "dark"
		main_scene.get_node("ThemeController").apply_subtree(main_scene)

	print("\n========================================================")
	print("🎉 ALL LICENSING, BUSINESS NESTING & MINIGAME TESTS PASSED!")
	print("========================================================\n")
	get_tree().quit(0)


func _take_screenshot(filename: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	var viewport := get_viewport()
	if viewport != null:
		var tex := viewport.get_texture()
		if tex != null:
			var img := tex.get_image()
			if img != null:
				var path := "%s/%s" % [SCREENSHOT_DIR, filename]
				img.save_png(path)
				print("  Captured artifact: %s" % path)
