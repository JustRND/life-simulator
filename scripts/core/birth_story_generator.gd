extends RefCounted

const NameCatalog = preload("res://scripts/core/name_catalog.gd")

const PROFESSIONS := [
	"grocer", "elementary school teacher", "nurse", "accountant", "carpenter",
	"electrician", "police officer", "librarian", "journalist", "mechanic",
	"software engineer", "chef", "dentist", "architect", "firefighter",
	"pharmacist", "bus driver", "veterinarian", "photographer", "realtor",
	"plumber", "florist", "baker", "flight attendant", "graphic designer",
	"barista", "bank teller", "tailor", "paralegal", "postal worker"
]

const MONTH_DATA := [
	{"name": "January", "days": 31},
	{"name": "February", "days": 28},
	{"name": "March", "days": 31},
	{"name": "April", "days": 30},
	{"name": "May", "days": 31},
	{"name": "June", "days": 30},
	{"name": "July", "days": 31},
	{"name": "August", "days": 31},
	{"name": "September", "days": 30},
	{"name": "October", "days": 31},
	{"name": "November", "days": 30},
	{"name": "December", "days": 31}
]

const CONCEPTION_STORIES := [
	"I was an unexpected miracle after my parents spent five years trying and had nearly given up hope.",
	"My mother gave birth to me in a bathtub while soothing classical music was playing on the stereo.",
	"I was conceived on a spontaneous weekend road trip that my parents still smile about whenever it's mentioned.",
	"I came into the world through artificial insemination at a fertility clinic with the help of an anonymous donor.",
	"I was born in the passenger seat of an old station wagon on the way to the emergency room.",
	"My parents met at a summer music festival, and nine months later I made my loud entrance into the world.",
	"I was delivered by an exhausted resident doctor in the middle of a bustling hospital overnight shift.",
	"I was born during a massive citywide thunderstorm that knocked out the power right as I arrived.",
	"My parents were high school sweethearts who planned every single detail of my arrival for years.",
	"I arrived three weeks ahead of schedule, catching my parents completely by surprise in the middle of dinner.",
	"My mother went into labor while shopping at a supermarket, causing complete pandemonium in aisle three.",
	"I was born with a thick mop of dark hair that had every nurse in the maternity ward coming over to look.",
	"I was conceived on a turbulent ocean cruise during a stormy voyage my mother swears she'll never repeat.",
	"My mother was determined to have a peaceful home birth surrounded by family, tea, and aromatic candles.",
	"I was born in an elevator that temporarily stalled between the fourth and fifth floors of the hospital.",
	"My father fainted in the delivery room the moment I appeared, so the nurses had two patients to take care of.",
	"I was born during the coldest blizzard in the city's recorded history, wrapped in three hand-knitted blankets.",
	"My parents conceived me on a remote camping trip under the stars after getting lost in a national park.",
	"I was welcomed into the world by two loving parents who had painted my nursery three months in advance.",
	"I was born on a quiet Sunday morning while church bells were ringing across the neighborhood.",
	"My mother claims I kicked to the rhythm of her favorite jazz records throughout the entire third trimester.",
	"I was born in a university teaching hospital with half a dozen fascinated medical students observing.",
	"My arrival was an absolute surprise—my parents thought they were just adopting a second dog that month.",
	"I was born peacefully at sunrise, greeted by a room full of tearful grandparents and aunts."
]


static func get_zodiac(month: int, day: int) -> String:
	# month is 1-12
	match month:
		1: return "Capricorn" if day <= 19 else "Aquarius"
		2: return "Aquarius" if day <= 18 else "Pisces"
		3: return "Pisces" if day <= 20 else "Aries"
		4: return "Aries" if day <= 19 else "Taurus"
		5: return "Taurus" if day <= 20 else "Gemini"
		6: return "Gemini" if day <= 20 else "Cancer"
		7: return "Cancer" if day <= 22 else "Leo"
		8: return "Leo" if day <= 22 else "Virgo"
		9: return "Virgo" if day <= 22 else "Libra"
		10: return "Libra" if day <= 22 else "Scorpio"
		11: return "Scorpio" if day <= 21 else "Sagittarius"
		12: return "Sagittarius" if day <= 21 else "Capricorn"
	return "Capricorn"


static func generate_profile(first_name: String, country: String, gender: String) -> Dictionary:
	var month_idx := randi_range(0, 11)
	var month_info: Dictionary = MONTH_DATA[month_idx]
	var month_name: String = month_info["name"]
	var day: int = randi_range(1, int(month_info["days"]))
	var zodiac: String = get_zodiac(month_idx + 1, day)

	var last_name := ""
	var name_parts := first_name.split(" ", false)
	if name_parts.size() > 1:
		last_name = name_parts[name_parts.size() - 1]
	else:
		last_name = NameCatalog.random_name(country, false).split(" ", false)[-1]

	var mom_first := NameCatalog.random_name(country, true).split(" ", false)[0]
	var mom_age := randi_range(22, 44)
	var mom_job: String = PROFESSIONS.pick_random()

	var dad_present := randf() > 0.15
	var dad_first := ""
	var dad_age := mom_age + randi_range(-2, 5)
	var dad_job := ""
	if dad_present:
		dad_first = NameCatalog.random_name(country, false).split(" ", false)[0]
		dad_job = PROFESSIONS.pick_random()

	var circumstance: String = CONCEPTION_STORIES.pick_random()
	var gender_term := "male" if gender.to_upper() == "MALE" else "female"

	var lines: Array[String] = []
	lines.append("I am a %s who came into the world in %s." % [gender_term, country])
	lines.append(circumstance)
	lines.append("My birthday is %s %d. I am a %s." % [month_name, day, zodiac])
	lines.append("My name is %s." % first_name)
	lines.append("My mother is %s %s, a %s (age %d)." % [mom_first, last_name, mom_job, mom_age])

	if dad_present:
		lines.append("My father is %s %s, a %s (age %d)." % [dad_first, last_name, dad_job, dad_age])
	else:
		lines.append("My mother is raising me as a single parent.")

	var full_text := "\n".join(lines)

	return {
		"story": full_text,
		"birth_month": month_name,
		"birth_day": day,
		"zodiac": zodiac,
		"mother_name": "%s %s" % [mom_first, last_name],
		"mother_age": mom_age,
		"mother_job": mom_job,
		"father_name": "%s %s" % [dad_first, last_name] if dad_present else "Unknown",
		"father_age": dad_age if dad_present else 0,
		"father_job": dad_job if dad_present else "N/A",
		"has_father": dad_present
	}
