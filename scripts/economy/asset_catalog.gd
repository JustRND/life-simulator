class_name AssetCatalog
extends RefCounted

const CATEGORY_CARS := "cars"
const CATEGORY_MOTORCYCLES := "motorcycles"
const CATEGORY_PROPERTIES := "properties"

const ITEMS := {
	# =========================================================================
	# 🚗 16 CARS
	# =========================================================================
	"car_rustbucket": {
		"id": "car_rustbucket",
		"category": CATEGORY_CARS,
		"name": "Rustbucket Beater '88",
		"price": 850,
		"upkeep": 120,
		"happiness_bonus": 3,
		"desc": "A faded, dented retro hatchback with rusted wheel arches. It barely starts on cold mornings, but it's completely yours.",
		"image_path": "res://assets/items/cars/car_rustbucket.jpg",
		"min_age": 16
	},
	"car_moped_car": {
		"id": "car_moped_car",
		"category": CATEGORY_CARS,
		"name": "Micro Commuter Pod",
		"price": 2400,
		"upkeep": 190,
		"happiness_bonus": 5,
		"desc": "A tiny 2-seater bubble city car in sunny yellow. Squeezes into impossible parking spots with unmatched efficiency.",
		"image_path": "res://assets/items/cars/car_moped_car.jpg",
		"min_age": 16
	},
	"car_hatchback": {
		"id": "car_hatchback",
		"category": CATEGORY_CARS,
		"name": "Cyber Hatchback '98",
		"price": 4800,
		"upkeep": 380,
		"happiness_bonus": 7,
		"desc": "A trusty Japanese-style retro 5-door runabout. Affordable, fuel-efficient, and easy to maintain.",
		"image_path": "res://assets/items/cars/car_hatchback.jpg",
		"min_age": 16
	},
	"car_wagon": {
		"id": "car_wagon",
		"category": CATEGORY_CARS,
		"name": "Nordic Station Wagon",
		"price": 8500,
		"upkeep": 650,
		"happiness_bonus": 9,
		"desc": "A sturdy, boxy 90s family estate wagon with roof rails. Practical, reliable, and seats five comfortably.",
		"image_path": "res://assets/items/cars/car_wagon.jpg",
		"min_age": 16
	},
	"car_pickup": {
		"id": "car_pickup",
		"category": CATEGORY_CARS,
		"name": "Atlas Workhorse Pickup",
		"price": 12500,
		"upkeep": 850,
		"happiness_bonus": 11,
		"desc": "A heavy-duty classic red steel utility pickup with chrome bumpers. Can haul concrete or tow a trailer effortlessly.",
		"image_path": "res://assets/items/cars/car_pickup.jpg",
		"min_age": 16
	},
	"car_sedan": {
		"id": "car_sedan",
		"category": CATEGORY_CARS,
		"name": "Neo City Sedan",
		"price": 22000,
		"upkeep": 1200,
		"happiness_bonus": 13,
		"desc": "A sleek, whisper-quiet electric commuter sedan with autonomous cruise and neon cyan trim.",
		"image_path": "res://assets/items/cars/car_sedan.jpg",
		"min_age": 16
	},
	"car_ev_compact": {
		"id": "car_ev_compact",
		"category": CATEGORY_CARS,
		"name": "Volt Eco-Runner",
		"price": 28000,
		"upkeep": 950,
		"happiness_bonus": 15,
		"desc": "A modern aerodynamic electric hatchback with pearl white paint and illuminated LED accent lights.",
		"image_path": "res://assets/items/cars/car_ev_compact.jpg",
		"min_age": 16
	},
	"car_coupe": {
		"id": "car_coupe",
		"category": CATEGORY_CARS,
		"name": "Kuro 240 Sport Coupe",
		"price": 36000,
		"upkeep": 1600,
		"happiness_bonus": 18,
		"desc": "A legendary 90s JDM street tuner with iconic pop-up headlights, bronze alloy rims, and responsive handling.",
		"image_path": "res://assets/items/cars/car_coupe.jpg",
		"min_age": 18
	},
	"car_muscle": {
		"id": "car_muscle",
		"category": CATEGORY_CARS,
		"name": "V8 Iron Stallion",
		"price": 52000,
		"upkeep": 2400,
		"happiness_bonus": 22,
		"desc": "An aggressive American roaring muscle coupe with classic white racing stripes, chrome mag wheels, and thunderous torque.",
		"image_path": "res://assets/items/cars/car_muscle.jpg",
		"min_age": 18
	},
	"car_offroad": {
		"id": "car_offroad",
		"category": CATEGORY_CARS,
		"name": "Titan 4x4 Overland SUV",
		"price": 68000,
		"upkeep": 3200,
		"happiness_bonus": 24,
		"desc": "A lifted overland exploration truck with massive all-terrain knobby tires, bull bar, snorkel, and rooftop LED lightbar.",
		"image_path": "res://assets/items/cars/car_offroad.jpg",
		"min_age": 18
	},
	"car_executive": {
		"id": "car_executive",
		"category": CATEGORY_CARS,
		"name": "Aethelgard Executive Saloon",
		"price": 95000,
		"upkeep": 4800,
		"happiness_bonus": 27,
		"desc": "An elite obsidian black luxury stretch sedan. Acoustic soundproof glass, handcrafted walnut dash, and supreme prestige.",
		"image_path": "res://assets/items/cars/car_executive.jpg",
		"min_age": 18
	},
	"car_ev_luxury": {
		"id": "car_ev_luxury",
		"category": CATEGORY_CARS,
		"name": "Zephyr Cyber Sedan GT",
		"price": 135000,
		"upkeep": 5200,
		"happiness_bonus": 30,
		"desc": "A cutting-edge luxury EV with a full panoramic glass roof, glowing cybernetic underglow, and autopilot navigation.",
		"image_path": "res://assets/items/cars/car_ev_luxury.jpg",
		"min_age": 18
	},
	"car_grand_tourer": {
		"id": "car_grand_tourer",
		"category": CATEGORY_CARS,
		"name": "Monaco GT Coupe",
		"price": 185000,
		"upkeep": 7800,
		"happiness_bonus": 33,
		"desc": "A prestigious British-style grand touring coupe in polished liquid silver. High-speed continental cruising with bespoke leather.",
		"image_path": "res://assets/items/cars/car_grand_tourer.jpg",
		"min_age": 18
	},
	"car_sportscar": {
		"id": "car_sportscar",
		"category": CATEGORY_CARS,
		"name": "Apex GT Supercar",
		"price": 260000,
		"upkeep": 9800,
		"happiness_bonus": 36,
		"desc": "A blistering twin-turbo mid-engine supercar in fiery crimson. Turns heads and shatters 0-60 acceleration records.",
		"image_path": "res://assets/items/cars/car_sportscar.jpg",
		"min_age": 18
	},
	"car_hypercar": {
		"id": "car_hypercar",
		"category": CATEGORY_CARS,
		"name": "Valkyrie Phantom V12",
		"price": 650000,
		"upkeep": 18000,
		"happiness_bonus": 42,
		"desc": "An exotic aerodynamic stealth hypercar in matte black and neon violet. Active aero wing, scissor doors, and 1,100 HP.",
		"image_path": "res://assets/items/cars/car_hypercar.jpg",
		"min_age": 21
	},
	"car_prototype": {
		"id": "car_prototype",
		"category": CATEGORY_CARS,
		"name": "Orbital Mag-Drive Prototype",
		"price": 1400000,
		"upkeep": 35000,
		"happiness_bonus": 50,
		"desc": "A one-of-a-kind concept vehicle engineered with carbon-fiber weave and magnetic induction drive. The pinnacle of automotive status.",
		"image_path": "res://assets/items/cars/car_prototype.jpg",
		"min_age": 21
	},

	# =========================================================================
	# 🏍️ 16 MOTORCYCLES
	# =========================================================================
	"moto_moped": {
		"id": "moto_moped",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Rusty 50cc Moped",
		"price": 450,
		"upkeep": 60,
		"happiness_bonus": 3,
		"desc": "A weathered, rusted vintage commuter moped with a front wire basket. Putters along city back alleys at a relaxed pace.",
		"image_path": "res://assets/items/motorcycles/moto_moped.jpg",
		"min_age": 14
	},
	"moto_scooter": {
		"id": "moto_scooter",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Vespa Mint 50cc",
		"price": 1400,
		"upkeep": 150,
		"happiness_bonus": 5,
		"desc": "A charming mint-green city scooter. Zips through congested city traffic with vintage Italian flair.",
		"image_path": "res://assets/items/motorcycles/moto_scooter.jpg",
		"min_age": 15
	},
	"moto_e_scooter": {
		"id": "moto_e_scooter",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Volt Urban E-Glide",
		"price": 2600,
		"upkeep": 180,
		"happiness_bonus": 7,
		"desc": "A sleek modern electric urban scooter with cyan neon accent lights and zero emissions.",
		"image_path": "res://assets/items/motorcycles/moto_e_scooter.jpg",
		"min_age": 15
	},
	"moto_dirtbike": {
		"id": "moto_dirtbike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "MudSlinger 250 Enduro",
		"price": 4500,
		"upkeep": 320,
		"happiness_bonus": 9,
		"desc": "A high-clearance off-road motocross bike with knobby dirt tires and bright orange plastics. Conquers trails and gravel.",
		"image_path": "res://assets/items/motorcycles/moto_dirtbike.jpg",
		"min_age": 16
	},
	"moto_cafe_racer": {
		"id": "moto_cafe_racer",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Ace Vintage Cafe Racer",
		"price": 7200,
		"upkeep": 480,
		"happiness_bonus": 12,
		"desc": "A stripped-down retro racer with clip-on handlebars, round headlight, and polished chrome fuel tank.",
		"image_path": "res://assets/items/motorcycles/moto_cafe_racer.jpg",
		"min_age": 16
	},
	"moto_scrambler": {
		"id": "moto_scrambler",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Desert Nomad Scrambler",
		"price": 9200,
		"upkeep": 560,
		"happiness_bonus": 14,
		"desc": "A rugged classic dual-sport bike with ribbed leather bench seat, wire wheels, and high-mounted scrambler exhaust.",
		"image_path": "res://assets/items/motorcycles/moto_scrambler.jpg",
		"min_age": 16
	},
	"moto_naked_bike": {
		"id": "moto_naked_bike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Shadow 400 Streetfighter",
		"price": 11500,
		"upkeep": 680,
		"happiness_bonus": 16,
		"desc": "An aggressive naked street bike with neon lime exposed trellis frame and dual projector headlights.",
		"image_path": "res://assets/items/motorcycles/moto_naked_bike.jpg",
		"min_age": 16
	},
	"moto_cruiser": {
		"id": "moto_cruiser",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Thunder Chopper V-Twin",
		"price": 13500,
		"upkeep": 800,
		"happiness_bonus": 18,
		"desc": "Heavy chrome, a rumbling twin engine, and tall ape-hangers. The quintessential sound of the open road.",
		"image_path": "res://assets/items/motorcycles/moto_cruiser.jpg",
		"min_age": 16
	},
	"moto_touring": {
		"id": "moto_touring",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Cross-Continent Tourer",
		"price": 17500,
		"upkeep": 950,
		"happiness_bonus": 20,
		"desc": "A long-haul highway cruiser with aerodynamic windshield, heated grips, and lockable hard saddlebags.",
		"image_path": "res://assets/items/motorcycles/moto_touring.jpg",
		"min_age": 18
	},
	"moto_sportbike": {
		"id": "moto_sportbike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Ninja Pulse 600R",
		"price": 21000,
		"upkeep": 1200,
		"happiness_bonus": 22,
		"desc": "A razor-sharp supersport track motorcycle with race fairings and screaming high-RPM inline-four engine.",
		"image_path": "res://assets/items/motorcycles/moto_sportbike.jpg",
		"min_age": 18
	},
	"moto_bobber": {
		"id": "moto_bobber",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Blackout Custom Bobber",
		"price": 25000,
		"upkeep": 1400,
		"happiness_bonus": 24,
		"desc": "A slammed custom bobber in matte black with brass detailing and a solo leather spring saddle.",
		"image_path": "res://assets/items/motorcycles/moto_bobber.jpg",
		"min_age": 18
	},
	"moto_kusanagi": {
		"id": "moto_kusanagi",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Kusanagi RX-9 Sportbike",
		"price": 34000,
		"upkeep": 2200,
		"happiness_bonus": 28,
		"desc": "A legendary cyber-racing machine in glowing crimson and neon cyan. Extreme cornering stability and carbon chassis.",
		"image_path": "res://assets/items/motorcycles/moto_kusanagi.jpg",
		"min_age": 18
	},
	"moto_adventure": {
		"id": "moto_adventure",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Dakar Rally Explorer 1200",
		"price": 44000,
		"upkeep": 2600,
		"happiness_bonus": 30,
		"desc": "A heavyweight globetrotting adventure motorcycle with reinforced crash bars and aluminum expedition boxes.",
		"image_path": "res://assets/items/motorcycles/moto_adventure.jpg",
		"min_age": 18
	},
	"moto_drag_bike": {
		"id": "moto_drag_bike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Nitro Hellcat Drag Bike",
		"price": 58000,
		"upkeep": 3800,
		"happiness_bonus": 34,
		"desc": "A supercharged drag motorcycle with stretched swingarm, wide rear racing slick, and hotrod flame livery.",
		"image_path": "res://assets/items/motorcycles/moto_drag_bike.jpg",
		"min_age": 18
	},
	"moto_superbike": {
		"id": "moto_superbike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Corse V4 Carbon Superbike",
		"price": 88000,
		"upkeep": 5400,
		"happiness_bonus": 38,
		"desc": "A hand-built Italian masterpiece with full dry-carbon bodywork and titanium exhaust. Pure racing adrenaline.",
		"image_path": "res://assets/items/motorcycles/moto_superbike.jpg",
		"min_age": 21
	},
	"moto_cyber_hover": {
		"id": "moto_cyber_hover",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Neo-Tokyo Akuma Cyberbike",
		"price": 165000,
		"upkeep": 8500,
		"happiness_bonus": 45,
		"desc": "A breathtaking cyberpunk street machine with illuminated hubless wheels and electromagnetic drive.",
		"image_path": "res://assets/items/motorcycles/moto_cyber_hover.jpg",
		"min_age": 21
	},

	# =========================================================================
	# 🏠 16 PROPERTIES
	# =========================================================================
	"prop_capsule": {
		"id": "prop_capsule",
		"category": CATEGORY_PROPERTIES,
		"name": "Micro Capsule Pod",
		"price": 32000,
		"upkeep": 800,
		"happiness_bonus": 6,
		"desc": "A compact, high-tech sleeping pod apartment with holographic terminals and cozy mood lighting in the cyber district.",
		"image_path": "res://assets/items/properties/prop_capsule.jpg",
		"min_age": 18
	},
	"prop_tenement": {
		"id": "prop_tenement",
		"category": CATEGORY_PROPERTIES,
		"name": "Old District Tenement Flat",
		"price": 68000,
		"upkeep": 1400,
		"happiness_bonus": 8,
		"desc": "A historic red brick apartment above a bustling noodle shop with classic exterior iron fire escapes.",
		"image_path": "res://assets/items/properties/prop_tenement.jpg",
		"min_age": 18
	},
	"prop_studio": {
		"id": "prop_studio",
		"category": CATEGORY_PROPERTIES,
		"name": "Downtown Studio Loft",
		"price": 125000,
		"upkeep": 2400,
		"happiness_bonus": 12,
		"desc": "A vibrant modern loft situated above late-night ramen spots and illuminated cyber storefronts.",
		"image_path": "res://assets/items/properties/prop_studio.jpg",
		"min_age": 18
	},
	"prop_condo": {
		"id": "prop_condo",
		"category": CATEGORY_PROPERTIES,
		"name": "Neon Heights 1-Bedroom Condo",
		"price": 195000,
		"upkeep": 3600,
		"happiness_bonus": 15,
		"desc": "A sleek high-rise condo featuring a private glass balcony overlooking the sparkling metropolis night skyline.",
		"image_path": "res://assets/items/properties/prop_condo.jpg",
		"min_age": 18
	},
	"prop_cottage": {
		"id": "prop_cottage",
		"category": CATEGORY_PROPERTIES,
		"name": "Sunnyvale Starter Cottage",
		"price": 275000,
		"upkeep": 4800,
		"happiness_bonus": 18,
		"desc": "A storybook suburban cottage with stone chimney, white picket fence, flower garden, and peaceful surroundings.",
		"image_path": "res://assets/items/properties/prop_cottage.jpg",
		"min_age": 18
	},
	"prop_townhouse": {
		"id": "prop_townhouse",
		"category": CATEGORY_PROPERTIES,
		"name": "Cobblestone Row Townhouse",
		"price": 360000,
		"upkeep": 6200,
		"happiness_bonus": 21,
		"desc": "A charming three-story brick Victorian townhouse with grand bay windows, wrought iron gates, and warm glowing lamps.",
		"image_path": "res://assets/items/properties/prop_townhouse.jpg",
		"min_age": 18
	},
	"prop_house": {
		"id": "prop_house",
		"category": CATEGORY_PROPERTIES,
		"name": "Suburban Family Residence",
		"price": 460000,
		"upkeep": 7800,
		"happiness_bonus": 24,
		"desc": "A picturesque two-story home with a manicured front lawn, driveway, garage, and leafy tree in a peaceful suburb.",
		"image_path": "res://assets/items/properties/prop_house.jpg",
		"min_age": 18
	},
	"prop_cabin": {
		"id": "prop_cabin",
		"category": CATEGORY_PROPERTIES,
		"name": "Pine Crest Lakeside Cabin",
		"price": 580000,
		"upkeep": 8500,
		"happiness_bonus": 27,
		"desc": "A peaceful timber log cabin nestled among dense evergreens on the edge of a serene mountain lake.",
		"image_path": "res://assets/items/properties/prop_cabin.jpg",
		"min_age": 18
	},
	"prop_modern_villa": {
		"id": "prop_modern_villa",
		"category": CATEGORY_PROPERTIES,
		"name": "Zenith Modern Minimalist Villa",
		"price": 820000,
		"upkeep": 11500,
		"happiness_bonus": 30,
		"desc": "An architectural marvel with floor-to-ceiling glass walls, warm timber soffits, and a luminous infinity pool.",
		"image_path": "res://assets/items/properties/prop_modern_villa.jpg",
		"min_age": 18
	},
	"prop_ranch": {
		"id": "prop_ranch",
		"category": CATEGORY_PROPERTIES,
		"name": "Rolling Hills Country Ranch",
		"price": 1100000,
		"upkeep": 14000,
		"happiness_bonus": 33,
		"desc": "An expansive rural sanctuary with wooden red barn, pastures, grazing animals, and endless golden sunset vistas.",
		"image_path": "res://assets/items/properties/prop_ranch.jpg",
		"min_age": 18
	},
	"prop_beachfront": {
		"id": "prop_beachfront",
		"category": CATEGORY_PROPERTIES,
		"name": "Pacific Crest Beach House",
		"price": 1450000,
		"upkeep": 18500,
		"happiness_bonus": 36,
		"desc": "A modern oceanfront villa directly on soft golden sand with a sundeck, swimming pool, and swaying palms.",
		"image_path": "res://assets/items/properties/prop_beachfront.jpg",
		"min_age": 18
	},
	"prop_penthouse": {
		"id": "prop_penthouse",
		"category": CATEGORY_PROPERTIES,
		"name": "Skyline Sky-Villa Penthouse",
		"price": 2100000,
		"upkeep": 25000,
		"happiness_bonus": 40,
		"desc": "The pinnacle of cosmopolitan prestige. Rooftop panoramic views, private heated infinity spa, and 24/7 concierge.",
		"image_path": "res://assets/items/properties/prop_penthouse.jpg",
		"min_age": 21
	},
	"prop_cyber_mansion": {
		"id": "prop_cyber_mansion",
		"category": CATEGORY_PROPERTIES,
		"name": "Neo-Tech Smart Manor",
		"price": 3200000,
		"upkeep": 36000,
		"happiness_bonus": 44,
		"desc": "A fortified architectural estate featuring drone landing pads, quantum-encrypted security gates, and indoor atrium.",
		"image_path": "res://assets/items/properties/prop_cyber_mansion.jpg",
		"min_age": 21
	},
	"prop_chateau": {
		"id": "prop_chateau",
		"category": CATEGORY_PROPERTIES,
		"name": "Grand Chateau & Vineyard",
		"price": 4800000,
		"upkeep": 52000,
		"happiness_bonus": 48,
		"desc": "A historic French stone castle with stone towers, sprawling vineyard terraces, hedge mazes, and marble fountains.",
		"image_path": "res://assets/items/properties/prop_chateau.jpg",
		"min_age": 21
	},
	"prop_private_island": {
		"id": "prop_private_island",
		"category": CATEGORY_PROPERTIES,
		"name": "Emerald Atoll Private Island",
		"price": 9500000,
		"upkeep": 85000,
		"happiness_bonus": 55,
		"desc": "A private tropical island surrounded by turquoise waters, with overwater thatch bungalows, private pier, and beach firepit.",
		"image_path": "res://assets/items/properties/prop_private_island.jpg",
		"min_age": 21
	},
	"prop_orbital": {
		"id": "prop_orbital",
		"category": CATEGORY_PROPERTIES,
		"name": "High-Orbit Luxury Satellite Suite",
		"price": 25000000,
		"upkeep": 220000,
		"happiness_bonus": 65,
		"desc": "The ultimate expression of planetary wealth. A private orbital space station suite with panoramic glass observation lounge.",
		"image_path": "res://assets/items/properties/prop_orbital.jpg",
		"min_age": 21
	}
}

