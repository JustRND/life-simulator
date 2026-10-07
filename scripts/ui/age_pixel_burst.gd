extends Control

# Cosmetic RNG is isolated from the game's event/random-stat sequence.
const DURATION := 0.42
const PIXEL_COUNT := 18
const COLORS := [Color("#fff3ad"), Color("#7cf5b0"), Color("#52deed"), Color("#ffffff")]
var _rng := RandomNumberGenerator.new()
var _pixels: Array[Dictionary] = []
var _elapsed := DURATION
var _button: BaseButton

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rng.randomize()
	_button = get_parent() as BaseButton
	_button.button_down.connect(burst)
	set_process(false)

func burst() -> void:
	if _button.disabled or not _button.is_visible_in_tree():
		return
	# Replace unfinished bursts so rapid presses cannot build a particle cloud.
	_pixels.clear()
	_elapsed = 0.0
	for index in range(PIXEL_COUNT):
		var angle := TAU * float(index) / PIXEL_COUNT + _rng.randf_range(-0.09, 0.09)
		_pixels.append({
			"direction": Vector2.from_angle(angle),
			"distance": _rng.randf_range(22.0, 38.0),
			"size": _rng.randi_range(4, 7),
			"color": COLORS[index % COLORS.size()]
		})
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= DURATION or not is_visible_in_tree():
		_pixels.clear()
		set_process(false)
	queue_redraw()

func _draw() -> void:
	if _pixels.is_empty():
		return
	var progress := clampf(_elapsed / DURATION, 0.0, 1.0)
	var travel := 1.0 - pow(1.0 - progress, 3.0)
	var radius := minf(size.x, size.y) * 0.43
	var center := size * 0.5
	for pixel in _pixels:
		var direction: Vector2 = pixel["direction"]
		var point := center + direction * (radius + float(pixel["distance"]) * travel)
		point.y += 9.0 * progress * progress
		var edge := float(pixel["size"])
		# Keep every square within ten logical pixels of the button bounds.
		point = point.clamp(Vector2(-10, -10), size + Vector2(10, 10) - Vector2.ONE * edge)
		var tint: Color = pixel["color"]
		tint.a = 1.0 - smoothstep(0.2, 1.0, progress)
		draw_rect(Rect2(point.snapped(Vector2(2, 2)), Vector2.ONE * edge), tint)
