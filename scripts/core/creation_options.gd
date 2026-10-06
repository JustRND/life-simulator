extends RefCounted

# Coordinates refer to the supplied 2048px sheet, expressed on its 1600px preview.
const COUNTRIES = [
	["Argentina", 15, 2], ["Australia", 2, 0], ["Brazil", 4, 1],
	["Canada", 1, 1], ["Denmark", 13, 3], ["France", 5, 1],
	["Germany", 0, 2], ["India", 14, 0], ["Indonesia", 3, 16],
	["Ireland", 8, 2], ["Italy", 1, 2], ["Japan", 4, 0],
	["Mexico", 5, 2], ["Netherlands", 7, 2], ["Norway", 7, 0],
	["Portugal", 7, 4], ["Russia", 3, 0], ["Singapore", 14, 3], ["South Africa", 15, 0],
	["South Korea", 11, 0], ["Spain", 15, 1], ["Sweden", 6, 1],
	["Switzerland", 8, 9], ["United Kingdom", 1, 0], ["United States", 0, 0]
]
const FLAG_ROW_TOP = [153, 242, 327, 412, 494, 575, 656, 738, 818, 899, 979, 1059, 1139, 1219, 1299, 1380, 1459, 1539]
const FLAG_ROW_BOTTOM = [199, 286, 371, 455, 537, 619, 699, 780, 861, 941, 1021, 1101, 1182, 1262, 1342, 1423, 1502, 1582]

static func normalize_name(value: String) -> String:
	var words := value.strip_edges().split(" ", false)
	for index in range(words.size()):
		words[index] = words[index].left(1).to_upper() + words[index].substr(1).to_lower()
	return " ".join(words)

static func valid_name(value: String) -> bool:
	var pattern := RegEx.new()
	pattern.compile("^[\\p{L}]+(?: [\\p{L}]+)*$")
	return value.length() >= 2 and value.length() <= 40 and pattern.search(value) != null

static func flag_texture(column: int, row: int) -> AtlasTexture:
	var sheet: Texture2D = load("res://assets/sheets/flags.jpg")
	if sheet == null:
		return null
	var icon := AtlasTexture.new()
	icon.atlas = sheet
	var factor := float(sheet.get_width()) / 1600.0
	# Inset inside the colored flag face, excluding the sheet's black frame.
	icon.region = Rect2((column * 100 + 17) * factor, (FLAG_ROW_TOP[row] + 1) * factor, 66 * factor, (FLAG_ROW_BOTTOM[row] - FLAG_ROW_TOP[row] - 1) * factor)
	icon.filter_clip = true
	return icon

static func get_flag_for_country(country_name: String) -> AtlasTexture:
	for entry in COUNTRIES:
		if entry[0].to_lower() == country_name.to_lower():
			return flag_texture(int(entry[1]), int(entry[2]))
	# Fallback to first entry if not found
	return flag_texture(int(COUNTRIES[0][1]), int(COUNTRIES[0][2]))
