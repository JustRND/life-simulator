extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://portfolio_layout_test_profile.json"
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	PlayerData.finance_market.holdings = {
		"layout_loss": {"quantity": 3060, "cost": 147206, "price": 47.63, "name": "Lotus Robotics Industries"},
		"layout_gain": {"quantity": 1000, "cost": 100, "price": 12345.67, "name": "International Technology and Investment Holdings"}
	}
	var finance = main.get_node("FinancePanel")
	finance.selected_tab = "Portfolio"
	for mode in ["light", "dark"]:
		LifeLibrary.data.theme = mode
		for dimensions in [Vector2i(390, 844), Vector2i(1920, 1080)]:
			get_window().size = dimensions
			finance.open()
			await get_tree().create_timer(0.6).timeout
			var values = finance.overlay.find_children("PortfolioProfitLoss", "Label", true, false)
			assert(values.size() == 2)
			for value in values:
				assert(value.autowrap_mode == TextServer.AUTOWRAP_OFF)
				assert(value.get_line_count() == 1)
				assert(value.size.x >= value.get_minimum_size().x)
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://work/portfolio-" + mode + "-" + str(dimensions.x) + ".png")
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("PORTFOLIO_LAYOUT_TEST: PASS — positive/negative amounts remain horizontal at mobile/desktop widths in both themes")
	get_tree().quit()
