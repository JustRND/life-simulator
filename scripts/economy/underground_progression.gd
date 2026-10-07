extends RefCounted

static var _catalog: Dictionary = {}

static func catalog() -> Dictionary:
	if _catalog.is_empty():
		var parsed = JSON.parse_string(FileAccess.get_file_as_string("res://data/economy/underground.json"))
		if parsed is Dictionary:
			_catalog = parsed
	return _catalog

static func rank_for(completed: int) -> int:
	var rank := 0
	var ranks: Array = catalog().ranks
	for i in range(ranks.size()):
		if completed >= int(ranks[i].completed):
			rank = i
	return rank

static func normalize(player: Node) -> void:
	if player.underground_progress.is_empty():
		# Existing criminal jobs keep their job but begin building activity reputation.
		player.underground_progress = {"joined": player.job_id.begins_with("crime_"), "completed": 0, "attempt_age": player.age, "attempts": 0}

static func join(player: Node) -> bool:
	normalize(player)
	if player.age < 17 or player.is_dead or player.is_in_prison or bool(player.underground_progress.get("joined", false)):
		return false
	player.underground_progress["joined"] = true
	return true

static func attempts_left(player: Node) -> int:
	normalize(player)
	var spent := int(player.underground_progress.get("attempts", 0)) if int(player.underground_progress.get("attempt_age", -1)) == player.age else 0
	return maxi(0, int(catalog().attempts_per_year) - spent)

static func requirement(player: Node, activity: Dictionary) -> String:
	normalize(player)
	if player.is_dead:
		return "This life has ended."
	if player.age < 17:
		return "Unlocks at age 17."
	if player.is_in_prison:
		return "Unavailable while incarcerated."
	if not bool(player.underground_progress.get("joined", false)):
		return "Join the underground first."
	if rank_for(int(player.underground_progress.get("completed", 0))) < int(activity.rank):
		return "Requires rank: " + str(catalog().ranks[int(activity.rank)].name)
	if attempts_left(player) == 0:
		return "No attempts left this year. Age up to continue."
	return ""

static func attempt(player: Node, activity_id: String, roll: float, reward_roll: float) -> String:
	var activity: Dictionary = {}
	for entry in catalog().activities:
		if entry.id == activity_id:
			activity = entry
			break
	if activity.is_empty() or not requirement(player, activity).is_empty():
		return ""
	if int(player.underground_progress.get("attempt_age", -1)) != player.age:
		player.underground_progress["attempt_age"] = player.age
		player.underground_progress["attempts"] = 0
	player.underground_progress["attempts"] = int(player.underground_progress.get("attempts", 0)) + 1
	if roll < float(activity.risk):
		player.is_in_prison = true
		player.prison_sentence_years = int(activity.sentence)
		player.job_id = ""
		player.job_title = ""
		player.job_company = ""
		player.job_salary = 0
		player.career_progress = {}
		player.karma -= int(activity.caught_karma)
		player.happiness = maxi(0, player.happiness - 30)
		return "ARRESTED: Your %s attempt failed. You received a %d-year prison sentence and lost your job. No rank progress earned." % [activity.name, int(activity.sentence)]
	var completed := int(player.underground_progress.get("completed", 0))
	var previous_rank := rank_for(completed)
	var earnings := int(lerpf(float(activity.min_reward), float(activity.max_reward), clampf(reward_roll, 0, 1)))
	player.money += earnings
	player.karma -= int(activity.karma_loss)
	player.underground_progress["completed"] = completed + 1
	var message := "%s succeeded. You earned $%d and completed another underground activity (%d total)." % [activity.name, earnings, completed + 1]
	var rank := rank_for(completed + 1)
	if rank > previous_rank:
		message += " RANK UP: You are now %s. New opportunities are available." % str(catalog().ranks[rank].name)
	return message

static func summary(player: Node) -> String:
	normalize(player)
	var completed := int(player.underground_progress.get("completed", 0))
	var rank := rank_for(completed)
	var ranks: Array = catalog().ranks
	var message := "%s • Rank %d/%d\n%d successful activities • %d/%d attempts left this year" % [ranks[rank].name, rank + 1, ranks.size(), completed, attempts_left(player), int(catalog().attempts_per_year)]
	if rank + 1 < ranks.size():
		message += "\nNext: %s • %d more successes" % [ranks[rank + 1].name, int(ranks[rank + 1].completed) - completed]
	else:
		message += "\nHighest underground rank reached."
	return message