static func get_item(item_id: String) -> Dictionary:
	return ITEMS.get(item_id, {}).duplicate(true)

static func get_items_by_category(category: String) -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for key in ITEMS.keys():
		var it: Dictionary = ITEMS[key]
		if it.get("category", "") == category:
			list.append(it.duplicate(true))
	list.sort_custom(func(a, b): return int(a.get("price", 0)) < int(b.get("price", 0)))
	return list

static func get_category_display_title(category: String) -> String:
	match category:
		CATEGORY_CARS:
			return "🚗 APEX CYBER MOTORS • CAR DEALERSHIP"
		CATEGORY_MOTORCYCLES:
			return "🏍️ NEON SPEED CYCLES • MOTORCYCLE SHOWROOM"
		CATEGORY_PROPERTIES:
			return "🏠 METRO PRIME REALTY • PROPERTY BROKERAGE"
		_:
			return "COMMERCIAL MARKETPLACE"

static func get_category_subtitle(category: String) -> String:
	match category:
		CATEGORY_CARS:
			return "Acquire personal automobiles for swift transit, personal prestige, and weekend joyrides."
		CATEGORY_MOTORCYCLES:
			return "Feel the open rush of two-wheeled performance, agility, and street rebellion."
		CATEGORY_PROPERTIES:
			return "Invest in luxury real estate, escape landlord rent, and build long-term generational equity."
		_:
			return "Browse luxury and commercial goods available for acquisition."

