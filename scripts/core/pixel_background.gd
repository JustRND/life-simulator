extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)

func _draw() -> void:
	# Quiet pixel confetti around the chrome; the reading surface stays clear.
	draw_rect(Rect2(Vector2.ZERO, size), Color("#f1e9ff"))
	for x in range(16, int(size.x), 64):
		for y in range(16, int(size.y), 64):
			var tint := Color("#dcd2ef") if (x + y) % 128 == 32 else Color("#c8e5ef")
			draw_rect(Rect2(x, y, 6, 6), tint)
