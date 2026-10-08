extends Node

func _ready() -> void:
	print("\n=======================================================")
	print("🧪 RUNNING VERIFICATION SUITE: FIREARMS, BUSINESSES & PETS")
	print("=======================================================\n")

	_test_expanded_businesses()
	_test_expanded_pets()
	_test_firearms_catalog_and_licensing()
	_test_firearms_exclusive_events()

	print("\n=======================================================")
	print("🎉 ALL TESTS PASSED SUCCESSFULLY! 100% VERIFIED!")
	print("=======================================================\n")
	get_tree().quit(0)

func _test_expanded_businesses() -> void:
	print("--- 1. Testing Expanded Businesses ---")
	var all_biz := BusinessManager.get_all_business_types()
	print("Total businesses defined: %d" % all_biz.size())
	assert(all_biz.size() >= 25, "Expected at least 25 businesses total")

	var fnb_biz := BusinessManager.get_businesses_in_category("fnb")
	var log_biz := BusinessManager.get_businesses_in_category("logistics")
	var nrg_biz := BusinessManager.get_businesses_in_category("energy")

	print("F&B Businesses count: %d" % fnb_biz.size())
	print("Logistics Businesses count: %d" % log_biz.size())
	print("Energy Businesses count: %d" % nrg_biz.size())

	assert(fnb_biz.size() >= 4, "Expected at least 4 F&B businesses")
	assert(log_biz.size() >= 4, "Expected at least 4 Logistics businesses")
	assert(nrg_biz.size() >= 4, "Expected at least 4 Energy businesses")

	# Check specific new business IDs
	var expected_ids := [
		"biz_artisan_bakery",
		"biz_fine_dining_bistro",
		"biz_craft_brewery",
		"biz_cargo_shipment",
		"biz_courier_dispatch",
		"biz_cold_chain_storage",
		"biz_offshore_wind",
		"biz_hydroelectric_plant",
		"biz_grid_battery_storage"
	]
	var found_ids: Array[String] = []
	for b in all_biz:
		found_ids.append(str(b.get("id", "")))

	for eid in expected_ids:
		assert(found_ids.has(eid), "Missing expected business ID: %s" % eid)
		print("  ✓ Business verified: %s" % eid)

func _test_expanded_pets() -> void:
	print("\n--- 2. Testing Expanded Pet Breeds ---")
	print("Dog breeds count: %d" % PetManager.DOG_BREEDS.size())
	print("Cat breeds count: %d" % PetManager.CAT_BREEDS.size())

	assert(PetManager.DOG_BREEDS.size() >= 24, "Expected at least 24 dog breeds")
	assert(PetManager.CAT_BREEDS.size() >= 24, "Expected at least 24 cat breeds")

	var breeder_dogs := PetManager.get_breeder_animals(PetManager.SOURCE_DOG_BREEDER)
	var breeder_cats := PetManager.get_breeder_animals(PetManager.SOURCE_CAT_BREEDER)

	assert(breeder_dogs.size() >= 24, "Breeder must list all dog breeds")
	assert(breeder_cats.size() >= 24, "Breeder must list all cat breeds")

	var shelter_dogs := PetManager.get_shelter_animals(PetManager.SOURCE_DOG_SHELTER)
	var shelter_cats := PetManager.get_shelter_animals(PetManager.SOURCE_CAT_SHELTER)

	assert(shelter_dogs.size() >= 4, "Shelter dogs generated")
	assert(shelter_cats.size() >= 4, "Shelter cats generated")

	print("  ✓ Dog and cat breeds verification passed.")

func _test_firearms_catalog_and_licensing() -> void:
	print("\n--- 3. Testing Firearms Catalog & Licensing ---")
	var firearms := AssetCatalog.get_items_by_category(AssetCatalog.CATEGORY_FIREARMS)
	print("Firearms in catalog: %d" % firearms.size())
	assert(firearms.size() >= 6, "Expected at least 6 firearms in catalog")

	PlayerData.reset()
	PlayerData.age = 22
	PlayerData.money = 5000
	PlayerData.bank_savings = 5000

	# 1. Attempt to purchase without license -> must fail
	assert(not PlayerData.has_license("license_firearm"), "Player should start without firearms license")
	var eval_unlicensed := AssetCatalog.can_purchase_asset(PlayerData, "gun_pistol_compact")
	assert(not bool(eval_unlicensed["allowed"]), "Should NOT allow purchase without license")
	print("  ✓ Purchase blocked when unlicensed: %s" % eval_unlicensed["reason"])

	# 2. Grant license -> purchase should succeed
	PlayerData.licenses.append("license_firearm")
	assert(PlayerData.has_license("license_firearm"), "Player now licensed")

	var eval_licensed := AssetCatalog.can_purchase_asset(PlayerData, "gun_pistol_compact")
	assert(bool(eval_licensed["allowed"]), "Should allow purchase with license and funds")

	var buy_res := AssetCatalog.buy_asset(PlayerData, "gun_pistol_compact")
	assert(bool(buy_res["success"]), "Firearm purchase succeeded")
	assert(PlayerData.has_firearm(), "PlayerData.has_firearm() must return true")
	assert(PlayerData.get_owned_firearms().size() == 1, "Must have 1 owned firearm")
	print("  ✓ Firearm purchased and added to assets: %s" % buy_res["asset"]["name"])

	# 3. Test asset use
	var inst_id: String = buy_res["asset"]["instance_id"]
	var use_res := AssetCatalog.use_asset(PlayerData, inst_id)
	assert(bool(use_res["success"]), "Using firearm asset should succeed")
	print("  ✓ Firearm practice at shooting range: %s" % use_res["message"])

