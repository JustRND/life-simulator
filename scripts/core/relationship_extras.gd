extends RefCounted

const GIFTS := [
	{"name": "Handwritten Love Letter", "cost": 10, "joy": 4, "bond": 4, "icon": "letter"},
	{"name": "Box of Chocolates", "cost": 20, "joy": 6, "bond": 6, "icon": "chocolate"},
	{"name": "Favorite Paperback", "cost": 30, "joy": 8, "bond": 8, "icon": "book"},
	{"name": "Plush Keepsake", "cost": 40, "joy": 10, "bond": 10, "icon": "present"}
]
const VENUES := [
	{"name": "City Hall & Private Reception", "cost": 12000, "joy": 12},
	{"name": "Garden Pavilion", "cost": 18000, "joy": 18},
	{"name": "Seaside Terrace", "cost": 26000, "joy": 24}
]
const STYLES := [
	{"name": "Intimate & Simple", "cost": 0, "joy": 6},
	{"name": "Classic Romance", "cost": 4000, "joy": 10},
	{"name": "Neon Celebration", "cost": 10000, "joy": 16}
]
const GUESTS := [
	{"name": "Closest Family", "cost": 0, "joy": 4},
	{"name": "Family & Friends", "cost": 3000, "joy": 8},
	{"name": "Grand Gathering", "cost": 8000, "joy": 12}
]

static func give_gift(player: Node, index: int) -> String:
	if player.is_dead or not player.has_partner() or player.last_partner_gift_age == player.age or index < 0 or index >= GIFTS.size():
		return ""
	var gift: Dictionary = GIFTS[index]
	if player.money < int(gift.cost):
		return ""
	player.money -= int(gift.cost)
	player.last_partner_gift_age = player.age
	player.last_partner_interact_age = player.age
	player.partner["happiness"] = clampi(int(player.partner.get("happiness", 50)) + int(gift.joy), 0, 100)
	player.set_partner_relationship(player.get_partner_relationship() + int(gift.bond))
	player.happiness = clampi(player.happiness + 4, 0, 100)
	return "You gave %s a %s ($%d). They were delighted with the present!" % [player.get_partner_name(), gift.name, int(gift.cost)]

static func wedding_quote(venue: int, style: int, guests: int) -> Dictionary:
	if venue < 0 or venue >= VENUES.size() or style < 0 or style >= STYLES.size() or guests < 0 or guests >= GUESTS.size():
		return {}
	return {"cost": int(VENUES[venue].cost) + int(STYLES[style].cost) + int(GUESTS[guests].cost), "joy": int(VENUES[venue].joy) + int(STYLES[style].joy) + int(GUESTS[guests].joy), "venue": VENUES[venue].name, "style": STYLES[style].name, "guests": GUESTS[guests].name}

static func celebrate_wedding(player: Node, venue: int, style: int, guests: int) -> String:
	var quote := wedding_quote(venue, style, guests)
	if quote.is_empty():
		return ""
	var description := "%s wedding at %s with %s" % [quote.style, quote.venue, quote.guests]
	var result: String = preload("res://scripts/core/romance_rules.gd").marry(player, int(quote.cost), description, int(quote.joy))
	if not result.is_empty():
		player.partner["wedding"] = quote
	return result

static func can_plan_baby(player: Node) -> bool:
	return not player.is_dead and player.has_partner() and player.get_partner_status() in ["Wife", "Husband"] and player.age >= 18 and int(player.partner.get("age", 0)) >= 18 and player.pregnancy.is_empty() and player.get_partner_relationship() >= 50 and (player.last_baby_age == -1 or player.age - player.last_baby_age >= 2)

static func pregnancy_carrier(player: Node) -> String:
	if player.is_dead or player.is_in_prison or not player.has_partner() or player.age < 18 or int(player.partner.get("age", 0)) < 18 or not player.pregnancy.is_empty():
		return ""
	if player.get_partner_status() in ["Wife", "Husband"] or (player.last_baby_age != -1 and player.age - player.last_baby_age < 2):
		return ""
	if player.gender == "FEMALE" and player.age <= 45:
		return "player"
	if player.partner.get("gender", "") == "FEMALE" and int(player.partner.get("age", 0)) <= 45:
		return "partner"
	return ""

static func begin_unplanned_pregnancy(player: Node) -> String:
	var carrier := pregnancy_carrier(player)
	if carrier.is_empty():
		return ""
	var mother: String = player.first_name if carrier == "player" else player.get_partner_name()
	var other: String = player.get_partner_name() if carrier == "player" else player.first_name
	player.pregnancy = {"carrier": carrier, "mother": mother, "other_parent": other, "conceived_age": player.age, "due_age": player.age + 1}
	player.happiness = clampi(player.happiness - 12, 0, 100)
	player.partner["happiness"] = clampi(int(player.partner.get("happiness", 50)) - 8, 0, 100)
	if player.mother_alive and not player.mother_name.is_empty():
		player.mother_relationship = maxi(0, player.mother_relationship - 8)
	if player.father_alive and not player.father_name.is_empty() and player.father_name != "Unknown":
		player.father_relationship = maxi(0, player.father_relationship - 8)
	var subject: String = "You are" if carrier == "player" else mother + " is"
	return "%s unexpectedly pregnant before marriage. The surprise leaves you anxious and strains conversations with your parents. The baby is expected next year." % subject

static func deliver_due_baby(player: Node, baby_name: String, baby_gender: String) -> String:
	if player.is_dead or player.pregnancy.is_empty() or player.age < int(player.pregnancy.get("due_age", player.age + 1)):
		return ""
	var pregnancy: Dictionary = player.pregnancy.duplicate(true)
	player.pregnancy = {}
	var child: Dictionary = player.add_player_child(baby_name, baby_gender)
	child["mother_name"] = pregnancy.mother
	child["other_parent_name"] = pregnancy.other_parent
	player.last_baby_age = player.age
	return "%s gave birth to %s. Your newborn has joined the family." % [pregnancy.mother, baby_name]
