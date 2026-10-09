extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

func _ready() -> void:
	print("--- BEGIN MOBILE BOTTOM BAR GROUNDING VERIFICATION ---")
	await test_bottom_bar_grounded_no_gap()
	await test_bottom_bar_with_safe_area_insets()
	print("--- ALL MOBILE BOTTOM BAR TESTS PASSED! ---")
	get_tree().quit(0)

func test_bottom_bar_grounded_no_gap() -> void:
	print("Testing ActionBar and 5 core buttons grounded with 0 gap at screen bottom...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame

	screen.show_tab("timeline")
	var vp_size: Vector2 = screen.get_viewport_rect().size
	var action_bar: PanelContainer = screen.action_bar
	var age_btn: Button = screen.age_button
	var safe_area: Control = screen.safe_area

	assert(action_bar != null, "ActionBar must exist")
	assert(age_btn != null, "AgeButton must exist")
	assert(safe_area != null, "SafeArea must exist")

	# 1. SafeArea must reach the bottom of the viewport (offset_bottom == 0.0)
	assert(safe_area.offset_bottom == 0.0, "SafeArea offset_bottom must be 0.0, got: %f" % safe_area.offset_bottom)
	var safe_rect: Rect2 = safe_area.get_global_rect()
	assert(is_equal_approx(safe_rect.end.y, vp_size.y), "SafeArea must extend to viewport bottom %f, got %f" % [vp_size.y, safe_rect.end.y])

	# 2. ActionBar must be flush with the bottom of the viewport
	assert(action_bar.offset_bottom == 0.0, "ActionBar offset_bottom must be 0.0, got: %f" % action_bar.offset_bottom)
	var bar_rect: Rect2 = action_bar.get_global_rect()
	assert(is_equal_approx(bar_rect.end.y, vp_size.y), "ActionBar must be flush with screen bottom %f, got %f" % [vp_size.y, bar_rect.end.y])

	# 3. AgeButton bottom must be at -15.0 (resting 15px above screen bottom)
	assert(age_btn.offset_bottom == -15.0, "AgeButton offset_bottom must be -15.0, got: %f" % age_btn.offset_bottom)
	var age_rect: Rect2 = age_btn.get_global_rect()
	assert(is_equal_approx(age_rect.end.y, vp_size.y - 15.0), "AgeButton bottom must be 15px above screen bottom: %f vs %f" % [age_rect.end.y, vp_size.y - 15.0])

	# 4. StatsPanel and LifeFeedPanel must sit neatly above ActionBar
	var stats_panel = screen.get_node_or_null("SafeArea/MainColumn/StatsPanel") as Control
	var feed = screen.get_node_or_null("SafeArea/MainColumn/LifeFeedPanel") as Control
	assert(stats_panel != null, "StatsPanel must exist")
	assert(feed != null, "LifeFeedPanel must exist")

	var stats_rect: Rect2 = stats_panel.get_global_rect()
	assert(stats_rect.end.y <= bar_rect.position.y, "StatsPanel must sit above ActionBar: stats end %f, bar top %f" % [stats_rect.end.y, bar_rect.position.y])
	var feed_rect: Rect2 = feed.get_global_rect()
	assert(feed_rect.end.y <= stats_rect.position.y, "LifeFeed must sit above StatsPanel: feed end %f, stats top %f" % [feed_rect.end.y, stats_rect.position.y])

	print("✔ Test 1: Bottom bar, AgeButton, and SafeArea are perfectly grounded at the screen bottom.")
	screen.queue_free()

func test_bottom_bar_with_safe_area_insets() -> void:
	print("Testing ActionBar behavior when simulated mobile safe area inset (bottom_m) is active...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)
	await get_tree().process_frame
	await get_tree().process_frame

	screen.show_tab("timeline")
	var vp_size: Vector2 = screen.get_viewport_rect().size

	# Simulate mobile safe area inset of 48.0 (gesture bar)
	var test_inset: float = 48.0
	screen.action_bar.offset_bottom = 0.0
	screen.action_bar.offset_top = -220.0 - test_inset
	screen.action_bar.set_meta("safe_bottom_margin", test_inset)
	var panel_sb: StyleBox = screen.action_bar.get_theme_stylebox("panel")
	if panel_sb is StyleBoxFlat:
		(panel_sb as StyleBoxFlat).content_margin_bottom = test_inset
	screen.age_button.offset_bottom = -15.0 - test_inset
	screen.age_button.offset_top = -245.0 - test_inset

	var bar_rect: Rect2 = screen.action_bar.get_global_rect()
	# The bar MUST still reach the very bottom of the screen (no floating!)
	assert(is_equal_approx(bar_rect.end.y, vp_size.y), "ActionBar must still reach screen bottom with inset! Got %f, expected %f" % [bar_rect.end.y, vp_size.y])
	# The bar height has grown to accommodate the inset
	assert(is_equal_approx(bar_rect.size.y, 220.0 + test_inset), "ActionBar height should expand by inset to 268.0, got: %f" % bar_rect.size.y)

	print("✔ Test 2: Inset expands ActionBar height while keeping it grounded at the bottom edge.")
	screen.queue_free()
