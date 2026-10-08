extends RefCounted
## The compact HUD is not a menu: its labels must not become category bars.
var font := SystemFont.new()

func _init() -> void:
	font.font_names = PackedStringArray(["Arial", "Noto Sans"])
	font.font_weight = 700

func handles(node: Node) -> bool:
	var ancestor := node
	while ancestor != null:
		if ancestor.name == "StatsPanel":
			return true
		ancestor = ancestor.get_parent()
	return false

func apply(node: Control, light: bool) -> void:
	if node.name == "StatsPanel":
		var panel := StyleBoxFlat.new()
		panel.bg_color = Color("#ffffff") if light else Color("#151e2b")
		panel.border_color = Color("#9aaaba") if light else Color("#45576b")
		panel.border_width_top = 2
		node.add_theme_stylebox_override("panel", panel)
		if not node.has_meta("stats_layout"):
			node.set_meta("stats_layout", true)
			node.minimum_size_changed.connect(func(): _layout.call_deferred(node))
			node.resized.connect(func(): _layout.call_deferred(node))
		_layout.call_deferred(node)
	elif node is MarginContainer:
		for side in ["left", "right"]:
			node.add_theme_constant_override("margin_" + side, 16)
		for side in ["top", "bottom"]:
			node.add_theme_constant_override("margin_" + side, 12)
	elif node is VBoxContainer:
		node.add_theme_constant_override("separation", 4)
	elif node is Label:
		node.remove_meta("reference_section")
		node.custom_minimum_size.y = 34
		node.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		node.add_theme_font_override("font", font)
		node.add_theme_font_size_override("font_size", 26)
		node.add_theme_color_override("font_color", Color("#075b91") if light else Color("#a9dcff"))
		var spacing := StyleBoxEmpty.new()
		spacing.content_margin_left = 48
		node.add_theme_stylebox_override("normal", spacing)
	elif node is TextureRect:
		node.position = Vector2(0, 0)
		node.size = Vector2(34, 34)
	elif node is ProgressBar:
		node.custom_minimum_size.y = 28
		node.add_theme_font_override("font", font)
		node.add_theme_font_size_override("font_size", 22)
		node.add_theme_color_override("font_color", Color.WHITE)
		node.add_theme_color_override("font_outline_color", Color("#111827"))
		node.add_theme_constant_override("outline_size", 4)
		var track := StyleBoxFlat.new()
		track.bg_color = Color("#dce5ed") if light else Color("#27374b")
		track.set_corner_radius_all(4)
		node.add_theme_stylebox_override("background", track)

func _layout(panel: Control) -> void:
	if not is_instance_valid(panel) or not panel.is_inside_tree():
		return
	var feed := panel.get_parent().get_node_or_null("LifeFeedPanel") as Control
	var navigation := panel.get_parent().get_node_or_null("ActionBar") as Control
	if feed == null or navigation == null:
		return
	# Reserve the measured HUD height rather than relying on a fixed timeline end.
	panel.offset_bottom = navigation.offset_top - 16.0
	panel.offset_top = panel.offset_bottom - panel.get_combined_minimum_size().y
	feed.offset_bottom = panel.offset_top - 16.0
