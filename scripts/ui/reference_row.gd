extends MarginContainer
## Keeps the original button's text, signals, accessibility and disabled state.
const DETAILS = {
	"Life.exe Shop": ["🛒", "Discover new ways to play"],
	"Create A New Life": ["🌟", "Begin a new story"],
	"Save Life": ["💾", "Save your progress on this device"],
	"Load Life": ["👥", "Continue a previously saved life"],
	"Account Login": ["🌐", "Manage your account"],
	"T&C": ["📄", "Read the terms and conditions"],
	"Privacy Protection": ["🔐", "Learn how your data is handled"],
	"Achievements": ["🏆", "Explore your milestones"],
	"Custom Cities": ["🏙", "Add your own places to the world"],
	"Custom People": ["👤", "Create people to meet in your life"],
	"Settings": ["⚙", "Sound, language and currency"],
	"Themes": ["◐", "Choose a light or dark appearance"],
	"Education & School": ["🎓", "Study and develop your potential"],
	"Careers & Jobs": ["💼", "Find work and build your career"],
	"Finance Market": ["📈", "Trade stocks and manage businesses"],
	"Learning & Smarts": ["📚", "Keep your mind active"],
	"Freelance Marketplace": ["💻", "Earn money with flexible work"],
	"Licensing & Certifications": ["📜", "Train and earn new qualifications"],
	"Business & Enterprises": ["🏢", "Build and manage your businesses"],
	"Doctor & Healthcare": ["🩺", "Look after your health"],
}
const SYMBOLS = {"reading": "📚", "puzzle": "🧩", "chess": "♟", "museum": "🏛", "language": "🌐", "workshop": "🔧", "school": "🎓", "job": "💼", "business": "🏢", "stock": "📈", "buy": "🛒", "sell": "💰", "ring": "💍", "bouquet": "💐", "gift": "🎁", "marry": "💒", "flight": "✈", "pilot": "✈", "boat": "⛵", "car": "🚗", "bank": "🏦", "tax": "🧾", "loan": "💳", "save": "💾", "load": "📂", "cancel": "↩", "continue": "➜", "apply": "✓", "parent": "👥", "child": "👶", "pet": "🐾", "health": "❤", "gym": "💪", "study": "📖"}
var target: Button
var heading: Label
var description: Label
var symbol: Label
var art: TextureRect
var arrow: Label
var previous := ""

func _ready() -> void:
	target = get_parent() as Button
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		add_theme_constant_override("margin_" + side, 32)
	for side in ["top", "bottom"]:
		add_theme_constant_override("margin_" + side, 24)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 28)
	add_child(row)
	art = TextureRect.new()
	art.custom_minimum_size = Vector2(82, 82)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(art)
	symbol = _label(68)
	symbol.custom_minimum_size.x = 82
	symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(symbol)
	var words := VBoxContainer.new()
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	words.add_theme_constant_override("separation", 8)
	row.add_child(words)
	heading = _label(44, true)
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	words.add_child(heading)
	description = _label(34)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	words.add_child(description)
	arrow = _label(58)
	arrow.custom_minimum_size.x = 38
	row.add_child(arrow)
	_ignore_mouse(self)
	_sync()

func _label(font_size: int, bold: bool = false) -> Label:
	var result := Label.new()
	result.set_meta("reference_part", true)
	result.set_meta("locale_manual", true)
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Arial", "Noto Sans"])
	font.font_weight = 700 if bold else 400
	result.add_theme_font_override("font", font)
	result.add_theme_font_size_override("font_size", font_size)
	result.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return result

func _ignore_mouse(node: Node) -> void:
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in node.get_children():
		_ignore_mouse(child)

func _process(_delta: float) -> void:
	_sync()

func _sync() -> void:
	var light: bool = LifeLibrary.data.theme == "light"
	var key := target.text + str(target.icon) + str(target.button_pressed) + str(target.disabled) + str(light) + str(LifeLibrary.data.language)
	if key != previous:
		previous = key
		var lines := target.text.split("\n", false)
		var first := str(lines[0]) if not lines.is_empty() else ""
		var source: String = str(target.get_meta("locale_source", target.text)).split("\n")[0].strip_edges()
		var glyph := "◇"
		for keyword in SYMBOLS:
			if keyword in source.to_lower():
				glyph = SYMBOLS[keyword]
				break
		if first.length() > 1 and first.unicode_at(0) > 8000:
			var space := first.find(" ")
			if space > 0 and space < 8:
				glyph = first.substr(0, space)
				first = first.substr(space + 1).strip_edges()
		for title_text in DETAILS:
			if source.ends_with(title_text):
				glyph = DETAILS[title_text][0]
				if lines.size() < 2:
					lines.append(GameLocale.display(DETAILS[title_text][1]))
		heading.text = first
		description.text = "\n".join(lines.slice(1))
		description.visible = not description.text.is_empty()
		symbol.text = glyph
		art.texture = target.icon
		art.visible = target.icon != null
		symbol.visible = target.icon == null
		arrow.text = "✓" if target.toggle_mode and target.button_pressed else "›"
		var ink := Color("#075b91") if light else Color("#a9dcff")
		var secondary := Color("#355b75") if light else Color("#c1cddd")
		if target.disabled:
			ink = Color("#606773") if light else Color("#9da8b8")
			secondary = ink
		heading.add_theme_color_override("font_color", ink)
		description.add_theme_color_override("font_color", secondary)
		arrow.add_theme_color_override("font_color", ink)
		symbol.add_theme_color_override("font_color", ink)
	target.custom_minimum_size.y = maxf(192.0, get_combined_minimum_size().y)
