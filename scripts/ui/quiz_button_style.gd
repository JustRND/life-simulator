extends RefCounted

static func feedback(button: Button, result: String) -> void:
	# Derive feedback from the existing button, preserving its complete geometry.
	var style := button.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	match result:
		"correct":
			style.bg_color = Color("#086449")
			style.border_color = Color("#34d399")
		"incorrect":
			style.bg_color = Color("#8c2637")
			style.border_color = Color("#fb7185")
		_:
			style.bg_color = Color("#475569")
			style.border_color = Color("#94a3b8")
	button.add_theme_stylebox_override("disabled", style)
	button.add_theme_color_override("font_disabled_color", Color.WHITE)
	button.disabled = true
