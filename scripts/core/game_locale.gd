extends Node

signal changed
# Fictional display rates, deliberately fixed: preferences never change USD game balances.
const CURRENCIES = {"USD": [1.0, "$", 2], "IDR": [16000.0, "Rp ", 0], "EUR": [0.92, "€", 2], "GBP": [0.79, "£", 2], "JPY": [150.0, "¥", 0]}
var catalog: Dictionary = {}
var templates: Array = []
var dollar_pattern := RegEx.new()


func _ready() -> void:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string("res://data/localization/ui.json"))
	if parsed is Dictionary:
		catalog = parsed
	var tokens := RegEx.new()
	tokens.compile("%(?:\\+)?(?:\\.\\d+)?[sdf]")
	for source in catalog:
		var matches := tokens.search_all(source)
		if matches.is_empty():
			continue
		var expression := "(?s)^"
		var cursor := 0
		for token in matches:
			expression += _escape(str(source).substr(cursor, token.get_start() - cursor)) + "(.*?)"
			cursor = token.get_end()
		expression += _escape(str(source).substr(cursor)) + "$"
		var regex := RegEx.new()
		regex.compile(expression.replace("%%", "%"))
		templates.append({"regex": regex, "translations": [tokens.sub(catalog[source][0], "%s", true), tokens.sub(catalog[source][1], "%s", true)]})
	dollar_pattern.compile("\\$([0-9][0-9,]*(?:\\.[0-9]+)?)([kKmMbB]?)")


func _escape(text: String) -> String:
	var result := ""
	for character in text:
		if character in "\\.^$|?*+()[]{}":
			result += "\\"
		result += character
	return result


func language() -> String:
	return str(LifeLibrary.data.get("language", "en"))


func translate(source: String) -> String:
	var lang := language()
	if lang == "en":
		return source
	var index := 0 if lang == "id" else 1
	if catalog.has(source):
		return str(catalog[source][index])
	for entry in templates:
		var match_result: RegExMatch = entry.regex.search(source)
		if match_result != null:
			var arguments: Array = []
			for i in range(1, match_result.get_group_count() + 1):
				arguments.append(match_result.get_string(i))
			return str(entry.translations[index]) % arguments
	# Preserve decorative icons on navigation buttons.
	var clean := source.strip_edges()
	for key in catalog:
		if clean.ends_with(key) and clean.length() - str(key).length() <= 6:
			return clean.left(clean.length() - str(key).length()) + str(catalog[key][index])
	return source


func money(value: float, code: String = "") -> String:
	if code.is_empty():
		code = str(LifeLibrary.data.get("currency", "USD"))
	var spec: Array = CURRENCIES.get(code, CURRENCIES.USD)
	var converted := absf(value * float(spec[0]))
	var raw := ("%.2f" % converted) if int(spec[2]) == 2 else str(int(round(converted)))
	var parts := raw.split(".")
	var grouped := ""
	for i in parts[0].length():
		if i > 0 and (parts[0].length() - i) % 3 == 0:
			grouped += ","
		grouped += parts[0][i]
	if parts.size() > 1:
		grouped += "." + parts[1]
	return ("-" if value < 0 else "") + str(spec[1]) + grouped


func display(source: String, convert_currency: bool = true) -> String:
	var result := translate(source)
	if not convert_currency or str(LifeLibrary.data.get("currency", "USD")) == "USD":
		return result
	var matches := dollar_pattern.search_all(result)
	matches.reverse()
	for item in matches:
		var number := float(item.get_string(1).replace(",", ""))
		var suffix := item.get_string(2).to_lower()
		if suffix == "k": number *= 1000
		elif suffix == "m": number *= 1000000
		elif suffix == "b": number *= 1000000000
		result = result.left(item.get_start()) + money(number) + result.substr(item.get_end())
	return result


func set_preferences(lang: String, currency: String) -> bool:
	if lang not in ["en", "id", "ru"] or not CURRENCIES.has(currency):
		return false
	var previous_lang := language()
	var previous_currency: String = str(LifeLibrary.data.get("currency", "USD"))
	LifeLibrary.data.language = lang
	LifeLibrary.data.currency = currency
	if not LifeLibrary.persist():
		LifeLibrary.data.language = previous_lang
		LifeLibrary.data.currency = previous_currency
		return false
	changed.emit()
	return true
