extends Node
const Extras = preload("res://scripts/core/relationship_extras.gd")
const Rules = preload("res://scripts/core/romance_rules.gd")

func _ready() -> void:
	var p = load("res://scripts/player/player_data.gd").new()
	add_child(p)
	p.age = 25
	p.gender = "FEMALE"
	p.first_name = "Test Mother"
	p.partner = {"name": "Test Partner", "gender": "MALE", "age": 26, "is_alive": true, "status": "Boyfriend", "relationship": 80, "happiness": 50}
	p.money = 50000
	p.happiness = 20
	assert(not Extras.can_plan_baby(p))
	assert(Extras.GIFTS.back().cost < Rules.GIFTS[0].cost)
	var proposal_max := 0
	for gift in Rules.GIFTS:
		proposal_max += int(gift.cost)
	assert(Extras.wedding_quote(0, 0, 0).cost > proposal_max)
	assert(not Extras.give_gift(p, 0).is_empty())
	assert(p.money == 49990 and p.last_partner_gift_age == 25)
	assert(Extras.give_gift(p, 3).is_empty())
	p.age = 26
	p.money = 5
	assert(Extras.give_gift(p, 0).is_empty() and p.money == 5)
	p.partner.status = "Fiancé"
	p.partner.engaged_age = 26
	p.money = 50000
	assert(Extras.celebrate_wedding(p, 0, 0, 0).is_empty())
	p.age = 27
	assert(Extras.wedding_quote(-1, 0, 0).is_empty())
	var before: int = p.happiness
	assert(not Extras.celebrate_wedding(p, 0, 0, 0).is_empty())
	assert(p.money == 38000 and p.happiness == before + 22)
	assert(p.partner.wedding.venue == "City Hall & Private Reception")
	assert(Extras.can_plan_baby(p))
	assert(Extras.pregnancy_carrier(p).is_empty())
	assert(Extras.celebrate_wedding(p, 0, 0, 0).is_empty())
	p.partner.status = "Boyfriend"
	p.mother_name = "Parent One"
	p.father_name = "Parent Two"
	p.mother_relationship = 80
	p.father_relationship = 80
	assert(Extras.pregnancy_carrier(p) == "player")
	before = p.happiness
	assert(not Extras.begin_unplanned_pregnancy(p).is_empty())
	assert(p.happiness == before - 12 and p.mother_relationship == 72 and p.father_relationship == 72)
	assert(Extras.begin_unplanned_pregnancy(p).is_empty())
	assert(Extras.deliver_due_baby(p, "Baby", "MALE").is_empty())
	p.pregnancy = JSON.parse_string(JSON.stringify(p.pregnancy))
	p.partner = {}
	p.age += 1
	assert(not Extras.deliver_due_baby(p, "Baby", "MALE").is_empty())
	assert(p.children.size() == 1 and p.children[0].age == 0 and p.children[0].mother_name == "Test Mother")
	assert(Extras.deliver_due_baby(p, "Baby", "MALE").is_empty())
	p.last_baby_age = -1
	p.gender = "MALE"
	p.partner = {"name": "Female Partner", "gender": "FEMALE", "age": 25, "status": "Girlfriend", "is_alive": true, "relationship": 80}
	assert(Extras.pregnancy_carrier(p) == "partner")
	p.partner.gender = "MALE"
	assert(Extras.pregnancy_carrier(p).is_empty())
	p.partner.gender = "FEMALE"
	p.partner.age = 17
	assert(Extras.pregnancy_carrier(p).is_empty())
	p.partner.age = 25
	p.is_dead = true
	assert(Extras.pregnancy_carrier(p).is_empty())
	p.reset_player()
	assert(p.pregnancy.is_empty())
	print("RELATIONSHIP_EXTRAS_PASS: gift limits, prices, wedding options, marriage gate, pregnancy eligibility, penalties, persistence and single birth")
	get_tree().quit()
