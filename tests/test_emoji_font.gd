extends Node

func _ready() -> void:
	var fv := FontVariation.new()
	var regular := load("res://assets/fonts/app_font.tres") as Font
	var bold := load("res://assets/fonts/app_font_bold.tres") as Font
	
	print("regular is valid: ", regular != null)
	print("bold is valid: ", bold != null)
	if regular != null and bold != null:
		print("regular 'A': ", regular.has_char(65))
		print("regular 🎲: ", regular.has_char(0x1F3B2))
		print("regular 👉: ", regular.has_char(0x1F449))
		print("regular ◀: ", regular.has_char(0x25C0))
		print("regular ☰: ", regular.has_char(0x2630))
		print("bold 'A': ", bold.has_char(65))
		print("bold 🎲: ", bold.has_char(0x1F3B2))
		print("bold 👉: ", bold.has_char(0x1F449))
		print("bold ◀: ", bold.has_char(0x25C0))
		print("bold ☰: ", bold.has_char(0x2630))
	get_tree().quit(0)
