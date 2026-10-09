class_name AssetCatalog
extends RefCounted

const CATEGORY_BICYCLES := "bicycles"
const CATEGORY_CARS := "cars"
const CATEGORY_MOTORCYCLES := "motorcycles"
const CATEGORY_JEWELRY := "jewelry"
const CATEGORY_INSTRUMENTS := "instruments"
const CATEGORY_PROPERTIES := "properties"
const CATEGORY_AIRCRAFT := "aircraft"
const CATEGORY_YACHTS := "yachts"
const CATEGORY_FIREARMS := "firearms"

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
	},
	# =========================================================================
	# 🚲 BICYCLES (Bicycle Category)
	# =========================================================================
	"bike_commuter": {
		"id": "bike_commuter",
		"category": CATEGORY_BICYCLES,
		"name": "Vintage Urban Commuter Bike",
		"price": 240,
		"upkeep": 0,
		"happiness_bonus": 4,
		"desc": "A timeless 3-speed steel city cruiser with a front basket and bell. Perfect for sunny rides through the neighborhood.",
		"image_path": "",
		"min_age": 6
	},
	"bike_mountain": {
		"id": "bike_mountain",
		"category": CATEGORY_BICYCLES,
		"name": "Apex Trail Mountain Bike",
		"price": 680,
		"upkeep": 0,
		"happiness_bonus": 7,
		"desc": "Rugged dual-suspension trail bike equipped with hydraulic disc brakes and knobby off-road tires.",
		"image_path": "",
		"min_age": 10
	},
	"bike_road": {
		"id": "bike_road",
		"category": CATEGORY_BICYCLES,
		"name": "Aero Carbon Racing Bike",
		"price": 2600,
		"upkeep": 40,
		"happiness_bonus": 12,
		"desc": "Ultra-lightweight aerodynamic carbon fiber road bike designed for blistering highway sprints and endurance racing.",
		"image_path": "",
		"min_age": 14
	},
	"bike_cargo_ev": {
		"id": "bike_cargo_ev",
		"category": CATEGORY_BICYCLES,
		"name": "Volt Cargo Electric e-Bike",
		"price": 4400,
		"upkeep": 80,
		"happiness_bonus": 16,
		"desc": "High-torque pedal-assist electric cargo bike with integrated lithium battery and heavy-duty utility carrier.",
		"image_path": "",
		"min_age": 14
	},
	# =========================================================================
	# 💎 JEWELRY (Jewelers)
	# =========================================================================
	"jewelry_silver_ring": {
		"id": "jewelry_silver_ring",
		"category": CATEGORY_JEWELRY,
		"name": "Engraved Sterling Silver Signet Ring",
		"price": 450,
		"upkeep": 0,
		"happiness_bonus": 5,
		"desc": "A solid sterling silver heirloom ring featuring subtle hand-chiseled detailing.",
		"image_path": "",
		"min_age": 14
	},
	"jewelry_pearl_necklace": {
		"id": "jewelry_pearl_necklace",
		"category": CATEGORY_JEWELRY,
		"name": "South Sea Cultured Pearl Necklace",
		"price": 1950,
		"upkeep": 0,
		"happiness_bonus": 10,
		"desc": "An elegant string of glowing iridescent cultured pearls finished with an 18k white gold clasp.",
		"image_path": "",
		"min_age": 16
	},
	"jewelry_diamond_bracelet": {
		"id": "jewelry_diamond_bracelet",
		"category": CATEGORY_JEWELRY,
		"name": "Platinum Diamond Tennis Bracelet",
		"price": 7800,
		"upkeep": 0,
		"happiness_bonus": 18,
		"desc": "A dazzling continuous band of brilliant-cut diamonds prong-set in pure platinum.",
		"image_path": "",
		"min_age": 18
	},
	"jewelry_luxury_watch": {
		"id": "jewelry_luxury_watch",
		"category": CATEGORY_JEWELRY,
		"name": "Geneva Tourbillon Chronometer Watch",
		"price": 28500,
		"upkeep": 250,
		"happiness_bonus": 26,
		"desc": "A masterwork Swiss mechanical timepiece with an open-heart tourbillon escapement and alligator leather strap.",
		"image_path": "",
		"min_age": 18
	},
	"jewelry_royal_tiara": {
		"id": "jewelry_royal_tiara",
		"category": CATEGORY_JEWELRY,
		"name": "Royal Emerald & Diamond Diadem",
		"price": 145000,
		"upkeep": 600,
		"happiness_bonus": 38,
		"desc": "An opulent museum-grade diadem crowned with Colombian emeralds and hundreds of pavé diamonds.",
		"image_path": "",
		"min_age": 18
	},
	# =========================================================================
	# 🎸 MUSICAL INSTRUMENTS (Music Stores)
	# =========================================================================
	"inst_acoustic_guitar": {
		"id": "inst_acoustic_guitar",
		"category": CATEGORY_INSTRUMENTS,
		"name": "Solid Spruce Acoustic Guitar",
		"price": 380,
		"upkeep": 0,
		"happiness_bonus": 6,
		"desc": "A resonant dreadnought acoustic guitar with warm spruce projection and smooth rosewood fretboard.",
		"image_path": "",
		"min_age": 8
	},
	"inst_electric_guitar": {
		"id": "inst_electric_guitar",
		"category": CATEGORY_INSTRUMENTS,
		"name": "Custom Sunburst Stratocaster",
		"price": 1850,
		"upkeep": 0,
		"happiness_bonus": 12,
		"desc": "An iconic electric guitar finished in vintage three-color sunburst with single-coil pickups and tremolo bridge.",
		"image_path": "",
		"min_age": 12
	},
	"inst_cello": {
		"id": "inst_cello",
		"category": CATEGORY_INSTRUMENTS,
		"name": "Handcrafted Master Cello",
		"price": 6400,
		"upkeep": 80,
		"happiness_bonus": 16,
		"desc": "Carved from European flamed maple with an ebony fingerboard, producing deep, haunting orchestral resonance.",
		"image_path": "",
		"min_age": 14
	},
	"inst_synthesizer": {
		"id": "inst_synthesizer",
		"category": CATEGORY_INSTRUMENTS,
		"name": "Vintage Analog Polyphonic Synthesizer",
		"price": 14000,
		"upkeep": 120,
		"happiness_bonus": 22,
		"desc": "A legendary vintage synth with voltage-controlled oscillators, analog ladder filters, and warm wooden side cheeks.",
		"image_path": "",
		"min_age": 16
	},
	"inst_grand_piano": {
		"id": "inst_grand_piano",
		"category": CATEGORY_INSTRUMENTS,
		"name": "Concert Grand Piano 'Imperial 97'",
		"price": 72000,
		"upkeep": 550,
		"happiness_bonus": 32,
		"desc": "The crown jewel of acoustic pianos. Handcrafted in Vienna with 97 keys and unmatched dynamic projection.",
		"image_path": "",
		"min_age": 16
	},
	# =========================================================================
	# ✈️ AIRPLANES & HELICOPTERS (Airplane & Helicopter Dealers)
	# =========================================================================
	"aircraft_cessna": {
		"id": "aircraft_cessna",
		"category": CATEGORY_AIRCRAFT,
		"name": "Skyhawk 172 Light Propeller Plane",
		"price": 185000,
		"upkeep": 9500,
		"happiness_bonus": 26,
		"desc": "A renowned four-seat single-engine high-wing aircraft. The gold standard for private cross-country flying.",
		"image_path": "",
		"min_age": 18
	},
	"aircraft_helicopter": {
		"id": "aircraft_helicopter",
		"category": CATEGORY_AIRCRAFT,
		"name": "RotorCraft 505 Executive Helicopter",
		"price": 1450000,
		"upkeep": 65000,
		"happiness_bonus": 38,
		"desc": "A high-visibility turbine rotorcraft with glass cockpit and leather cabin seating for executive hops.",
		"image_path": "",
		"min_age": 18
	},
	"aircraft_personal_jet": {
		"id": "aircraft_personal_jet",
		"category": CATEGORY_AIRCRAFT,
		"name": "Aero Vision SF50 Personal Light Jet",
		"price": 2950000,
		"upkeep": 135000,
		"happiness_bonus": 48,
		"desc": "A revolutionary carbon-fiber single-engine personal jet capable of cruising at 28,000 feet in whisper-quiet luxury.",
		"image_path": "",
		"min_age": 18
	},
	"aircraft_business_jet": {
		"id": "aircraft_business_jet",
		"category": CATEGORY_AIRCRAFT,
		"name": "Apex G650 Ultra Long-Range Private Jet",
		"price": 48000000,
		"upkeep": 1600000,
		"happiness_bonus": 65,
		"desc": "The pinnacle of private aviation. Intercontinental speed, master stateroom, conference lounge, and private flight crew.",
		"image_path": "",
		"min_age": 18
	},
	# =========================================================================
	# 🛥️ YACHTS & MARINE VESSELS (Yacht Dealers)
	# =========================================================================
	"yacht_speedboat": {
		"id": "yacht_speedboat",
		"category": CATEGORY_YACHTS,
		"name": "Veloce 24ft Twin-Turbo Speedboat",
		"price": 46000,
		"upkeep": 2800,
		"happiness_bonus": 16,
		"desc": "A sleek performance powerboat built for wakesurfing, waterskiing, and high-speed coastal cruising.",
		"image_path": "",
		"min_age": 18
	},
	"yacht_cruiser": {
		"id": "yacht_cruiser",
		"category": CATEGORY_YACHTS,
		"name": "Riviera 42ft Luxury Sport Cruiser",
		"price": 380000,
		"upkeep": 18500,
		"happiness_bonus": 28,
		"desc": "A twin-diesel express cabin cruiser with sunbathing deck, full galley, and sleeping quarters for weekend voyages.",
		"image_path": "",
		"min_age": 18
	},
	"yacht_flybridge": {
		"id": "yacht_flybridge",
		"category": CATEGORY_YACHTS,
		"name": "Perseo 76ft Flybridge Superyacht",
		"price": 2400000,
		"upkeep": 95000,
		"happiness_bonus": 42,
		"desc": "An Italian-designed luxury motor yacht with panoramic flybridge lounge, hydraulic swim platform, and VIP suites.",
		"image_path": "",
		"min_age": 18
	},
	"yacht_megayacht": {
		"id": "yacht_megayacht",
		"category": CATEGORY_YACHTS,
		"name": "Oceanic Sovereign 180ft Megayacht",
		"price": 34000000,
		"upkeep": 1250000,
		"happiness_bonus": 62,
		"desc": "A multi-deck floating palace featuring a helipad, infinity pool, beach club, cinema, and dedicated maritime crew.",
		"image_path": "",
		"min_age": 18
	},

	# =========================================================================
	# 🎯 FIREARMS & DEFENSE ARSENAL
	# =========================================================================
	"gun_pistol_compact": {
		"id": "gun_pistol_compact",
		"category": CATEGORY_FIREARMS,
		"name": "Compact 9mm Concealed Carry Pistol",
		"price": 650,
		"upkeep": 35,
		"happiness_bonus": 4,
		"desc": "A lightweight polymer striker-fired 9x19mm subcompact handgun with tritium night sights. Conceals cleanly inside an IWB holster for discreet personal defense.",
		"image_path": "res://assets/items/firearms/gun_pistol_compact.jpg",
		"min_age": 21
	},
	"gun_service_handgun": {
		"id": "gun_service_handgun",
		"category": CATEGORY_FIREARMS,
		"name": "Tactical Full-Frame Service Handgun",
		"price": 950,
		"upkeep": 50,
		"happiness_bonus": 5,
		"desc": "A military-grade 17-round full-size service pistol equipped with an undercut trigger guard, flared magwell, and an optic-ready slide.",
		"image_path": "res://assets/items/firearms/gun_service_handgun.jpg",
		"min_age": 21
	},
	"gun_magnum_revolver": {
		"id": "gun_magnum_revolver",
		"category": CATEGORY_FIREARMS,
		"name": ".357 Combat Magnum Revolver",
		"price": 1250,
		"upkeep": 60,
		"happiness_bonus": 6,
		"desc": "A satin stainless steel heavy frame revolver chambered in .357 Magnum with a smooth double-action trigger and custom textured walnut grips.",
		"image_path": "res://assets/items/firearms/gun_magnum_revolver.jpg",
		"min_age": 21
	},
	"gun_tactical_shotgun": {
		"id": "gun_tactical_shotgun",
		"category": CATEGORY_FIREARMS,
		"name": "12-Gauge Tactical Home Defense Shotgun",
		"price": 880,
		"upkeep": 45,
		"happiness_bonus": 5,
		"desc": "A rugged pump-action 12-gauge scattergun outfitted with an extended 8-round magazine tube, ghost ring sights, Picatinny heat shield, and breacher muzzle.",
		"image_path": "res://assets/items/firearms/gun_tactical_shotgun.jpg",
		"min_age": 21
	},
	"gun_defense_carbine": {
		"id": "gun_defense_carbine",
		"category": CATEGORY_FIREARMS,
		"name": "5.56mm Semi-Auto Patrol Carbine",
		"price": 1850,
		"upkeep": 90,
		"happiness_bonus": 7,
		"desc": "A modular, lightweight direct-impingement carbine featuring free-float M-LOK handguards, ambidextrous controls, and a parallax-free holographic weapon sight.",
		"image_path": "res://assets/items/firearms/gun_defense_carbine.jpg",
		"min_age": 21
	},
	"gun_custom_subgun": {
		"id": "gun_custom_subgun",
		"category": CATEGORY_FIREARMS,
		"name": "Personal Defense Weapon (PDW) 9mm",
		"price": 2400,
		"upkeep": 110,
		"happiness_bonus": 8,
		"desc": "A roller-delayed blowback sub-compact platform with collapsible stabilizing brace, ambidextrous selector, and quick-detach suppressor mount.",
		"image_path": "res://assets/items/firearms/gun_custom_subgun.jpg",
		"min_age": 21
	},
	"gun_precision_rifle": {
		"id": "gun_precision_rifle",
		"category": CATEGORY_FIREARMS,
		"name": ".308 Long-Range Match Precision Rifle",
		"price": 3600,
		"upkeep": 150,
		"happiness_bonus": 9,
		"desc": "A blueprint bolt-action marksman rifle bedded in an aerospace aluminum chassis with a 26-inch fluted match barrel and a variable 24x magnification scope.",
		"image_path": "res://assets/items/firearms/gun_precision_rifle.jpg",
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
		CATEGORY_BICYCLES:
			return "🚲 VELO CYCLES • BICYCLE EMPORIUM"
		CATEGORY_CARS:
			return "🚗 APEX CYBER MOTORS • CAR DEALERSHIP"
		CATEGORY_MOTORCYCLES:
			return "🏍️ NEON SPEED CYCLES • MOTORCYCLE SHOWROOM"
		CATEGORY_JEWELRY:
			return "💎 AURA & BRILLIANCE • HAUTE JEWELERS"
		CATEGORY_INSTRUMENTS:
			return "🎸 STRATOSPHERE SOUNDS • MUSIC STORE"
		CATEGORY_PROPERTIES:
			return "🏠 METRO PRIME REALTY • PROPERTY BROKERAGE"
		CATEGORY_AIRCRAFT:
			return "✈️ AERO LUXE FLIGHT • AIRCRAFT DEALERSHIP"
		CATEGORY_YACHTS:
			return "🛥️ OCEANIC HORIZON • YACHT & MARINE BROKERS"
		CATEGORY_FIREARMS:
			return "🎯 IRONCLAD DEFENSE • TACTICAL ARMORY & GUN STORE"
		_:
			return "COMMERCIAL MARKETPLACE"

static func get_category_subtitle(category: String) -> String:
	match category:
		CATEGORY_BICYCLES:
			return "Eco-friendly commuter bikes, rugged trail riders, aero racers, and electric cargo haulers."
		CATEGORY_CARS:
			return "Acquire personal automobiles for swift transit, personal prestige, and weekend joyrides."
		CATEGORY_MOTORCYCLES:
			return "Feel the open rush of two-wheeled performance, agility, and street rebellion."
		CATEGORY_JEWELRY:
			return "Acquire heirloom gemstones, luxury tourbillons, and platinum diamond jewelry."
		CATEGORY_INSTRUMENTS:
			return "Fine handcrafted guitars, concert pianos, analog synths, and orchestral strings."
		CATEGORY_PROPERTIES:
			return "Invest in luxury real estate, escape landlord rent, and build long-term generational equity."
		CATEGORY_AIRCRAFT:
			return "High-performance propeller aircraft, turbine helicopters, and intercontinental private jets."
		CATEGORY_YACHTS:
			return "Ocean power speedboats, luxury flybridge cruisers, and multi-deck sovereign megayachts."
		CATEGORY_FIREARMS:
			return "Licensed handguns, home defense shotguns, semi-auto patrol carbines, and precision marksman rifles."
		_:
			return "Browse luxury and commercial goods available for acquisition."

static func can_afford(player_data: Node, price: int) -> bool:
	var total_funds: int = player_data.money + player_data.bank_savings
	return total_funds >= price

static func can_purchase_asset(player_data: Node, item_id: String) -> Dictionary:
	if not ITEMS.has(item_id):
		return {"allowed": false, "reason": "Item not found in catalog."}

	var item: Dictionary = ITEMS[item_id]
	var category: String = str(item.get("category", ""))
	var price: int = int(item.get("price", 0))
	var min_age: int = int(item.get("min_age", 18))

	if player_data.age < min_age:
		return {
			"allowed": false,
			"reason": "Legal age requirement not met. You must be at least %d years old to purchase this asset." % min_age
		}

	# Vehicle Driver/Operator License Verification
	if category == CATEGORY_CARS and not player_data.has_license("license_car"):
		return {
			"allowed": false,
			"reason": "Requires Driver's License (Class C). Take the qualification exam in Activities -> Licensing first!"
		}
	if category == CATEGORY_MOTORCYCLES and not player_data.has_license("license_motorcycle"):
		return {
			"allowed": false,
			"reason": "Requires Motorcycle Operator License (Class M). Take the qualification exam in Activities -> Licensing first!"
		}
	if category == CATEGORY_AIRCRAFT and not player_data.has_license("license_pilot"):
		return {
			"allowed": false,
			"reason": "Requires Private Pilot & Rotorcraft License. Take the flight certification exam in Activities -> Licensing first!"
		}
	if category == CATEGORY_YACHTS and not player_data.has_license("license_boating"):
		return {
			"allowed": false,
			"reason": "Requires Master Coastal Boater & Yachting License. Take the certification exam in Activities -> Licensing first!"
		}
	if category == CATEGORY_FIREARMS and not player_data.has_license("license_firearm"):
		return {
			"allowed": false,
			"reason": "Requires Concealed Carry & Tactical Firearms License. Obtain your state permit in Activities -> Licensing first!"
		}

	var total_funds: int = player_data.money + player_data.bank_savings
	if total_funds < price:
		return {
			"allowed": false,
			"reason": "Insufficient funds. You require $%d (Total available: $%d)." % [price, total_funds]
		}

	return {"allowed": true, "reason": "Eligible to purchase."}

static func buy_asset(player_data: Node, item_id: String) -> Dictionary:
	var eval := can_purchase_asset(player_data, item_id)
	if not bool(eval.get("allowed", false)):
		return {
			"success": false,
			"message": str(eval.get("reason", "Cannot purchase asset."))
		}

	var item: Dictionary = ITEMS[item_id]
	var price: int = int(item.get("price", 0))

	# Debit funds: Prefer cash first, then draw remainder from bank savings
	player_data.debit_funds(price)

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

	if str(item.get("category", "")) == CATEGORY_PROPERTIES:
		if player_data.has_method("add_milestone"):
			player_data.add_milestone("Purchased real estate: %s." % str(item.get("name", "Property")), player_data.age, "🏡")

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
			match cat:
				CATEGORY_BICYCLES:
					action_desc = "You went for an energizing ride on your %s through city greenways!" % asset.get("name", "bike")
				CATEGORY_CARS, CATEGORY_MOTORCYCLES:
					action_desc = "You took your %s out for an exhilarating joyride!" % asset.get("name", "ride")
				CATEGORY_JEWELRY:
					player_data.looks = mini(100, player_data.looks + 1)
					action_desc = "You wore your exquisite %s to an exclusive gala and turned every head in the room!" % asset.get("name", "jewelry")
				CATEGORY_INSTRUMENTS:
					player_data.smarts = mini(100, player_data.smarts + 1)
					action_desc = "You practiced complex musical compositions on your %s and mastered new rhythms!" % asset.get("name", "instrument")
				CATEGORY_AIRCRAFT:
					action_desc = "You piloted your %s high above the cloud line with complete freedom!" % asset.get("name", "aircraft")
				CATEGORY_YACHTS:
					action_desc = "You cruised aboard your %s across sparkling coastal waters!" % asset.get("name", "yacht")
				CATEGORY_FIREARMS:
					player_data.smarts = mini(100, player_data.smarts + 1)
					action_desc = "You ran tactical target transition and defensive handling drills at the range with your %s!" % asset.get("name", "firearm")
				_:
					action_desc = "You spent a serene, luxurious weekend relaxing at your %s!" % asset.get("name", "residence")
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
			elif player_data.get_available_funds() >= upkeep:
				player_data.debit_funds(upkeep)
			else:
				# Cannot pay upkeep -> condition drops
				asset["condition"] = maxi(10, int(asset.get("condition", 100)) - 15)
				logs.append("⚠️ Maintenance Neglect: You lacked sufficient funds to service your %s ($%d upkeep). Its condition deteriorated." % [asset.get("name", "asset"), upkeep])

		# 2. Value adjustments (Vehicles depreciate, real estate/fine art/jewelry appreciate, firearms hold strong value)
		var cur_val: int = int(asset.get("current_value", asset.get("purchase_price", 0)))
		var orig_price: int = int(asset.get("purchase_price", cur_val))
		if cat in [CATEGORY_CARS, CATEGORY_MOTORCYCLES]:
			var floor_val: int = int(orig_price * 0.20)
			var dep: int = int(cur_val * 0.06)
			asset["current_value"] = maxi(floor_val, cur_val - dep)
		elif cat == CATEGORY_BICYCLES:
			var floor_val: int = int(orig_price * 0.15)
			var dep: int = int(cur_val * 0.08)
			asset["current_value"] = maxi(floor_val, cur_val - dep)
		elif cat in [CATEGORY_AIRCRAFT, CATEGORY_YACHTS]:
			var floor_val: int = int(orig_price * 0.25)
			var dep: int = int(cur_val * 0.05)
			asset["current_value"] = maxi(floor_val, cur_val - dep)
		elif cat in [CATEGORY_JEWELRY, CATEGORY_INSTRUMENTS]:
			var app: int = int(cur_val * 0.01)
			asset["current_value"] = cur_val + app
		elif cat == CATEGORY_PROPERTIES:
			var app: int = int(cur_val * 0.02)
			asset["current_value"] = cur_val + app
		elif cat == CATEGORY_FIREARMS:
			var floor_val: int = int(orig_price * 0.75)
			var dep: int = int(cur_val * 0.02)
			asset["current_value"] = maxi(floor_val, cur_val - dep)

	return logs
