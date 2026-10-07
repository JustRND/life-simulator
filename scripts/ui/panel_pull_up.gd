extends RefCounted

const DURATION := 0.34
var _tween: Tween
var _panel: Control
var _top := 0.0
var _bottom := 0.0


# One controller per surface so nested panels can finish independently.
static func watch(panel: Control, visibility_source: Control = null) -> void:
	if panel.has_meta("pull_up_controller"):
		return
	var controller = load("res://scripts/ui/panel_pull_up.gd").new()
	panel.set_meta("pull_up_controller", controller)
	var source := visibility_source if visibility_source != null else panel
	source.visibility_changed.connect(func():
		if source.is_visible_in_tree():
			controller.play(panel)
		else:
			controller.cancel()
	)
	panel.tree_exiting.connect(controller.cancel)
	if source.is_visible_in_tree():
		controller.play(panel)


func cancel() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	if is_instance_valid(_panel):
		_panel.offset_top = _top
		_panel.offset_bottom = _bottom
	_panel = null


func play(panel: Control) -> void:
	cancel()
	_panel = panel
	_top = panel.offset_top
	_bottom = panel.offset_bottom
	# Move both edges equally: preserve size, anchors and the existing layout.
	var distance := maxf(panel.get_viewport_rect().size.y - panel.global_position.y, panel.size.y)
	_set_displacement(distance)
	_tween = panel.create_tween()
	_tween.tween_method(_set_displacement, distance, 0.0, DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(cancel)


func _set_displacement(distance: float) -> void:
	if is_instance_valid(_panel):
		_panel.offset_top = _top + distance
		_panel.offset_bottom = _bottom + distance
