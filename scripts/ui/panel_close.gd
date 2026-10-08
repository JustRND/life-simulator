extends RefCounted

static func dismiss(source: Control, remove: bool = false, finished: Callable = Callable(), surface: Control = null) -> void:
	if not is_instance_valid(source) or source.has_meta("closing_panel"):
		return
	if not source.is_visible_in_tree():
		if remove:
			source.queue_free()
		if finished.is_valid():
			finished.call()
		return
	if surface == null:
		surface = source.get_meta("closing_surface", source)
	if not is_instance_valid(surface):
		surface = source
	if surface.has_meta("pull_up_controller"):
		surface.get_meta("pull_up_controller").cancel()
	source.set_meta("closing_panel", true)
	var buttons: Array = []
	for button in source.find_children("*", "BaseButton", true, false):
		buttons.append([button, button.disabled])
		button.disabled = true
	var top := surface.offset_top
	var bottom := surface.offset_bottom
	var distance := maxf(surface.get_viewport_rect().size.y - surface.global_position.y, surface.size.y)
	if distance < 100.0:
		distance = 1000.0
	var tween := source.create_tween()
	tween.tween_method(func(amount: float):
		if is_instance_valid(surface):
			surface.offset_top = top + amount
			surface.offset_bottom = bottom + amount
	, 0.0, distance, preload("res://scripts/ui/ui_style.gd").CLOSE_SECONDS).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	var orig_alpha := source.modulate.a
	if source != surface:
		tween.parallel().tween_property(source, "modulate:a", 0.0, preload("res://scripts/ui/ui_style.gd").CLOSE_SECONDS).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(func():
		source.hide()
		surface.offset_top = top
		surface.offset_bottom = bottom
		source.modulate.a = orig_alpha
		for entry in buttons:
			if is_instance_valid(entry[0]):
				entry[0].disabled = entry[1]
		source.remove_meta("closing_panel")
		if remove:
			source.queue_free()
		if finished.is_valid():
			finished.call()
	)
