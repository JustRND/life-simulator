extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")
const BusinessManager = preload("res://scripts/economy/business_manager.gd")
const LicenseManager = preload("res://scripts/economy/license_manager.gd")

func _ready() -> void:
	print("--- BEGIN UI LAYOUT & PANEL FIXES VERIFICATION ---")
	test_funds_counter_theme()
	test_duplicate_text_prevention()
	test_assets_panel_business_relocation()
	test_custom_business_name_input()
	test_modal_clipping_fixes()
	print("--- ALL UI LAYOUT & PANEL FIXES VERIFIED SUCCESSFULLY! ---")
	get_tree().quit(0)

func test_funds_counter_theme() -> void:
	print("Testing Funds Counter Theme...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	var balance_lbl: Label = screen.get_node_or_null("ProfileStrip/ProfileMargin/ProfileRow/BalanceLabel")
	assert(balance_lbl != null, "BalanceLabel must exist")
	assert(balance_lbl.horizontal_alignment == HORIZONTAL_ALIGNMENT_CENTER, "BalanceLabel must be centered")

	var sb: StyleBoxFlat = balance_lbl.get_theme_stylebox("normal") as StyleBoxFlat
	assert(sb != null, "BalanceLabel must have a cyber StyleBoxFlat theme")
	assert(sb.border_color == Color("#10b981"), "BalanceLabel must have emerald cyber border")
	assert(sb.corner_radius_top_left >= 10, "BalanceLabel must have rounded corners")

	PlayerData.money = 420
	PlayerData.bank_savings = 580
	screen.update_ui()
	assert(balance_lbl.text.contains("💳 $1,000"), "BalanceLabel must show formatted total with icon: %s" % balance_lbl.text)
	assert(balance_lbl.text.contains("FUNDS"), "BalanceLabel must show FUNDS caption: %s" % balance_lbl.text)
	print("✔ Funds counter theme verified.")
	screen.queue_free()

func test_duplicate_text_prevention() -> void:
	print("Testing Duplicate Text Prevention...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	# Test identical text passed
	var b1: Button = screen._create_disabled_cyber_button("Insufficient funds: Fee is $450", "Insufficient funds: Fee is $450")
	assert(b1.text == "🔒 Insufficient funds: Fee is $450", "Duplicate text must be collapsed to a single line: %s" % b1.text)

	# Test leading lock emoji already on text
	var b2: Button = screen._create_disabled_cyber_button("🔒 Insufficient funds: Fee is $450", "Insufficient funds: Fee is $450")
	assert(b2.text == "🔒 Insufficient funds: Fee is $450", "Pre-existing lock must not cause double lock: %s" % b2.text)

	# Test empty reason
	var b3: Button = screen._create_disabled_cyber_button("Requires Driving License", "")
	assert(b3.text == "🔒 Requires Driving License", "Empty reason must show single line: %s" % b3.text)

	# Test distinct reason
	var b4: Button = screen._create_disabled_cyber_button("Requires Driving License", "Take exam in Licensing Panel")
	assert(b4.text.begins_with("🔒 Requires Driving License\n"), "Distinct reason should appear on second line: %s" % b4.text)
	assert(not b4.text.contains("🔒 🔒"), "Must never have double lock emoji")

	print("✔ Duplicate requirement text prevention verified.")
	screen.queue_free()

func test_assets_panel_business_relocation() -> void:
	print("Testing Assets Panel Business Button Relocation...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	screen._render_assets_list()
	var assets_list: VBoxContainer = screen.get_node_or_null("AssetsPanel/AssetsMargin/AssetsContent/AssetsScroll/AssetsList")
	assert(assets_list != null, "AssetsList must exist")

	# First card is Dealerships / Showrooms
	var store_card: PanelContainer = assets_list.get_child(0) as PanelContainer
	var all_buttons = store_card.find_children("*", "Button", true, false)
	# Check all buttons inside dealerships card: MUST NOT contain Cyber Enterprises
	for btn in all_buttons:
		var b := btn as Button
		assert(not b.text.contains("Cyber Enterprises"), "Cyber Enterprises MUST NOT be inside Dealerships/Showrooms! Found: %s" % b.text)

	# Find the Business section: MUST be located below OWNED REAL ESTATE & PROPERTIES
	var children = assets_list.get_children()
	var real_estate_idx: int = -1
	var business_idx: int = -1

	for i in range(children.size()):
		var c = children[i]
		var txt: String = ""
		for l in c.find_children("*", "Label", true, false):
			txt += (l as Label).text + " "
		if txt.contains("OWNED REAL ESTATE"):
			real_estate_idx = i
		elif txt.contains("COMMERCIAL ENTERPRISES"):
			business_idx = i

	assert(real_estate_idx != -1, "Real Estate section must exist")
	assert(business_idx != -1, "Commercial Enterprises section must exist")
	assert(business_idx > real_estate_idx, "Commercial Enterprises MUST be located below Real Estate! Real Estate: %d, Business: %d" % [real_estate_idx, business_idx])

	# Verify business button exists inside the Commercial Enterprises section
	var biz_section = children[business_idx]
	var found_biz_btn: bool = false
	for b in biz_section.find_children("*", "Button", true, false):
		if (b as Button).text.contains("Cyber Enterprises"):
			found_biz_btn = true
			break
	assert(found_biz_btn, "Business button must exist inside the Commercial Enterprises section")

	print("✔ Business button relocated below Owned Real Estate verified.")
	screen.queue_free()

func test_custom_business_name_input() -> void:
	print("Testing Custom Business Name Input & Incorporation...")
	PlayerData.reset()
	PlayerData.age = 25
	PlayerData.money = 500000
	PlayerData.degrees.append({
		"major": "food_science",
		"major_title": "Food Science & Culinary Arts"
	})

	var eval := BusinessManager.can_found_business("biz_coffee_shop")
	assert(eval["allowed"], "Player with degree and money should be allowed to found business: %s" % str(eval))

	var custom_name := "Neo-Shinjuku Espresso Bar"
	var res := BusinessManager.found_business("biz_coffee_shop", custom_name)
	assert(res.get("allowed", false), "Founding business should succeed: %s" % str(res))

	var found_biz = res.get("business", {})
	assert(found_biz.get("name") == custom_name, "Registered business name must match custom user input: %s" % found_biz.get("name"))

	# Verify in player data
	assert(PlayerData.owned_businesses.size() == 1, "Player must own 1 business")
	assert(PlayerData.owned_businesses[0]["name"] == custom_name, "Owned business name must match custom name")

	print("✔ Custom business name input and founding verified.")

func test_modal_clipping_fixes() -> void:
	print("Testing Modal Clipping Fixes...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	var modal_dict: Dictionary = screen._create_cyber_modal("TEST MODAL", "Test Subtitle", Color("#38bdf8"))
	var overlay: ColorRect = modal_dict["overlay"]
	var card: PanelContainer = modal_dict["card"]
	var scroll: ScrollContainer = modal_dict["scroll"]
	var close_btn: Button = modal_dict["close_button"]

	assert(overlay != null and is_instance_valid(overlay), "Overlay must exist")
	assert(card != null and is_instance_valid(card), "Card must exist")
	assert(card.clip_contents, "Card must have clip_contents = true")
	assert(card.size_flags_horizontal == Control.SIZE_EXPAND_FILL, "Card must expand to fill")
	assert(card.size_flags_vertical == Control.SIZE_EXPAND_FILL, "Card must expand to fill")

	assert(scroll != null and is_instance_valid(scroll), "ScrollContainer must exist")
	assert(scroll.clip_contents, "ScrollContainer must have clip_contents = true")
	assert(scroll.size_flags_vertical == Control.SIZE_EXPAND_FILL, "ScrollContainer must expand to fill remaining height")

	assert(close_btn != null and is_instance_valid(close_btn), "Close button must exist")

	overlay.queue_free()
	screen.queue_free()
	print("✔ Modal non-clipping architecture verified.")
