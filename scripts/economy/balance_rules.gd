class_name BalanceRules
extends RefCounted

const LEARNING = [
	{"id": "reading", "name": "Library Reading", "cost": 0, "smarts": 3, "happiness": 1, "age": 5},
	{"id": "puzzles", "name": "Logic Puzzles", "cost": 0, "smarts": 2, "happiness": 2, "age": 5},
	{"id": "chess", "name": "Chess Club", "cost": 30, "smarts": 3, "happiness": 3, "age": 8},
	{"id": "museum", "name": "Museum Visit", "cost": 25, "smarts": 2, "happiness": 3, "age": 5},
	{"id": "language", "name": "Language Course", "cost": 180, "smarts": 5, "happiness": 1, "age": 12},
	{"id": "workshop", "name": "Practical Workshop", "cost": 120, "smarts": 4, "happiness": 2, "age": 16}
]

static func learn(p: Node, id: String) -> String:
	for activity in LEARNING:
		if activity.id != id:
			continue
		if p.is_dead or p.is_in_prison or p.age < int(activity.age):
			return "This learning activity is unavailable."
		if int(p.learning_activities.get(id, -1)) == p.age:
			return "Already completed this year."
		if p.money < int(activity.cost):
			return "Insufficient cash."
		p.money -= int(activity.cost)
		p.learning_activities[id] = p.age
		# Gradual improvement near the cap, while any activity prevents yearly decay.
		var gain := int(activity.smarts) if p.smarts < 85 else maxi(1, int(activity.smarts) / 2)
		p.smarts = mini(100, p.smarts + gain)
		p.happiness = mini(100, p.happiness + int(activity.happiness))
		p.last_school_activity_age = p.age
		var message := "%s: Smarts +%d, Happiness +%d. Mental maintenance secured for this year." % [activity.name, gain, activity.happiness]
		p.add_life_log_entry(message, "education")
		return message
	return "Activity not found."


static func event_effects(effects: Dictionary, age: int) -> Dictionary:
	var result := effects.duplicate(true)
	for stat in ["health", "happiness", "smarts", "looks"]:
		if result.has(stat):
			# Preserve meaningful choices while limiting extreme generic event swings.
			result[stat] = clampi(int(result[stat]), -12, 10)
	if result.has("money"):
		var cap := 150 if age < 13 else (1000 if age < 18 else 12000)
		result.money = clampi(int(result.money), -cap, cap)
	return result


static func salary(base: int, category: String) -> int:
	var factor := 1.0
	if category in ["retail", "fast_food", "entry_odd_jobs"]:
		factor = 1.12
	elif category == "underworld_crime":
		factor = 0.8
	elif base > 150000:
		factor = 0.92
	return int(round(base * factor / 100.0)) * 100
