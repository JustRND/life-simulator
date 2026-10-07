class_name AssetCatalog
extends RefCounted

const CATEGORY_CARS := "cars"
const CATEGORY_MOTORCYCLES := "motorcycles"
const CATEGORY_PROPERTIES := "properties"

const ITEMS := {
	# --- CARS ---
	"car_hatchback": {
		"id": "car_hatchback",
		"category": CATEGORY_CARS,
		"name": "Cyber Hatchback '98",
		"price": 3500,
		"upkeep": 350,
		"happiness_bonus": 5,
		"desc": "A trusty retro 5-door runabout. Affordable, fuel-efficient, and easy to maintain.",
		"image_path": "res://assets/items/cars/car_hatchback.jpg",
		"min_age": 16
	},
	"car_sedan": {
		"id": "car_sedan",
		"category": CATEGORY_CARS,
		"name": "Neo City Sedan",
		"price": 28000,
		"upkeep": 1400,
		"happiness_bonus": 12,
		"desc": "A sleek, whisper-quiet electric commuter sedan with autonomous cruise and neon cyan trim.",
		"image_path": "res://assets/items/cars/car_sedan.jpg",
		"min_age": 16
	},
	"car_sportscar": {
		"id": "car_sportscar",
		"category": CATEGORY_CARS,
		"name": "Apex GT Supercar",
		"price": 185000,
		"upkeep": 7500,
		"happiness_bonus": 28,
		"desc": "A blistering twin-turbo beast in fiery crimson. Turns heads and shatters 0-60 acceleration records.",
		"image_path": "res://assets/items/cars/car_sportscar.jpg",
		"min_age": 18
	},

	# --- MOTORCYCLES ---
	"moto_scooter": {
		"id": "moto_scooter",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Vespa Mint 50cc",
		"price": 1400,
		"upkeep": 150,
		"happiness_bonus": 4,
		"desc": "A charming mint-green city scooter. Zips through congested city traffic with vintage charm.",
		"image_path": "res://assets/items/motorcycles/moto_scooter.jpg",
		"min_age": 15
	},
	"moto_cruiser": {
		"id": "moto_cruiser",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Thunder Chopper V-Twin",
		"price": 12500,
		"upkeep": 800,
		"happiness_bonus": 14,
		"desc": "Heavy chrome, a rumbling twin engine, and tall ape-hangers. The quintessential sound of the open road.",
		"image_path": "res://assets/items/motorcycles/moto_cruiser.jpg",
		"min_age": 16
	},
	"moto_sportbike": {
		"id": "moto_sportbike",
		"category": CATEGORY_MOTORCYCLES,
		"name": "Kusanagi RX-9 Sportbike",
		"price": 34000,
		"upkeep": 2200,
		"happiness_bonus": 24,
		"desc": "High-tech neon cyber street racer. Aerodynamic carbon-fiber chassis with extreme cornering capabilities.",
		"image_path": "res://assets/items/motorcycles/moto_sportbike.jpg",
		"min_age": 18
	},

	# --- REAL ESTATE & PROPERTIES ---
	"prop_studio": {
		"id": "prop_studio",
		"category": CATEGORY_PROPERTIES,
		"name": "Downtown Studio Apartment",
		"price": 135000,
		"upkeep": 3200,
		"happiness_bonus": 10,
		"desc": "A vibrant modern loft situated above late-night ramen spots and illuminated cyber storefronts.",
		"image_path": "res://assets/items/properties/prop_studio.jpg",
		"min_age": 18
	},
	"prop_house": {
		"id": "prop_house",
		"category": CATEGORY_PROPERTIES,
		"name": "Suburban Family Residence",
		"price": 420000,
		"upkeep": 8400,
		"happiness_bonus": 22,
		"desc": "A picturesque two-story home with a manicured front lawn, driveway, and leafy tree in a peaceful suburb.",
		"image_path": "res://assets/items/properties/prop_house.jpg",
		"min_age": 18
	},
	"prop_penthouse": {
		"id": "prop_penthouse",
		"category": CATEGORY_PROPERTIES,
		"name": "Skyline Sky-Villa Penthouse",
		"price": 1850000,
		"upkeep": 28000,
		"happiness_bonus": 45,
		"desc": "The pinnacle of cosmopolitan prestige. Rooftop panoramic view, private heated infinity spa, and concierge.",
		"image_path": "res://assets/items/properties/prop_penthouse.jpg",
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
