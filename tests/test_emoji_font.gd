extends Node

func _ready() -> void:
	var regular := load("res://assets/fonts/app_font.tres") as Font
	var bold := load("res://assets/fonts/app_font_bold.tres") as Font
	assert(regular != null and bold != null, "App fonts must load")
	assert(regular.has_char(0x1F3B2), "Must have dice emoji")
	assert(regular.has_char(0x25C0), "Must have arrow symbol")
	
	var touch_controller = preload("res://scripts/ui/touch_scroll_controller.gd").new()
	add_child(touch_controller)
	assert(touch_controller != null, "TouchScrollController must instantiate")
	
	print("✔ Fonts and TouchScrollController verified successfully.")
	get_tree().quit(0)