static func can_afford(player_data: Node, price: int) -> bool:
	var total_funds: int = player_data.money + player_data.bank_savings
	return total_funds >= price

static func buy_asset(player_data: Node, item_id: String) -> Dictionary:
	if not ITEMS.has(item_id):
		return {"success": false, "message": "Item not found in catalog."}
	
	var item: Dictionary = ITEMS[item_id]
	var price: int = int(item.get("price", 0))
	var min_age: int = int(item.get("min_age", 18))

	if player_data.age < min_age:
		return {
			"success": false,
			"message": "Legal age requirement not met. You must be at least %d years old to purchase this asset." % min_age
		}

	var total_funds: int = player_data.money + player_data.bank_savings
	if total_funds < price:
		return {
			"success": false,
			"message": "Insufficient funds. You require $%d (Total available: $%d)." % [price, total_funds]
		}

	# Debit funds: Prefer cash first, then draw remainder from bank savings
	if player_data.money >= price:
		player_data.money -= price
	else:
		var remainder: int = price - player_data.money
		player_data.money = 0
		player_data.bank_savings -= remainder

	var instance_id: String = "%s_%d_%d" % [item_id, player_data.age, randi() % 10000]
	var new_asset: Dictionary = {
		"instance_id": instance_id,
		"item_id": item_id,
		"category": str(item.get("category", "")),
		"name": str(item.get("name", "")),
		"purchase_price": price,
		"current_value": price,
		"purchase_age": player_data.age,
		"condition": 100,
		"image_path": str(item.get("image_path", "")),
		"upkeep": int(item.get("upkeep", 0)),
		"happiness_bonus": int(item.get("happiness_bonus", 5)),
		"last_used_age": -1
	}

	player_data.owned_assets.append(new_asset)
	player_data.happiness = mini(100, player_data.happiness + int(item.get("happiness_bonus", 10)))

	return {
		"success": true,
		"message": "Congratulations! You purchased %s for $%d." % [new_asset["name"], price],
		"asset": new_asset
	}

