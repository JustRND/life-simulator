extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

var low_contrast_count := 0

func _ready() -> void:
	print("=== FULL AUDIT OF ALL LABELS AND TEXT IN LIGHT THEME ===")
	LifeLibrary.data.theme = "light"
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	
	PlayerData.has_started_game = true
	PlayerData.age = 25
	PlayerData.money = 15000
	PlayerData.bank_savings = 30000
	PlayerData.debt = 5000
	PlayerData.credit_score = 710
	PlayerData.has_credit_card = true
	PlayerData.credit_card_balance = 1200
	PlayerData.credit_card_limit = 5000
	PlayerData.mother_alive = true
	PlayerData.father_alive = true
	PlayerData.mother_condition = "Hypertension"
	
	if screen.has_method("on_theme_changed"):
		screen.on_theme_changed()
	else:
		screen.update_ui()
		screen.rebuild_life_feed()
		if screen.has_node("ThemeController"):
			screen.get_node("ThemeController").apply_theme()
	
	for tab in ["timeline", "character", "infant", "assets", "bank", "relationships", "activities", "settings"]:
		screen.show_tab(tab)
		if tab == "assets":
			screen.update_assets_panel()
		elif tab == "bank":
			screen.update_bank_panel()
		elif tab == "relationships":
			screen.update_relationships_panel()
		elif tab == "character":
			screen.update_character_panel()
		elif tab == "infant":
			screen.update_infant_panel()
		elif tab == "activities":
			screen._configure_button_contrasts()
		
		if screen.has_node("ThemeController"):
			screen.get_node("ThemeController").apply_subtree(screen)
		
		_audit_node(screen, tab)
	
	# Test NewGamePanel
	print("\n--- Auditing NewGamePanel (Character Creation) in Light Theme ---")
	screen.show_new_game_screen()
	_audit_node(screen.new_game_panel, "NewGamePanel")
	screen.hide_new_game_screen()
	
	# Test Asset Marketplace Modal
	print("\n--- Auditing Asset Marketplace Modal in Light Theme ---")
	screen._open_asset_marketplace_modal("cars")
	var modal_overlay = screen.get_children().back()
	if modal_overlay is Control:
		_audit_node(modal_overlay, "MarketplaceModal")
		modal_overlay.queue_free()
	
	# Test Reversible Theme Toggling
	print("\n--- Testing Theme Toggle Reversibility: Light -> Dark -> Light ---")
	LifeLibrary.data.theme = "dark"
	screen.on_theme_changed()
	LifeLibrary.data.theme = "light"
	screen.on_theme_changed()
	screen.show_tab("bank")
	screen.update_bank_panel()
	_audit_node(screen.bank_panel, "BankPanel after re-toggle")
	
	print("\n=== AUDIT COMPLETE: %d low contrast issues found ===" % low_contrast_count)
	if low_contrast_count > 0:
		push_error("Found %d low contrast issues in Light Theme!" % low_contrast_count)
		get_tree().quit(1)
	else:
		print("SUCCESS: 0 low contrast issues! All Light Theme text is highly readable.")
		get_tree().quit(0)

func _audit_node(root: Node, context: String) -> void:
	var labels: Array[Node] = root.find_children("*", "Label", true, false)
	for l in labels:
		var lbl := l as Label
		if not lbl.is_visible_in_tree():
			continue
		var text := lbl.text.strip_edges()
		if text == "":
			continue
		
		# If label has an explicit dark background (like pill badges, dark banners), light text is intentional & high-contrast
		if lbl.has_theme_stylebox("normal"):
			var sb = lbl.get_theme_stylebox("normal")
			if sb is StyleBoxFlat and sb.bg_color.get_luminance() < 0.35 and sb.bg_color.a > 0.7:
				continue
		
		var col := lbl.get_theme_color("font_color")
		var lum := col.get_luminance()
		# Flag any label that is bright/light (lum > 0.40) on light panels
		if lum > 0.40:
			low_contrast_count += 1
			print("[%s] LOW CONTRAST LBL: %s | Text: '%s' | Color: #%s (lum: %.2f)" % [
				context, lbl.name, text.replace("\n", " ").left(45), col.to_html(false), lum
			])
	
	var rtls: Array[Node] = root.find_children("*", "RichTextLabel", true, false)
	for r in rtls:
		var rtl := r as RichTextLabel
		if not rtl.is_visible_in_tree():
			continue
		if rtl.has_theme_stylebox("normal"):
			var sb = rtl.get_theme_stylebox("normal")
			if sb is StyleBoxFlat and sb.bg_color.get_luminance() < 0.35 and sb.bg_color.a > 0.7:
				continue
		var col := rtl.get_theme_color("default_color")
		var lum := col.get_luminance()
		if lum > 0.40:
			low_contrast_count += 1
			print("[%s] LOW CONTRAST RTL: %s | Text: '%s' | Color: #%s (lum: %.2f)" % [
				context, rtl.name, rtl.text.replace("\n", " ").left(45), col.to_html(false), lum
			])
