extends RefCounted

const DURATION := 0.22 # Snappy slide-up animation so buttons settle immediately for touch interactions
static var _active_instances: Array = []
var _tween: Tween
var _panel: Control
var _top := 0.0
var _bottom := 0.0


static func finish_all_active() -> void:
	var list := _active_instances.duplicate()
	for inst in list:
		if inst != null and inst.has_method("finish_immediately"):
			inst.finish_immediately()
	_active_instances.clear()


# One controller per surface so nested panels can finish independently.
static func watch(panel: Control, visibility_source: Control = null) -> void:
	if panel.has_meta("pull_up_controller"):
		return
	var controller = load("res://scripts/ui/panel_pull_up.gd").new()
	panel.set_meta("pull_up_controller", controller)
	var source := visibility_source if visibility_source != null else panel
	source.set_meta("closing_surface", panel)
	source.visibility_changed.connect(func():
		if source.is_visible_in_tree():
			controller.play(panel)
		else:
			controller.cancel()
	)
	panel.tree_exiting.connect(controller.cancel)
	if source.is_visible_in_tree():
		controller.play(panel)


func finish_immediately() -> void:
	_active_instances.erase(self)
	if _tween != null and _tween.is_valid():
		_tween.kill()
	if is_instance_valid(_panel):
		if _panel.anchor_right == 1.0 and _panel.anchor_bottom == 1.0:
			_panel.offset_top = 0.0
			_panel.offset_bottom = 0.0
		else:
			_panel.offset_top = _top
			_panel.offset_bottom = _bottom
	_panel = null


func cancel() -> void:
	_active_instances.erase(self)
	if _tween != null and _tween.is_valid():
		_tween.kill()
	if is_instance_valid(_panel):
		if _panel.anchor_right == 1.0 and _panel.anchor_bottom == 1.0:
			_panel.offset_top = 0.0
			_panel.offset_bottom = 0.0
		else:
			_panel.offset_top = _top
			_panel.offset_bottom = _bottom
	_panel = null


func play(panel: Control) -> void:
	cancel()
	_panel = panel
	if not _active_instances.has(self):
		_active_instances.append(self)
	var is_fullscreen: bool = (panel.anchor_right == 1.0 and panel.anchor_bottom == 1.0)
	_top = 0.0 if is_fullscreen else panel.offset_top
	_bottom = 0.0 if is_fullscreen else panel.offset_bottom
	
	var vp_size_y: float = panel.get_viewport_rect().size.y
	if vp_size_y <= 0.0:
		vp_size_y = 1920.0
	var distance: float = maxf(vp_size_y - panel.global_position.y, panel.size.y)
	if distance <= 0.0 or distance > 3000.0:
		distance = vp_size_y
		
	_set_displacement(distance)
	_tween = panel.create_tween()
	_tween.tween_method(_set_displacement, distance, 0.0, DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(func():
		if is_instance_valid(panel):
			if is_fullscreen:
				panel.offset_top = 0.0
				panel.offset_bottom = 0.0
			else:
				panel.offset_top = _top
				panel.offset_bottom = _bottom
		cancel()
	)


func _set_displacement(distance: float) -> void:
	if is_instance_valid(_panel):
		_panel.offset_top = _top + distance
		_panel.offset_bottom = _bottom + distance