static func sell_asset(player_data: Node, instance_id: String) -> Dictionary:
	for i in range(player_data.owned_assets.size() - 1, -1, -1):
		var asset: Dictionary = player_data.owned_assets[i]
		if asset.get("instance_id", "") == instance_id:
			var sale_price: int = int(asset.get("current_value", asset.get("purchase_price", 0)))
			player_data.money += sale_price
			player_data.owned_assets.remove_at(i)
			return {
				"success": true,
				"message": "Sold %s for $%d." % [asset.get("name", "Asset"), sale_price],
				"sale_price": sale_price
			}
	return {"success": false, "message": "Asset not found in ownership portfolio."}

static func use_asset(player_data: Node, instance_id: String) -> Dictionary:
	for asset in player_data.owned_assets:
		if asset.get("instance_id", "") == instance_id:
			if int(asset.get("last_used_age", -1)) == player_data.age:
				return {
					"success": false,
					"message": "You already enjoyed your %s this year. Available again next year." % asset.get("name", "asset")
				}
			asset["last_used_age"] = player_data.age
			var cat: String = str(asset.get("category", ""))
			var bonus: int = int(asset.get("happiness_bonus", 5))
			player_data.happiness = mini(100, player_data.happiness + bonus)
			var action_desc := ""
			if cat in [CATEGORY_CARS, CATEGORY_MOTORCYCLES]:
				action_desc = "You took your %s out for an exhilarating joyride! Happiness +%d%%." % [asset.get("name", "ride"), bonus]
			else:
				action_desc = "You spent a serene, luxurious weekend relaxing at your %s! Happiness +%d%%." % [asset.get("name", "residence"), bonus]
			return {
				"success": true,
				"message": action_desc
			}
	return {"success": false, "message": "Asset not found."}

