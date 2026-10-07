extends Node

const STYLES = ["panel", "normal", "hover", "pressed", "disabled", "focus", "background", "read_only"]
const COLORS = ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color", "default_color", "font_placeholder_color"]


func _ready() -> void:
	get_tree().node_added.connect(func(node):
		if node is Control:
			_apply_node.call_deferred(node)
	)
	apply_theme.call_deferred()


func apply_theme() -> void:
	_walk(get_parent())


func _walk(node: Node) -> void:
	_apply_node(node)
	for child in node.get_children():
		_walk(child)


func _apply_node(node: Node) -> void:
	if not is_instance_valid(node) or not node is Control or not get_parent().is_ancestor_of(node):
		return
	var light: bool = LifeLibrary.data.theme == "light"
	if not light and not node.has_meta("dark_theme_originals"):
		return
	if not node.has_meta("dark_theme_originals"):
		var original := {"styles": {}, "colors": {}}
		for key in STYLES:
			if node.has_theme_stylebox(key):
				var style = node.get_theme_stylebox(key)
				if style is StyleBoxFlat:
					original.styles[key] = style.duplicate()
		for key in COLORS:
			original.colors[key] = node.get_theme_color(key)
		if node is ColorRect and node.material == null and node.color.a >= 0.95:
			original.rect_color = node.color
		node.set_meta("dark_theme_originals", original)
	var originals: Dictionary = node.get_meta("dark_theme_originals")
	for key in originals.styles:
		var style: StyleBoxFlat = originals.styles[key].duplicate()
		if light and style.bg_color.get_luminance() < 0.45:
			var alpha := style.bg_color.a
			style.bg_color = Color("#edf3fa") if key in ["panel", "normal", "background", "read_only"] else Color("#d5e3f2")
			style.bg_color.a = alpha
			style.border_color = style.border_color.darkened(0.35)
		node.add_theme_stylebox_override(key, style)
	for key in originals.colors:
		var color: Color = originals.colors[key]
		if light and color.get_luminance() > 0.25:
			color = color.darkened(0.72)
		node.add_theme_color_override(key, color)
	if originals.has("rect_color"):
		node.color = Color("#e4edf7") if light else originals.rect_color
