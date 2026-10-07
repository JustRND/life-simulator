extends Node
const Rules = preload("res://scripts/core/romance_rules.gd")

func _ready() -> void:
	var player = load("res://scripts/player/player_data.gd").new()
	add_child(player)
	player.age = 27
	player.money = 10000
	player.happiness = 50
	var candidate := {"name": "Test Partner", "age": 27, "gender": "FEMALE", "compatibility": 85}
	assert(not Rules.date_result(player, candidate, false, 0.0).is_empty())
	assert(not player.has_partner() and player.happiness == 50)
	Rules.date_result(player, candidate, true, 1.0)
	assert(not player.has_partner() and player.happiness == 42)
	Rules.date_result(player, candidate, true, 0.0)
	assert(player.has_partner() and player.happiness == 54)
	var before: int = player.money
	assert(Rules.propose(player, [0, 0], 0.0).is_empty())
	assert(player.money == before)
	player.money = 10
	assert(Rules.propose(player, [2], 0.0).is_empty())
	assert(player.money == 10)
	player.money = before
	var old_joy: int = player.partner.happiness
	Rules.propose(player, [1, 2], 0.0)
	assert(player.money == before - 650)
	assert(player.partner.happiness == old_joy + 20)
	assert(Rules.engaged(player) and player.partner.engaged_age == 27)
	assert(not Rules.can_marry(player))
	assert(Rules.marry(player, 300, "City Hall").is_empty())
	# Fields survive the same JSON round trip used by game saves.
	player.partner = JSON.parse_string(JSON.stringify(player.partner))
	assert(not Rules.can_marry(player))
	player.age = 28
	assert(Rules.can_marry(player))
	assert(Rules.delay_wedding(player).is_empty())
	var happiness: int = player.happiness
	Rules.delay_wedding(player, true)
	assert(player.happiness == happiness - 3)
	assert(Rules.delay_wedding(player, true).is_empty())
	player.age = 29
	happiness = player.happiness
	Rules.delay_wedding(player)
	assert(player.happiness == happiness - 6)
	Rules.marry(player, 300, "City Hall")
	assert(player.partner.status == "Wife" and player.partner.married_age == 29)
	assert(Rules.delay_wedding(player).is_empty())
	assert(Rules.marry(player, 300, "City Hall").is_empty())
	player.partner = {"name": "Legacy", "status": "Fiancée", "is_alive": true}
	Rules.normalize(player)
	assert(player.partner.engaged_age == 29 and not Rules.can_marry(player))
	player.age = 17
	player.partner = {}
	assert(Rules.date_result(player, candidate, true, 0.0).is_empty())
	# Rejected proposals still deliver and charge for the gifts.
	player.age = 27
	player.partner = {}
	Rules.date_result(player, candidate, true, 0.0)
	player.money = 10000
	player.partner.happiness = 10
	Rules.propose(player, [0], 1.0)
	assert(player.money == 9950 and player.partner.happiness == 14)
	assert(not Rules.engaged(player))
	Rules.propose(player, [4], 0.0)
	assert(player.partner.happiness == 44)
	player.age = 28
	assert(Rules.delay_wedding(player).is_empty())
	player.age = 29
	happiness = player.happiness
	Rules.delay_wedding(player)
	assert(player.happiness == happiness - 3)
	assert(Rules.delay_wedding(player).is_empty())
	player.age = 30
	happiness = player.happiness
	Rules.delay_wedding(player)
	assert(player.happiness == happiness - 6)
	player.partner = {}
	player.is_in_prison = true
	assert(Rules.date_result(player, candidate, true, 0.0).is_empty())
	player.is_in_prison = false
	player.is_dead = true
	assert(Rules.date_result(player, candidate, true, 0.0).is_empty())
	print("ROMANCE_RULES_PASS: date outcomes, gift costs and happiness, engagement gate, JSON round trip, delay escalation, duplicate protection, legacy data")
	get_tree().quit()

