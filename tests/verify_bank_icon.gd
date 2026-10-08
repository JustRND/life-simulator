extends Node

func _ready() -> void:
	print("=== BEGIN VERIFICATION: BANK ICON ===")
	
	LifeLibrary.data.theme = "light"
	PlayerData.reset_player()
	
	var main_scene_res = load("res://scenes/main/main_screen.tscn")
	var main_scene = main_scene_res.instantiate()
	add_child(main_scene)
	
	if main_scene.disclaimer_screen != null:
		main_scene.disclaimer_screen.hide()
	if main_scene.loading_screen != null:
		main_scene.loading_screen.hide()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	main_scene.show_tab("assets")
	await get_tree().process_frame
	await get_tree().process_frame
	
	var bank_btn: Button = main_scene.bank_button
	assert(bank_btn != null, "BankButton must exist")
	var ref_row = bank_btn.get_node_or_null("ReferenceRow")
	if ref_row != null:
		print("ReferenceRow symbol text: ", ref_row.symbol.text)
		print("ReferenceRow symbol visible: ", ref_row.symbol.visible)
		assert(ref_row.symbol.text == "🏦", "ReferenceRow symbol text must be 🏦")
		assert(ref_row.symbol.visible == true, "ReferenceRow symbol must be visible")
	
	PlayerData.age = 20
	main_scene.show_tab("bank")
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert(main_scene.bank_header_icon != null, "bank_header_icon must exist")
	assert(main_scene.bank_header_icon.texture != null, "bank_header_icon texture must be non-null")
	
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var img2 := get_viewport().get_texture().get_image()
		if img2 != null and not img2.is_empty():
			img2.save_png("res://tests/verify_bank_panel.png")
			print("Saved screenshot to res://tests/verify_bank_panel.png")
	
	print("✔ Bank icon & panel verification completed successfully!")
	get_tree().quit(0)
