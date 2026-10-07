extends Node


func _ready() -> void:
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	PlayerData.age = 25
	for tab in ["infant", "assets", "relationships", "activities", "settings", "character", "bank"]:
		var panels := {"infant": main.infant_panel, "assets": main.assets_panel, "relationships": main.relationships_panel, "activities": main.activities_panel, "settings": main.settings_overlay.get_node("SettingsCard"), "character": main.character_panel, "bank": main.bank_panel}
		var panel: Control = panels[tab]
		var top := panel.offset_top
		var bottom := panel.offset_bottom
		main.show_tab(tab)
		assert(panel.offset_top > top)
		assert(is_equal_approx(panel.offset_bottom - panel.offset_top, bottom - top))
		await get_tree().create_timer(0.45).timeout
		assert(is_equal_approx(panel.offset_top, top))
		assert(is_equal_approx(panel.offset_bottom, bottom))
		if tab == "settings":
			main._on_close_settings_button_pressed()
		else:
			main.show_tab("timeline")
		await get_tree().process_frame
	var original_top: float = main.infant_panel.offset_top
	main.show_tab("infant")
	main.show_tab("timeline")
	assert(is_equal_approx(main.infant_panel.offset_top, original_top))
	await get_tree().process_frame
	main.show_tab("infant")
	await get_tree().create_timer(0.45).timeout
	assert(is_equal_approx(main.infant_panel.offset_top, original_top))
	var modal: Dictionary = main._create_cyber_modal("TEST", "Animation check", Color.CYAN)
	var surface: Control = modal.card.get_parent()
	assert(surface.offset_top > 0.0)
	var nested: Dictionary = main._create_cyber_modal("NESTED", "Independent animation", Color.CYAN)
	await get_tree().create_timer(0.45).timeout
	assert(is_zero_approx(surface.offset_top))
	assert(is_zero_approx(nested.card.get_parent().offset_top))
	modal.overlay.queue_free()
	nested.overlay.queue_free()
	var shop = main.get_node("ShopPanel")
	shop.open_shop()
	assert(shop.offset_top > 0.0)
	shop.close_shop()
	assert(is_zero_approx(shop.offset_top))
	shop.open_shop()
	await get_tree().create_timer(0.45).timeout
	assert(is_zero_approx(shop.offset_top))
	shop.close_shop()
	var pages = main.get_node("SettingsPages")
	pages._show_page("TEST")
	assert(pages.page.offset_top > 0.0)
	await get_tree().create_timer(0.45).timeout
	assert(is_zero_approx(pages.page.offset_top))
	pages._close_page()
	main.reset_confirmation_overlay.show()
	assert(main.reset_confirmation_overlay.get_node("ConfirmCard").has_meta("pull_up_controller"))
	main.reset_confirmation_overlay.hide()
	print("PANEL_PULL_UP_TEST_PASSED")
	get_tree().quit()
