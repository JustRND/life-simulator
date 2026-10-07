extends RefCounted

const DURATION := 0.34
var _tween: Tween
var _panel: Control
var _top := 0.0
var _bottom := 0.0


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
