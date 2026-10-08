extends Node

func _ready() -> void:
	LifeLibrary.profile_path = "user://quiz_style_test_profile.json"
	get_window().size = Vector2i(540, 960)
	var main = load("res://scenes/main/main_screen.tscn").instantiate()
	add_child(main)
	await get_tree().create_timer(3.5).timeout
	main.new_game_panel.hide()
	main.loading_screen.hide()
	main.disclaimer_screen.hide()
	for mode in ["light", "dark"]:
		LifeLibrary.data.theme = mode
		for variant in [["math", false], ["trivia", false], ["trivia", true]]:
			main._start_education_minigame(variant[0], variant[1])
			await get_tree().create_timer(0.45).timeout
			for choose_correct in [false, true]:
				var container: Node = main.education_minigame_state.question_container
				var answers: Array[Button] = []
				var chosen: Button = null
				for candidate in container.find_children("*", "Button", true, false):
					if candidate.has_meta("quiz_correct"):
						answers.append(candidate)
						if bool(candidate.get_meta("quiz_correct")) == choose_correct:
							chosen = candidate
				assert(answers.size() == 4 and chosen != null)
				chosen.pressed.emit()
				await get_tree().process_frame
				for answer in answers:
					assert(answer.disabled)
					var normal: StyleBoxFlat = answer.get_theme_stylebox("normal")
					var locked: StyleBoxFlat = answer.get_theme_stylebox("disabled")
					assert(normal.corner_radius_top_left == locked.corner_radius_top_left)
					assert(normal.content_margin_left == locked.content_margin_left)
					assert(normal.content_margin_top == locked.content_margin_top)
					assert(normal.border_width_left == locked.border_width_left)
					assert(normal.shadow_size == locked.shadow_size)
					assert(answer.get_theme_color("font_disabled_color") == Color.WHITE)
					if bool(answer.get_meta("quiz_correct")):
						assert(locked.bg_color == Color("#086449"))
					elif answer == chosen:
						assert(locked.bg_color == Color("#8c2637"))
				if variant[0] == "math":
					await RenderingServer.frame_post_draw
					get_viewport().get_texture().get_image().save_png("res://work/quiz-feedback-" + mode + "-" + str(choose_correct) + ".png")
				if not choose_correct:
					main._advance_education_minigame()
					await get_tree().process_frame
	if FileAccess.file_exists(LifeLibrary.profile_path):
		DirAccess.remove_absolute(LifeLibrary.profile_path)
	print("QUIZ_STYLE_TEST_PASSED")
	get_tree().quit()
