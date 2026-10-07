extends Node

func _ready() -> void:
	print("--- BEGIN AFTERLIFE & KARMA TEST ---")
	
	# Test 1: Verify PlayerData initial state
	PlayerData.reset_player()
	assert(PlayerData.children.is_empty(), "Children should be empty on reset")
	assert(PlayerData.active_debuffs.is_empty(), "Debuffs should be empty on reset")
	assert(PlayerData.active_buffs.is_empty(), "Buffs should be empty on reset")
	print("✔ Test 1: Reset state verified")

	# Test 2: Verify Children addition and Living Check
	assert(not PlayerData.has_living_children(), "Should have no living children initially")
	var child1 := PlayerData.add_player_child("Sophia", "FEMALE", 5)
	assert(PlayerData.has_living_children(), "Should have living children after adding child")
	assert(PlayerData.get_living_children().size() == 1, "Should have 1 living child")
	assert(child1.name == "Sophia", "Child name matches")
	print("✔ Test 2: Children logic verified")

	# Test 3: Test Debuffs enforcement
	PlayerData.active_debuffs = ["health_cap_50", "stuck_happiness"]
	PlayerData.health = 80
	PlayerData.happiness = 90
	PlayerData.enforce_buffs_and_debuffs()
	assert(PlayerData.health <= 50, "Health must be capped at 50%% under health_cap_50 debuff")
	assert(PlayerData.happiness <= 15, "Happiness must be stuck <= 15%% under stuck_happiness debuff")
	print("✔ Test 3: Debuff enforcement verified (Health: %d, Happiness: %d)" % [PlayerData.health, PlayerData.happiness])

	# Test 4: Test Buffs enforcement
	PlayerData.active_debuffs.clear()
	PlayerData.active_buffs = ["super_smarts", "radiant_vitality", "blessed_mind", "divine_looks"]
	PlayerData.smarts = 40
	PlayerData.health = 30
	PlayerData.happiness = 20
	PlayerData.looks = 10
	PlayerData.enforce_buffs_and_debuffs()
	assert(PlayerData.smarts >= 100, "Smarts must be >= 100 under super_smarts buff")
	assert(PlayerData.health >= 85, "Health must be >= 85 under radiant_vitality buff")
	assert(PlayerData.happiness >= 80, "Happiness must be >= 80 under blessed_mind buff")
	assert(PlayerData.looks >= 90, "Looks must be >= 90 under divine_looks buff")
	print("✔ Test 4: Buff enforcement verified (Smarts: %d, Health: %d, Happiness: %d, Looks: %d)" % [
		PlayerData.smarts, PlayerData.health, PlayerData.happiness, PlayerData.looks
	])

	# Test 5: Reincarnation with Bad Karma (Forced Rebirth)
	var condemned_identity := {
		"first_name": "Karmic Sinner",
		"gender": "MALE",
		"birthplace": "Germany",
		"ethnicity": "white",
		"portrait_track": 0,
		"portrait_variant": 2
	}
	var test_debuffs := ["bad_stats", "no_parents", "crazy_debt"]
	PlayerData.start_reincarnated_life(condemned_identity, test_debuffs, [])
	assert(PlayerData.first_name == "Karmic Sinner", "Name updated")
	assert(PlayerData.active_debuffs == test_debuffs, "Debuffs saved")
	assert(not PlayerData.mother_alive and not PlayerData.father_alive, "Orphaned at birth debuff enforced")
	assert(PlayerData.debt >= 60000, "Crazy debt debuff enforced")
	assert(PlayerData.health <= 25 and PlayerData.smarts <= 25, "Bad stats debuff enforced")
	print("✔ Test 5: Reincarnated life under Bad Karma verified (Debt: $%d, Health: %d, Smarts: %d)" % [
		PlayerData.debt, PlayerData.health, PlayerData.smarts
	])

	# Test 6: Reincarnation with Good Karma (Blessed Rebirth)
	var blessed_identity := {
		"first_name": "Blessed Soul",
		"gender": "FEMALE",
		"birthplace": "Japan",
		"ethnicity": "asian",
		"portrait_track": 1,
		"portrait_variant": 3
	}
	var test_buffs := ["super_smarts", "silver_spoon", "golden_pedigree"]
	PlayerData.start_reincarnated_life(blessed_identity, [], test_buffs)
	assert(PlayerData.first_name == "Blessed Soul", "Name updated")
	assert(PlayerData.active_buffs == test_buffs, "Buffs saved")
	assert(PlayerData.money >= 100000, "Silver spoon buff gave money")
	assert(PlayerData.smarts >= 100, "Super smarts buff enforced")
	assert(PlayerData.mother_relationship == 100, "Golden pedigree buff enforced")
	print("✔ Test 6: Reincarnated life under Good Karma verified (Money: $%d, Smarts: %d)" % [
		PlayerData.money, PlayerData.smarts
	])

	# Test 7: Inheritance Takeover
	var parent_net_worth := 250000
	var heir := {
		"name": "Alexander",
		"gender": "MALE",
		"age": 22,
		"ethnicity": "white",
		"portrait_track": 0,
		"portrait_variant": 1,
		"health": 95,
		"happiness": 85,
		"smarts": 80,
		"looks": 75
	}
	PlayerData.takeover_as_child(heir, parent_net_worth)
	assert(PlayerData.first_name == "Alexander", "Took over as child Alexander")
	assert(PlayerData.age == 22, "Age is heir age (22)")
	assert(PlayerData.money == 250000, "Inherited money matches")
	assert(PlayerData.education_level == "High School Graduate", "Education matches adult child")
	assert(not PlayerData.is_dead, "Child is alive")
	print("✔ Test 7: Inheritance succession verified (Name: %s, Age: %d, Inherited: $%d)" % [
		PlayerData.first_name, PlayerData.age, PlayerData.money
	])

	# Test 8: Save and Load with Children & Modifiers
	PlayerData.add_player_child("Maya", "FEMALE", 2)
	PlayerData.active_buffs = ["super_smarts"]
	PlayerData.active_debuffs = ["health_cap_50"]
	SaveManager.save_game()
	
	# Clear and reload
	PlayerData.reset_player()
	assert(PlayerData.children.is_empty(), "Cleared before load")
	var loaded := SaveManager.load_game()
	assert(loaded, "Save game loaded successfully")
	assert(PlayerData.first_name == "Alexander", "Loaded correct player name")
	assert(PlayerData.children.size() == 1, "Loaded 1 child")
	assert(PlayerData.children[0].name == "Maya", "Loaded child name Maya")
	assert("super_smarts" in PlayerData.active_buffs, "Loaded super_smarts buff")
	assert("health_cap_50" in PlayerData.active_debuffs, "Loaded health_cap_50 debuff")
	print("✔ Test 8: Save & Load persistence verified")

	# Clean up save
	SaveManager.delete_save()

	# Test 9: Job requirements check qualitative reasons
	var test_moral_job := {
		"id": "monk",
		"title": "Spiritual Guide",
		"requirements": {"min_karma": 25}
	}
	var check_moral = JobManager.can_apply(test_moral_job, 25, {"karma": 0})
	assert(not check_moral.allowed, "Should reject application")
	assert("karma" not in check_moral.reason.to_lower(), "Reason must not expose karma: %s" % check_moral.reason)
	print("✔ Test 9: Job qualification reasons are qualitative and anonymous: '%s'" % check_moral.reason)

	# Test 10: AfterlifeMinigame instance and generation test
	var minigame_script = preload("res://scripts/minigames/afterlife_minigame.gd")
	var mg_bad = minigame_script.new()
	add_child(mg_bad)
	mg_bad.setup(-50, Callable())
	assert(mg_bad.is_condemned, "Should be condemned under negative karma")
	assert(mg_bad.rolled_debuffs.size() >= 1 and mg_bad.rolled_debuffs.size() <= 3, "Rolled 1-3 debuffs")
	assert(mg_bad.reborn_identity.has("first_name"), "Generated randomized identity")
	mg_bad.queue_free()
	
	var mg_good = minigame_script.new()
	add_child(mg_good)
	mg_good.setup(75, Callable())
	assert(not mg_good.is_condemned, "Should be blessed under positive karma")
	assert(mg_good.rolled_buffs.size() >= 1 and mg_good.rolled_buffs.size() <= 3, "Rolled 1-3 buffs")
	mg_good.queue_free()
	print("✔ Test 10: Afterlife minigame instantiation, debuff/buff rolling, and identity randomization verified")

	print("--- ALL 10 TESTS PASSED SUCCESSFULLY! ---")
	get_tree().quit(0)
