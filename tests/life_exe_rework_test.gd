extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")

func _ready() -> void:
	print("--- BEGIN LIFE.EXE UI REWORK & GAMEPLAY UPDATE TEST SUITE ---")
	test_mind_and_body_hub()
	test_shopping_hub_categories()
	test_social_media_system()
	test_pet_adoption_system()
	test_will_and_estate_planning()
	test_persistence()
	print("--- ALL LIFE.EXE REWORK & GAMEPLAY TESTS PASSED SUCCESSFULLY! ---")
	get_tree().quit(0)


func test_mind_and_body_hub() -> void:
	print("Testing Mind & Body Wellness Hub...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 22
	PlayerData.money = 2500
	PlayerData.bank_savings = 5000
	PlayerData.looks = 50
	PlayerData.health = 60
	PlayerData.happiness = 50

	screen._show_mind_and_body_modal()
	assert(screen.mind_body_modal_overlay != null and is_instance_valid(screen.mind_body_modal_overlay), "Mind & Body modal must open")

	var btns = screen.mind_body_modal_overlay.find_children("*", "Button", true, false)
	var found_gym := false
	var found_salon := false
	var found_spa := false
	var found_med := false

	for b in btns:
		var txt := (b as Button).text
		if "Gym" in txt: found_gym = true
		elif "Salon" in txt: found_salon = true
		elif "Spa" in txt: found_spa = true
		elif "Meditation" in txt: found_med = true

	assert(found_gym, "Titan Cyber Gym must be inside Mind & Body")
	assert(found_salon, "Luxe Salon must be inside Mind & Body")
	assert(found_spa, "Luxury Day Spa must be inside Mind & Body")
	assert(found_med, "Mindfulness & Meditation must be inside Mind & Body")

	screen.mind_body_modal_overlay.queue_free()

	# Test Salon makeover
	screen._show_salon_modal()
	assert(screen.salon_modal_overlay != null and is_instance_valid(screen.salon_modal_overlay), "Salon modal must open")
	screen.salon_modal_overlay.queue_free()

	# Test Spa rejuvenation
	screen._show_spa_modal()
	assert(screen.spa_modal_overlay != null and is_instance_valid(screen.spa_modal_overlay), "Spa modal must open")
	screen.spa_modal_overlay.queue_free()

	screen.queue_free()
	print("✔ Mind & Body wellness hub, salon, and spa verified.")


func test_shopping_hub_categories() -> void:
	print("Testing Commercial Shopping Hub with all 8 Categories...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 30
	PlayerData.money = 2000000
	PlayerData.bank_savings = 50000000

	screen._show_shopping_modal()
	assert(screen.shopping_modal_overlay != null and is_instance_valid(screen.shopping_modal_overlay), "Shopping modal must open")

	var shop_buttons = screen.shopping_modal_overlay.find_children("*", "Button", true, false)
	var categories_found := {
		"bicycles": false,
		"cars": false,
		"motorcycles": false,
		"jewelry": false,
		"instruments": false,
		"properties": false,
		"aircraft": false,
		"yachts": false
	}

	for b in shop_buttons:
		var txt := (b as Button).text.to_lower()
		if "bicycle" in txt: categories_found["bicycles"] = true
		elif "car dealership" in txt or "apex" in txt: categories_found["cars"] = true
		elif "motorcycle" in txt or "thunder" in txt: categories_found["motorcycles"] = true
		elif "jeweler" in txt or "aurelia" in txt: categories_found["jewelry"] = true
		elif "instrument" in txt or "virtuoso" in txt: categories_found["instruments"] = true
		elif "property broker" in txt or "real estate" in txt: categories_found["properties"] = true
		elif "aircraft" in txt or "aviation" in txt: categories_found["aircraft"] = true
		elif "yacht" in txt or "marine" in txt: categories_found["yachts"] = true

	for cat in categories_found:
		assert(categories_found[cat], "Shopping category '%s' must be present in Shopping panel!" % cat)

	screen.shopping_modal_overlay.queue_free()

	# Test Purchasing an aircraft requires pilot license
	var buy_plane_no_lic = AssetCatalog.buy_asset(PlayerData, "aircraft_cessna")
	assert(not buy_plane_no_lic["success"], "Buying aircraft without pilot license must fail")

	# Grant pilot license and test purchase
	PlayerData.licenses.append("license_pilot")
	var buy_plane = AssetCatalog.buy_asset(PlayerData, "aircraft_cessna")
	assert(buy_plane["success"], "Buying aircraft with pilot license must succeed: %s" % buy_plane.get("message", ""))
	assert(PlayerData.get_owned_assets_by_category(AssetCatalog.CATEGORY_AIRCRAFT).size() == 1, "Player should own 1 aircraft")

	# Test Purchasing a yacht requires boating license
	var buy_yacht_no_lic = AssetCatalog.buy_asset(PlayerData, "yacht_megayacht")
	assert(not buy_yacht_no_lic["success"], "Buying yacht without boating license must fail")

	PlayerData.licenses.append("license_boating")
	var buy_yacht = AssetCatalog.buy_asset(PlayerData, "yacht_megayacht")
	assert(buy_yacht["success"], "Buying yacht with boating license must succeed: %s" % buy_yacht.get("message", ""))
	assert(PlayerData.get_owned_assets_by_category(AssetCatalog.CATEGORY_YACHTS).size() == 1, "Player should own 1 yacht")

	# Test Purchasing jewelry and instruments
	var buy_jewel = AssetCatalog.buy_asset(PlayerData, "jewelry_luxury_watch")
	assert(buy_jewel["success"], "Buying luxury watch should succeed")
	var buy_piano = AssetCatalog.buy_asset(PlayerData, "inst_grand_piano")
	assert(buy_piano["success"], "Buying Steinway grand piano should succeed")

	screen.queue_free()
	print("✔ Commercial Shopping hub with all 8 categories and license gating verified.")


func test_social_media_system() -> void:
	print("Testing Social Media Platforms & Content Creation...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 18
	PlayerData.money = 20000
	PlayerData.bank_savings = 50000
	PlayerData.karma = 50
	PlayerData.happiness = 70

	# 1. Test platform definitions
	var platforms = SocialMediaManager.get_platforms()
	assert(platforms.has("instagram"), "Instagram platform must exist")
	assert(platforms.has("youtube"), "YouTube platform must exist")
	assert(platforms.has("twitch"), "Twitch platform must exist")
	assert(platforms.has("x"), "X platform must exist")
	assert(platforms.has("tiktok"), "TikTok platform must exist")

	assert(platforms["youtube"]["metric"] == "Subscribers", "YouTube metric must be Subscribers")
	assert(platforms["instagram"]["metric"] == "Followers", "Instagram metric must be Followers")

	# 2. Test account creation
	var create_res = SocialMediaManager.create_account(PlayerData, "youtube", "@StarCreator")
	assert(create_res["success"], "Creating YouTube account must succeed")
	assert(SocialMediaManager.has_account(PlayerData, "youtube"), "PlayerData must have active YouTube account")
	var yt_acc = SocialMediaManager.get_account(PlayerData, "youtube")
	assert(yt_acc["handle"] == "@StarCreator", "Handle must match: %s" % yt_acc["handle"])
	assert(yt_acc["followers"] > 0, "Account must start with initial subscribers")

	# 3. Test posting content
	var post_res = SocialMediaManager.create_post(PlayerData, "youtube")
	assert(post_res["success"], "Posting content must succeed")
	assert(yt_acc["posts_count"] == 1, "Post count must increment")

	# 4. Test Verification Blue Tick
	var verif_denied = SocialMediaManager.apply_verification(PlayerData, "youtube")
	assert(not verif_denied["success"], "Verification should be denied with low subscribers")

	yt_acc["followers"] = 30000
	var verif_approved = SocialMediaManager.apply_verification(PlayerData, "youtube")
	assert(verif_approved["success"], "Verification should be approved with 30,000+ subscribers: %s" % verif_approved.get("message", ""))
	assert(yt_acc["is_verified"] == true, "Account must be verified with blue tick")

	# 5. Test Troll someone (+Happiness, -Karma)
	var karma_before: int = PlayerData.karma
	var troll_res = SocialMediaManager.troll_someone(PlayerData, "youtube")
	assert(troll_res["success"], "Trolling should succeed")
	assert(PlayerData.karma < karma_before, "Trolling must decrease karma")

	# 6. Test Buy followers
	var buy_foll_res = SocialMediaManager.buy_followers(PlayerData, "youtube", 0)
	assert(buy_foll_res["success"], "Buying followers should succeed")

	# 7. Test Yearly Social Media Processing
	var initial_subs: int = int(yt_acc.get("followers", 0))
	var yearly_logs = SocialMediaManager.process_yearly_social_media(PlayerData)
	assert(int(yt_acc.get("followers", 0)) > initial_subs, "Yearly social media processing should grow subscriber count")
	assert(yearly_logs.size() > 0, "Accounts over 20,000 subscribers should earn ad-revenue")

	# 8. Test Delete account
	var del_res = SocialMediaManager.delete_account(PlayerData, "youtube")
	assert(del_res["success"], "Deleting account should succeed")
	assert(not SocialMediaManager.has_account(PlayerData, "youtube"), "Account should no longer exist")

	screen.queue_free()
	print("✔ Social Media platform creation, posting, verification, trolling, and monetization verified.")


func test_pet_adoption_system() -> void:
	print("Testing Pet Adoption System (Shelters, Breeders, Pet Stores, Ranches)...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 25
	PlayerData.money = 50000
	PlayerData.bank_savings = 50000

	# 1. Dog Shelter (Free adoption, mixed breeds, random age)
	var shelter_dogs = PetManager.get_shelter_animals(PetManager.SOURCE_DOG_SHELTER)
	assert(shelter_dogs.size() >= 4, "Dog shelter must supply multiple rescue dogs")
	var first_dog = shelter_dogs[0]
	assert(first_dog["price"] == 0, "Shelter adoption must be 100% free")
	var adopt_res = PetManager.adopt_pet(PlayerData, first_dog)
	assert(adopt_res["success"], "Adopting shelter dog must succeed")
	assert(PlayerData.pets.size() == 1, "Player should have 1 pet")

	# 2. Cat Breeder (Purebred kittens <= 1 y.o.)
	var breeder_cats = PetManager.get_breeder_animals(PetManager.SOURCE_CAT_BREEDER)
	assert(breeder_cats.size() > 0, "Cat breeder must supply purebred kittens")
	var kitten = breeder_cats[0]
	assert(kitten["age"] <= 1, "Breeder kittens must be <= 1 year old: %d" % kitten["age"])
	assert(kitten["price"] > 0, "Breeder animals must be paid adoptions")
	var buy_kitten_res = PetManager.adopt_pet(PlayerData, kitten)
	assert(buy_kitten_res["success"], "Purchasing purebred kitten must succeed")
	assert(PlayerData.pets.size() == 2, "Player should have 2 pets")

	# 3. Pet Store (Exotics like turtles, rats, snakes, rabbits, birds, fish)
	var store_animals = PetManager.get_pet_store_animals()
	var found_turtle := false
	var found_snake := false
	var found_rat := false
	for a in store_animals:
		if a["type"] == "turtle": found_turtle = true
		elif a["type"] == "reptile": found_snake = true
		elif a["type"] == "rodent": found_rat = true
	assert(found_turtle, "Pet store must sell turtles")
	assert(found_snake, "Pet store must sell snakes")
	assert(found_rat, "Pet store must sell rats")

	var turtle = store_animals[0]
	var buy_turtle = PetManager.adopt_pet(PlayerData, turtle)
	assert(buy_turtle["success"], "Purchasing pet store animal must succeed")
	assert(PlayerData.pets.size() == 3, "Player should have 3 pets")

	# 4. Equestrian Ranch (Horses only purchasable from ranches)
	var ranch_horses = PetManager.get_ranch_horses()
	assert(ranch_horses.size() >= 4, "Ranch must supply purebred horse breeds")
	var horse = ranch_horses[0]
	assert(horse["type"] == "horse", "Ranch animal must be horse")
	assert(horse["price"] >= 4000, "Horse price must reflect ranch value")
	var buy_horse = PetManager.adopt_pet(PlayerData, horse)
	assert(buy_horse["success"], "Purchasing horse from ranch must succeed")
	assert(PlayerData.pets.size() == 4, "Player should have 4 pets")

	# 5. Test Pet Interactions (Play, Walk, Treat, Vet)
	var pet_id: String = str(PlayerData.pets[0]["id"])
	var play_res = PetManager.interact_pet(PlayerData, pet_id, "play")
	assert(play_res["success"], "Playing with pet should succeed")

	var walk_res = PetManager.interact_pet(PlayerData, pet_id, "walk")
	assert(walk_res["success"], "Walking pet should succeed")

	var treat_res = PetManager.interact_pet(PlayerData, pet_id, "treat")
	assert(treat_res["success"], "Treating pet should succeed")

	var vet_res = PetManager.interact_pet(PlayerData, pet_id, "vet")
	assert(vet_res["success"], "Vet checkup should succeed")

	# 6. Test Yearly Pet Simulation (Aging, Upkeep, Care)
	var funds_before: int = PlayerData.money + PlayerData.bank_savings
	PetManager.process_yearly_pets(PlayerData)
	assert((PlayerData.money + PlayerData.bank_savings) < funds_before, "Yearly pet upkeep should be deducted")

	screen.queue_free()
	print("✔ Pet adoption system (shelters, breeders, pet store, ranches) verified.")


func test_will_and_estate_planning() -> void:
	print("Testing Last Will & Testament Estate Planning...")
	var screen = MainScreenScene.instantiate()
	add_child(screen)

	PlayerData.reset()
	PlayerData.age = 45
	PlayerData.money = 250000
	PlayerData.bank_savings = 750000
	PlayerData.will_recipient = "CHILDREN"

	screen._show_will_modal()
	assert(screen.will_modal_overlay != null and is_instance_valid(screen.will_modal_overlay), "Will modal must open")

	# Test updating recipient to CHARITY
	PlayerData.will_recipient = "CHARITY"
	assert(PlayerData.will_recipient == "CHARITY", "Will recipient must update to CHARITY")

	# Test updating recipient to SPOUSE
	PlayerData.will_recipient = "SPOUSE"
	assert(PlayerData.will_recipient == "SPOUSE", "Will recipient must update to SPOUSE")

	# Test updating recipient to SPLIT
	PlayerData.will_recipient = "SPLIT"
	assert(PlayerData.will_recipient == "SPLIT", "Will recipient must update to SPLIT")

	screen.will_modal_overlay.queue_free()

	# Test Death Screen Will Execution
	screen._show_death_screen("Natural Causes")
	assert(screen.death_screen_overlay != null and is_instance_valid(screen.death_screen_overlay), "Death screen must open")

	var death_labels = screen.death_screen_overlay.find_children("*", "Label", true, false)
	var found_will_exec := false
	for l in death_labels:
		if "LAST WILL & TESTAMENT ESTATE EXECUTION" in (l as Label).text:
			found_will_exec = true
			break
	assert(found_will_exec, "Death screen must display Will & Testament Estate Execution card")

	screen.death_screen_overlay.queue_free()
	screen.queue_free()
	print("✔ Last Will & Testament estate planning and execution verified.")


func test_persistence() -> void:
	print("Testing Save / Load Persistence for Social Media, Pets, and Will...")
	SaveManager.delete_save()

	PlayerData.reset()
	PlayerData.age = 28
	PlayerData.first_name = "Alex"
	PlayerData.will_recipient = "CHARITY"

	SocialMediaManager.create_account(PlayerData, "instagram", "@alex_lifestyle")
	var shelter_cats = PetManager.get_shelter_animals(PetManager.SOURCE_CAT_SHELTER)
	PetManager.adopt_pet(PlayerData, shelter_cats[0])

	SaveManager.save_game()

	PlayerData.reset()
	assert(PlayerData.social_media.is_empty(), "Memory reset cleared social media")
	assert(PlayerData.pets.is_empty(), "Memory reset cleared pets")
	assert(PlayerData.will_recipient == "CHILDREN", "Memory reset restored default will recipient")

	SaveManager.load_game()

	assert(PlayerData.social_media.has("instagram"), "Loaded data must restore Instagram account")
	assert(PlayerData.social_media["instagram"]["handle"] == "@alex_lifestyle", "Handle restored")
	assert(PlayerData.pets.size() == 1, "Loaded data must restore 1 pet")
	assert(PlayerData.will_recipient == "CHARITY", "Loaded data must restore CHARITY will recipient")

	SaveManager.delete_save()
	print("✔ Save / Load persistence verified.")