func _test_firearms_exclusive_events() -> void:
	print("\n--- 4. Testing Firearms-Exclusive Violent Events ---")
	EventManager.load_events()

	var file := FileAccess.open("res://data/events/basic_events.json", FileAccess.READ)
	assert(file != null, "basic_events.json must load")
	var json_data = JSON.parse_string(file.get_as_text())
	assert(json_data is Array, "basic_events.json must be an Array")

	# Find violent events
	var violent_event_ids := [
		"event_armed_robbery_gunpoint",
		"event_home_invasion_armed",
		"event_intersection_carjacking",
		"event_stalker_blade_ambush",
		"event_active_shooter_defense"
	]
	var found_violent_count: int = 0
	for ev in json_data:
		var ev_id: String = str(ev.get("id", ""))
		if violent_event_ids.has(ev_id):
			found_violent_count += 1
			var conds: Dictionary = ev.get("conditions", {})
			assert(bool(conds.get("requires_firearm", false)), "Event %s must require firearm!" % ev_id)

			# Verify choices impact happiness negatively
			var choices: Array = ev.get("choices", [])
			assert(choices.size() >= 3, "Event %s must offer at least 3 choices" % ev_id)
			for ch in choices:
				var effs: Dictionary = ch.get("effects", {})
				if effs.has("happiness"):
					var hap_delta: int = int(effs["happiness"])
					assert(hap_delta < 0, "Choice '%s' in event %s must negatively impact happiness!" % [ch.get("text", ""), ev_id])

	assert(found_violent_count == 5, "All 5 violent events must exist in basic_events.json")
	print("  ✓ All 5 violent events verified with heavy negative happiness penalties.")

	# TEST GATING: Character WITHOUT firearm must NEVER see these events
	var unarmed_stats: Dictionary = {
		"health": 80,
		"happiness": 80,
		"smarts": 80,
		"looks": 80,
		"karma": 50,
		"has_firearm": false
	}
	for vid in violent_event_ids:
		var ev_match: Dictionary = {}
		for ev in json_data:
			if ev.get("id", "") == vid:
				ev_match = ev
				break
		var passes: bool = EventManager._passes_conditions(ev_match, unarmed_stats, [])
		assert(not passes, "Event %s MUST NOT pass conditions when character does NOT own a firearm!" % vid)

	var unarmed_defense_ev = EventManager.get_firearm_defense_event(25, [], unarmed_stats)
	assert(unarmed_defense_ev == null, "get_firearm_defense_event must return null for unarmed character")
	print("  ✓ Verified: Violent firearm events WILL NEVER SHOW when player does NOT own a firearm!")

	# TEST GATING: Character WITH firearm CAN receive these events
	var armed_stats: Dictionary = {
		"health": 80,
		"happiness": 80,
		"smarts": 80,
		"looks": 80,
		"karma": 50,
		"has_firearm": true
	}
	var armed_passes_count: int = 0
	for vid in violent_event_ids:
		var ev_match: Dictionary = {}
		for ev in json_data:
			if ev.get("id", "") == vid:
				ev_match = ev
				break
		if EventManager._passes_conditions(ev_match, armed_stats, []):
			armed_passes_count += 1

	assert(armed_passes_count == 5, "All 5 violent events must pass conditions when character OWNS a firearm!")
	var armed_defense_ev = EventManager.get_firearm_defense_event(25, [], armed_stats)
	assert(armed_defense_ev != null, "Armed character must be able to roll firearm defense events")
	print("  ✓ Verified: Armed character successfully rolls: '%s'" % armed_defense_ev.get("title", ""))