static func process_yearly_assets(player_data: Node) -> Array[String]:
	var logs: Array[String] = []
	for asset in player_data.owned_assets:
		var cat: String = str(asset.get("category", ""))
		var upkeep: int = int(asset.get("upkeep", 0))

		# 1. Maintenance / Upkeep auto-debit
		if upkeep > 0:
			if player_data.bank_savings >= upkeep:
				player_data.bank_savings -= upkeep
			elif player_data.money >= upkeep:
				player_data.money -= upkeep
			else:
				# Cannot pay upkeep -> condition drops
				asset["condition"] = maxi(10, int(asset.get("condition", 100)) - 15)
				logs.append("⚠️ Maintenance Neglect: You lacked sufficient funds to service your %s ($%d upkeep). Its condition deteriorated." % [asset.get("name", "asset"), upkeep])

		# 2. Value adjustments (Vehicles depreciate ~6%, Real estate appreciates ~2%)
		var cur_val: int = int(asset.get("current_value", asset.get("purchase_price", 0)))
		var orig_price: int = int(asset.get("purchase_price", cur_val))
		if cat in [CATEGORY_CARS, CATEGORY_MOTORCYCLES]:
			var floor_val: int = int(orig_price * 0.20)
			var dep: int = int(cur_val * 0.06)
			asset["current_value"] = maxi(floor_val, cur_val - dep)
		elif cat == CATEGORY_PROPERTIES:
			var app: int = int(cur_val * 0.02)
			asset["current_value"] = cur_val + app

	return logs
