extends Node
## TouchScrollController
## Enables smooth mobile swipe/drag scrolling over buttons and removes accidental button selections during swipe.

const SWIPE_THRESHOLD := 12.0 # Minimum drag pixels before gesture is confirmed as swipe/scroll
const FRICTION := 8.5 # Kinetic scrolling friction decay

var _active_scroll: ScrollContainer = null
var _touch_start_pos := Vector2.ZERO
var _last_touch_pos := Vector2.ZERO
var _is_swiping := false
var _touch_id := -1
var _recent_moves: Array[Dictionary] = [] # Array of {"pos": Vector2, "time": int}

var _kinetic_scroll: ScrollContainer = null
var _kinetic_velocity := 0.0


func _ready() -> void:
	process_priority = -100 # Process before UI updates


func _input(event: InputEvent) -> void:
	# 1. Screen Touch (Mobile/Tablet touch events)
	if event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_handle_touch_down(st.position, st.index)
		elif st.index == _touch_id or _touch_id == -1:
			_handle_touch_up(st.position)

	# 2. Screen Drag (Mobile touch drag)
	elif event is InputEventScreenDrag:
		var sd := event as InputEventScreenDrag
		if sd.index == _touch_id or _touch_id == -1:
			_handle_touch_move(sd.position)

	# 3. Mouse Button (Web / Desktop touch emulation)
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_handle_touch_down(mb.position, -1)
			else:
				_handle_touch_up(mb.position)

	# 4. Mouse Motion (Web / Desktop drag emulation)
	elif event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		if (mm.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			_handle_touch_move(mm.position)
		else:
			# If mouse moves without any button pressed on touch device, release any accidental focus
			if _is_swiping:
				_is_swiping = false


func _handle_touch_down(pos: Vector2, id: int) -> void:
	_kinetic_velocity = 0.0
	_kinetic_scroll = null
	_touch_id = id
	_touch_start_pos = pos
	_last_touch_pos = pos
	_is_swiping = false
	_recent_moves.clear()
	_recent_moves.append({"pos": pos, "time": Time.get_ticks_msec()})
	
	_active_scroll = _find_scroll_at(get_tree().root, pos)


func _handle_touch_move(pos: Vector2) -> void:
	if _active_scroll == null or not is_instance_valid(_active_scroll) or not _active_scroll.is_visible_in_tree():
		return

	var now := Time.get_ticks_msec()
	_recent_moves.append({"pos": pos, "time": now})
	while _recent_moves.size() > 6:
		_recent_moves.remove_at(0)

	var total_delta := pos - _touch_start_pos
	if not _is_swiping:
		if abs(total_delta.y) >= SWIPE_THRESHOLD:
			_is_swiping = true
			_cancel_button_press(pos)

	if _is_swiping:
		var delta_y := pos.y - _last_touch_pos.y
		var vsb = _active_scroll.get_v_scroll_bar()
		if vsb != null:
			_active_scroll.scroll_vertical -= int(delta_y)
		_last_touch_pos = pos
		# Consume the drag event so child buttons do not handle it
		get_viewport().set_input_as_handled()


func _handle_touch_up(pos: Vector2) -> void:
	if _is_swiping:
		# Consume the release event so buttons under the finger DO NOT trigger 'pressed'
		get_viewport().set_input_as_handled()
		_cancel_button_press(pos)

		# Compute kinetic velocity from recent touch movements (within last 120ms)
		var now := Time.get_ticks_msec()
		var valid_moves: Array[Dictionary] = []
		for m in _recent_moves:
			if now - int(m.time) < 140:
				valid_moves.append(m)

		if valid_moves.size() >= 2:
			var oldest: Dictionary = valid_moves[0]
			var newest: Dictionary = valid_moves[valid_moves.size() - 1]
			var dt := (float(newest.time) - float(oldest.time)) / 1000.0
			if dt > 0.01:
				var dy := float(newest.pos.y) - float(oldest.pos.y)
				var v := dy / dt
				if abs(v) > 60.0:
					_kinetic_scroll = _active_scroll
					_kinetic_velocity = clampf(v, -3000.0, 3000.0)

	_is_swiping = false
	_active_scroll = null
	_touch_id = -1
	_recent_moves.clear()


func _cancel_button_press(_pos: Vector2) -> void:
	var vp := get_viewport()
	if vp != null:
		vp.gui_release_focus()


func _process(delta: float) -> void:
	if _kinetic_scroll != null and is_instance_valid(_kinetic_scroll) and _kinetic_scroll.is_visible_in_tree():
		if abs(_kinetic_velocity) > 8.0:
			var dy := _kinetic_velocity * delta
			var vsb = _kinetic_scroll.get_v_scroll_bar()
			if vsb != null:
				var old_val := _kinetic_scroll.scroll_vertical
				_kinetic_scroll.scroll_vertical -= int(dy)
				if _kinetic_scroll.scroll_vertical == old_val:
					# Hit top or bottom bounds
					_kinetic_velocity = 0.0
					_kinetic_scroll = null
					return
			_kinetic_velocity = lerpf(_kinetic_velocity, 0.0, FRICTION * delta)
		else:
			_kinetic_velocity = 0.0
			_kinetic_scroll = null


func _find_scroll_at(node: Node, pos: Vector2) -> ScrollContainer:
	if node == null:
		return null

	if node is CanvasItem:
		var ci := node as CanvasItem
		if not ci.is_visible_in_tree():
			return null
	elif node is Window:
		var win := node as Window
		if not win.visible:
			return null

	# Search children in reverse (topmost child renders on top and receives input first)
	for i in range(node.get_child_count() - 1, -1, -1):
		var child := node.get_child(i)
		var res := _find_scroll_at(child, pos)
		if res != null:
			return res

	if node is ScrollContainer:
		var sc := node as ScrollContainer
		var rect := sc.get_global_rect()
		if rect.has_point(pos):
			var vsb = sc.get_v_scroll_bar()
			if vsb != null and vsb.max_value > vsb.page:
				return sc

	return null

