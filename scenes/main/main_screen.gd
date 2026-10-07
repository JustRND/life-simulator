extends Control
const CreationOptions = preload("res://scripts/core/creation_options.gd")
const NameCatalog = preload("res://scripts/core/name_catalog.gd")
const PortraitCatalog = preload("res://scripts/core/portrait_catalog.gd")
const BirthStoryGenerator = preload("res://scripts/core/birth_story_generator.gd")
const EducationCatalog = preload("res://scripts/education/education_catalog.gd")

var portrait: TextureRect
var portrait_key: String = ""
var gender_input: OptionButton

var current_event = null
var current_event_choices: Array = []

# Profile Strip Nodes
@onready var avatar_button: Button = $ProfileStrip/ProfileMargin/ProfileRow/AvatarButton
@onready var nationality_flag: TextureRect = $ProfileStrip/ProfileMargin/ProfileRow/NationalityFlag
@onready var name_label: Label = $ProfileStrip/ProfileMargin/ProfileRow/NameAndPhase/NameLabel
@onready var phase_label: Label = $ProfileStrip/ProfileMargin/ProfileRow/NameAndPhase/PhaseLabel
@onready var balance_label: Label = $ProfileStrip/ProfileMargin/ProfileRow/BalanceLabel

# Main Screen / Timeline
@onready var life_feed: RichTextLabel = $SafeArea/MainColumn/LifeFeedPanel/MarginContainer/LifeFeed
@onready var health_bar: ProgressBar = $SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/HealthBar
@onready var happiness_bar: ProgressBar = $SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/HappinessBar
@onready var smarts_bar: ProgressBar = $SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/SmartsBar
@onready var looks_bar: ProgressBar = $SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/LooksBar

# Loading Screen
@onready var loading_screen: Control = get_node_or_null("LoadingScreen") as Control
@onready var loading_progress_label: Label = get_node_or_null("LoadingScreen/CenterContainer/LoadingVBox/LoadingProgressLabel") as Label
@onready var age_button: Button = $SafeArea/MainColumn/AgeButton

# Dialogs & Overlays
@onready var settings_overlay: ColorRect = $SettingsOverlay
@onready var reset_confirmation_overlay: ColorRect = $ResetConfirmationOverlay
@onready var new_game_panel: PanelContainer = $NewGamePanel
@onready var name_input: LineEdit = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/NameInput
@onready var birthplace_input: OptionButton = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/BirthplaceInput
@onready var validation_label: Label = $NewGamePanel/CenterContainer/CreationCard/NewGameContent/ValidationLabel

# 4 Action Buttons flanking Age Button
@onready var infant_button: Button = $SafeArea/MainColumn/ActionBar/ActionRow/InfantButton
@onready var assets_button: Button = $SafeArea/MainColumn/ActionBar/ActionRow/AssetsButton
@onready var relationships_button: Button = $SafeArea/MainColumn/ActionBar/ActionRow/RelationshipsButton
@onready var activities_button: Button = $SafeArea/MainColumn/ActionBar/ActionRow/ActivitiesButton

# Navigation panels
@onready var timeline_panel: Control = $SafeArea
@onready var character_panel: PanelContainer = $CharacterPanel

# Character Profile Nodes
@onready var character_name: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/IdentityCard/Margin/VBox/CharacterName
@onready var character_stage: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/IdentityCard/Margin/VBox/CharacterStage
@onready var character_birthplace: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/IdentityCard/Margin/VBox/CharacterBirthplace
@onready var character_birthday: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/IdentityCard/Margin/VBox/CharacterBirthday
@onready var character_mother: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/FamilyCard/Margin/VBox/CharacterMother
@onready var character_father: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/FamilyCard/Margin/VBox/CharacterFather
@onready var character_story: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/FamilyCard/Margin/VBox/CharacterStory
@onready var character_money: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/FinancesCard/Margin/VBox/CharacterMoney
@onready var character_karma: Label = $CharacterPanel/CharacterMargin/CharacterContent/CharacterScroll/ProfileCards/FinancesCard/Margin/VBox/CharacterKarma

# Toddler / Infant Panel (Life Overview Panel)
@onready var infant_panel: PanelContainer = $InfantPanel
@onready var current_stage_label: Label = $InfantPanel/InfantMargin/InfantContent/StatusCard/StatusMargin/StatusBox/CurrentStageLabel
@onready var current_job_label: Label = get_node_or_null("InfantPanel/InfantMargin/InfantContent/StatusCard/StatusMargin/StatusBox/CurrentJobLabel") as Label
@onready var current_edu_label: Label = get_node_or_null("InfantPanel/InfantMargin/InfantContent/StatusCard/StatusMargin/StatusBox/CurrentEduLabel") as Label
@onready var grades_label: Label = get_node_or_null("InfantPanel/InfantMargin/InfantContent/StatusCard/StatusMargin/StatusBox/GradesContainer/GradesLabel") as Label
@onready var grades_progress_bar: ProgressBar = get_node_or_null("InfantPanel/InfantMargin/InfantContent/StatusCard/StatusMargin/StatusBox/GradesContainer/GradesProgressBar") as ProgressBar
@onready var history_list: VBoxContainer = $InfantPanel/InfantMargin/InfantContent/HistoryScroll/HistoryList
@onready var filter_all_btn: Button = get_node_or_null("InfantPanel/InfantMargin/InfantContent/HistoryFilterRow/FilterAllButton") as Button
@onready var filter_milestones_btn: Button = get_node_or_null("InfantPanel/InfantMargin/InfantContent/HistoryFilterRow/FilterMilestonesButton") as Button
@onready var filter_unique_btn: Button = get_node_or_null("InfantPanel/InfantMargin/InfantContent/HistoryFilterRow/FilterUniqueButton") as Button

var overview_history_filter: String = "all"

# Activities Modals
var jobs_modal_overlay: Control = null
var education_modal_overlay: Control = null

# Assets Panel
@onready var assets_panel: PanelContainer = $AssetsPanel
@onready var assets_cash_label: Label = $AssetsPanel/AssetsMargin/AssetsContent/AssetsCashLabel
@onready var bank_button: Button = $AssetsPanel/AssetsMargin/AssetsContent/BankButton

# Bank Panel
@onready var bank_panel: PanelContainer = $BankPanel
@onready var bank_scroll: ScrollContainer = $BankPanel/BankMargin/BankContent/BankScroll
@onready var bank_list: VBoxContainer = $BankPanel/BankMargin/BankContent/BankScroll/BankList
@onready var bank_checking_label: Label = $BankPanel/BankMargin/BankContent/BankScroll/BankList/BankCard/Margin/VBox/CheckingBalanceLabel
@onready var bank_header_icon: TextureRect = $BankPanel/BankMargin/BankContent/BankScroll/BankList/BankCard/Margin/VBox/BankIconRow/BankHeaderIcon

# Relationships Panel Nodes
@onready var relationships_panel: PanelContainer = $RelationshipsPanel
@onready var mother_card: PanelContainer = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/MotherCard
@onready var mother_icon: TextureRect = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/MotherCard/Margin/HBox/MotherIcon
@onready var mother_name_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/MotherCard/Margin/HBox/MotherVBox/MotherNameLabel
@onready var mother_job_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/MotherCard/Margin/HBox/MotherVBox/MotherJobLabel
@onready var mother_status_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/MotherCard/Margin/HBox/MotherVBox/MotherStatusLabel

@onready var father_card: PanelContainer = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/FatherCard
@onready var father_icon: TextureRect = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/FatherCard/Margin/HBox/FatherIcon
@onready var father_name_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/FatherCard/Margin/HBox/FatherVBox/FatherNameLabel
@onready var father_job_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/FatherCard/Margin/HBox/FatherVBox/FatherJobLabel
@onready var father_status_label: Label = $RelationshipsPanel/RelMargin/RelContent/RelScroll/RelList/FatherCard/Margin/HBox/FatherVBox/FatherStatusLabel

# Activities Panel
@onready var activities_panel: PanelContainer = $ActivitiesPanel

# Event Dialog Nodes
@onready var event_overlay: Control = get_node_or_null("EventOverlay") as Control
@onready var event_title: Label = _find_event_node("EventTitle") as Label
@onready var event_description: RichTextLabel = _find_event_node("EventDescription") as RichTextLabel
@onready var event_choice_1: Button = _find_event_node("EventChoice1") as Button
@onready var event_choice_2: Button = _find_event_node("EventChoice2") as Button
@onready var event_choice_3: Button = _find_event_node("EventChoice3") as Button
@onready var event_choice_4: Button = _find_event_node("EventChoice4") as Button


func _ready() -> void:
	_configure_ui()
	_connect_runtime_signals()

	# Soft UI taps, including buttons created later by modal panels.
	if get_node_or_null("ButtonSounds") == null:
		var sounds := preload("res://scripts/ui/button_sounds.gd").new()
		sounds.name = "ButtonSounds"
		add_child(sounds)

	var loaded: bool = SaveManager.load_game()

	if event_overlay != null:
		event_overlay.visible = false

	if settings_overlay != null:
		settings_overlay.visible = false

	if reset_confirmation_overlay != null:
		reset_confirmation_overlay.visible = false

	character_panel.visible = false
	infant_panel.visible = false
	assets_panel.visible = false
	bank_panel.visible = false
	relationships_panel.visible = false
	activities_panel.visible = false
	timeline_panel.visible = true

	if loaded and PlayerData.has_started_game:
		hide_new_game_screen()
		rebuild_life_feed()
		update_ui()
		if PlayerData.is_dead:
			_show_death_screen(PlayerData.cause_of_death if PlayerData.cause_of_death != "" else "Health Complications")
	else:
		show_new_game_screen()

	if loading_screen != null:
		loading_screen.visible = true
		loading_screen.modulate.a = 1.0
		_start_loading_animation()


func _connect_runtime_signals() -> void:
	if avatar_button != null and not avatar_button.pressed.is_connected(_on_avatar_button_pressed):
		avatar_button.pressed.connect(_on_avatar_button_pressed)

	if filter_all_btn != null and not filter_all_btn.pressed.is_connected(_on_filter_all_pressed):
		filter_all_btn.pressed.connect(_on_filter_all_pressed)
	if filter_milestones_btn != null and not filter_milestones_btn.pressed.is_connected(_on_filter_milestones_pressed):
		filter_milestones_btn.pressed.connect(_on_filter_milestones_pressed)
	if filter_unique_btn != null and not filter_unique_btn.pressed.is_connected(_on_filter_unique_pressed):
		filter_unique_btn.pressed.connect(_on_filter_unique_pressed)


func _configure_ui() -> void:
	_configure_creation()
	_configure_age_art()
	_configure_action_bar()
	_configure_custom_icons()
	_configure_stat_bars()
	_configure_portrait()
	_configure_button_contrasts()

	life_feed.scroll_following = true
	life_feed.get_v_scroll_bar().changed.connect(_scroll_after_layout)
	name_label.add_theme_font_size_override("font_size", 40)
	phase_label.add_theme_font_size_override("font_size", 26)
	life_feed.add_theme_font_size_override("normal_font_size", 28)
	life_feed.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var life_margin := get_node_or_null("SafeArea/MainColumn/LifeFeedPanel/MarginContainer") as MarginContainer
	if life_margin != null:
		life_margin.add_theme_constant_override("margin_left", 30)
		life_margin.add_theme_constant_override("margin_right", 30)
		life_margin.add_theme_constant_override("margin_top", 24)
		life_margin.add_theme_constant_override("margin_bottom", 24)

	var page := StyleBoxFlat.new()
	page.bg_color = Color(0.055, 0.085, 0.17, 0.98)
	page.border_width_left = 3
	page.border_width_top = 3
	page.border_width_right = 3
	page.border_width_bottom = 3
	page.border_color = Color(0.22, 0.65, 0.95, 0.95)
	page.corner_radius_top_left = 12
	page.corner_radius_top_right = 12
	page.corner_radius_bottom_right = 12
	page.corner_radius_bottom_left = 12
	page.shadow_color = Color(0.02, 0.05, 0.12, 0.7)
	page.shadow_size = 14
	character_panel.add_theme_stylebox_override("panel", page)
	infant_panel.add_theme_stylebox_override("panel", page)
	assets_panel.add_theme_stylebox_override("panel", page)
	bank_panel.add_theme_stylebox_override("panel", page)
	relationships_panel.add_theme_stylebox_override("panel", page)
	activities_panel.add_theme_stylebox_override("panel", page)


func _configure_button_contrasts() -> void:
	# Enforce clear contrasting text on all activity buttons and cards
	var act_list := get_node_or_null("ActivitiesPanel/ActMargin/ActContent/ActScroll/ActList")
	if act_list != null:
		for child in act_list.get_children():
			if child is Button:
				child.add_theme_color_override("font_color", Color("#f1f5f9"))
				child.add_theme_color_override("font_hover_color", Color("#00f0ff"))
				child.add_theme_color_override("font_pressed_color", Color("#ffffff"))
				child.add_theme_color_override("font_focus_color", Color("#00f0ff"))

	if bank_button != null:
		bank_button.add_theme_color_override("font_color", Color("#f1f5f9"))
		bank_button.add_theme_color_override("font_hover_color", Color("#00f0ff"))
		bank_button.add_theme_color_override("font_pressed_color", Color("#ffffff"))
		bank_button.add_theme_color_override("font_focus_color", Color("#00f0ff"))

	var back_assets_btn := get_node_or_null("BankPanel/BankMargin/BankContent/BankHeaderRow/BackToAssetsButton") as Button
	if back_assets_btn != null:
		back_assets_btn.add_theme_color_override("font_color", Color("#f1f5f9"))
		back_assets_btn.add_theme_color_override("font_hover_color", Color("#00f0ff"))
		back_assets_btn.add_theme_color_override("font_pressed_color", Color("#ffffff"))
		back_assets_btn.add_theme_color_override("font_focus_color", Color("#00f0ff"))


func _configure_action_bar() -> void:
	# Configure MenuButton (Settings Cog) in TopBar with smooth tactile micro-animations
	var menu_btn := get_node_or_null("TopBar/Row/MenuButton") as Button
	if menu_btn != null:
		if ResourceLoader.exists("res://assets/icons/icon_menu.png"):
			menu_btn.icon = load("res://assets/icons/icon_menu.png")
			menu_btn.text = ""
			menu_btn.expand_icon = true
			menu_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			menu_btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
			menu_btn.custom_minimum_size = Vector2(76, 76)
			menu_btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		menu_btn.pivot_offset = Vector2(38, 38)
		if not menu_btn.mouse_entered.is_connected(_on_menu_btn_hover):
			menu_btn.mouse_entered.connect(_on_menu_btn_hover)
		if not menu_btn.mouse_exited.is_connected(_on_menu_btn_exit):
			menu_btn.mouse_exited.connect(_on_menu_btn_exit)
		if not menu_btn.button_down.is_connected(_on_menu_btn_down):
			menu_btn.button_down.connect(_on_menu_btn_down)
		if not menu_btn.button_up.is_connected(_on_menu_btn_up):
			menu_btn.button_up.connect(_on_menu_btn_up)

	# Configure the 4 16-bit icons on the Action Bar flanking Age Button with tactile micro-interactions
	var icon_configs := [
		[infant_button, get_stage_icon_path(PlayerData.age), "Infant"],
		[assets_button, "res://assets/icons/icon_assets.png", "Assets"],
		[relationships_button, "res://assets/icons/icon_relationships.png", "Relationships"],
		[activities_button, "res://assets/icons/icon_activities.png", "Activities"]
	]

	for item in icon_configs:
		var btn: Button = item[0]
		if btn != null:
			if ResourceLoader.exists(item[1]):
				btn.icon = load(item[1])
				btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
				btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
				btn.expand_icon = true
				btn.add_theme_constant_override("icon_max_width", 96)
				btn.add_theme_constant_override("h_separation", 8)
				btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			btn.pivot_offset = Vector2(75, 105)
			if not btn.mouse_entered.is_connected(_on_action_bar_btn_hover.bind(btn)):
				btn.mouse_entered.connect(_on_action_bar_btn_hover.bind(btn))
			if not btn.mouse_exited.is_connected(_on_action_bar_btn_exit.bind(btn)):
				btn.mouse_exited.connect(_on_action_bar_btn_exit.bind(btn))
			if not btn.button_down.is_connected(_on_action_bar_btn_down.bind(btn)):
				btn.button_down.connect(_on_action_bar_btn_down.bind(btn))
			if not btn.button_up.is_connected(_on_action_bar_btn_up.bind(btn)):
				btn.button_up.connect(_on_action_bar_btn_up.bind(btn))

	# Configure Bank icon on BankButton in AssetsPanel
	if bank_button != null and ResourceLoader.exists("res://assets/icons/icon_bank.png"):
		bank_button.icon = load("res://assets/icons/icon_bank.png")
		bank_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		bank_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		bank_button.expand_icon = true
		bank_button.add_theme_constant_override("icon_max_width", 100)
		bank_button.add_theme_constant_override("h_separation", 24)
		bank_button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	if bank_header_icon != null and ResourceLoader.exists("res://assets/icons/icon_bank.png"):
		bank_header_icon.texture = load("res://assets/icons/icon_bank.png")
		bank_header_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func get_stage_icon_path(age: int) -> String:
	if age == 0:
		return "res://assets/icons/icon_infant.png"
	elif age <= 4:
		return "res://assets/icons/icon_toddler.png"
	elif age <= 12:
		return "res://assets/icons/icon_child.png"
	elif age <= 19:
		return "res://assets/icons/icon_teenager.png"
	elif age <= 64:
		return "res://assets/icons/icon_adult.png"
	else:
		return "res://assets/icons/icon_elder.png"


func _find_event_node(node_name: String) -> Node:
	var paths := [
		"EventOverlay/EventPanel/EventMargin/EventContent/" + node_name,
		"EventOverlay/EventPanel/EventMargin/EventContent/EventChoices/" + node_name,
		"EventOverlay/EventPanel/EventContent/" + node_name,
		"EventOverlay/EventPanel/EventContent/EventChoices/" + node_name,
		"EventOverlay/EventPanel/MarginContainer/EventContent/" + node_name,
		"EventOverlay/EventPanel/MarginContainer/EventContent/EventChoices/" + node_name
	]

	for path in paths:
		var node: Node = get_node_or_null(path)
		if node != null:
			return node

	return null


func _format_number(val: int) -> String:
	var s := str(absi(val))
	var res := ""
	for i in range(s.length()):
		if i > 0 and (s.length() - i) % 3 == 0:
			res += ","
		res += s[i]
	return ("-" if val < 0 else "") + res


func age_up() -> void:
	if PlayerData.is_dead:
		return
	if current_event != null:
		return

	PlayerData.age += 1

	var year_word: String = "year" if PlayerData.age == 1 else "years"
	add_life_event("You turned %d %s old." % [PlayerData.age, year_word], "age")

	# 1. Prison Sentence Countdown
	if PlayerData.is_in_prison:
		PlayerData.prison_sentence_years -= 1
		if PlayerData.prison_sentence_years <= 0:
			PlayerData.is_in_prison = false
			PlayerData.prison_sentence_years = 0
			add_life_event("🎉 RELEASED: You have completed your prison sentence and were released back into society!", "crime")
		else:
			add_life_event("🔒 You served another year behind bars (%d years remaining)." % PlayerData.prison_sentence_years, "crime")
			PlayerData.happiness = maxi(5, PlayerData.happiness - 6)

	# 2. Annual Salary Payout (if employed and not in prison)
	if not PlayerData.is_in_prison and PlayerData.job_title != "" and PlayerData.job_salary > 0:
		PlayerData.money += PlayerData.job_salary
		add_life_event("You received your annual salary of $%s from %s." % [
			_format_number(PlayerData.job_salary),
			PlayerData.job_company
		], "job")

	# 3. Living Expenses & Taxes (Adults age >= 18)
	if PlayerData.age >= 18:
		# Young adults under 22 living with parents pay $0 if unemployed
		var base_living: int = 0
		if PlayerData.age < 22 and PlayerData.job_title == "":
			base_living = 0
		elif PlayerData.job_salary > 0:
			base_living = 300 + int(PlayerData.job_salary * 0.04)
		else:
			# Unemployed adult over 22: minimal independent survival costs
			base_living = randi_range(200, 350)

		if base_living > 0:
			var total_avail: int = PlayerData.money + PlayerData.bank_savings
			if total_avail >= base_living:
				if PlayerData.money >= base_living:
					PlayerData.money -= base_living
				else:
					var rem: int = base_living - PlayerData.money
					PlayerData.money = 0
					PlayerData.bank_savings -= rem
				add_life_event("You paid your annual basic living expenses of $%s (food, rent & bills)." % _format_number(base_living), "finance")
			else:
				var paid: int = total_avail
				var unpaid: int = base_living - paid
				PlayerData.money = 0
				PlayerData.bank_savings = 0
				PlayerData.debt += unpaid
				PlayerData.happiness = maxi(5, PlayerData.happiness - randi_range(2, 5))
				if PlayerData.debt > 15000:
					PlayerData.health = maxi(5, PlayerData.health - 1)
				add_life_event("⚠️ FINANCIAL STRUGGLE: You couldn't afford full living expenses ($%s)! Unpaid $%s added to debt (Total Debt: $%s)." % [
					_format_number(base_living),
					_format_number(unpaid),
					_format_number(PlayerData.get_total_debt())
				], "finance")

		# Taxes: Progressive bracket with $18,000 standard deduction
		var tax_due: int = 0
		if PlayerData.job_salary > 18000:
			var taxable: int = PlayerData.job_salary - 18000
			if taxable <= 42000:
				tax_due = int(taxable * 0.08)
			elif taxable <= 132000:
				tax_due = int(42000 * 0.08 + (taxable - 42000) * 0.14)
			else:
				tax_due = int(42000 * 0.08 + 90000 * 0.14 + (taxable - 132000) * 0.22)

		if tax_due > 0:
			var total_avail_tax: int = PlayerData.money + PlayerData.bank_savings
			if total_avail_tax >= tax_due:
				if PlayerData.money >= tax_due:
					PlayerData.money -= tax_due
				else:
					var rem_tax: int = tax_due - PlayerData.money
					PlayerData.money = 0
					PlayerData.bank_savings -= rem_tax
				add_life_event("You paid your annual income tax of $%s." % _format_number(tax_due), "finance")
			else:
				var paid_tax: int = total_avail_tax
				var unpaid_tax: int = tax_due - paid_tax
				PlayerData.money = 0
				PlayerData.bank_savings = 0
				PlayerData.debt += unpaid_tax
				add_life_event("⚠️ TAX AUDIT: You couldn't afford your annual income tax of $%s! The unpaid $%s has been added to your debt (Total Debt: $%s)." % [
					_format_number(tax_due),
					_format_number(unpaid_tax),
					_format_number(PlayerData.get_total_debt())
				], "finance")

	# 4. Job Security / Downsizing Risk (Anti-God Mode)
	if not PlayerData.is_in_prison and PlayerData.job_title != "":
		var layoff_risk: float = 0.035
		if PlayerData.smarts < 40 or PlayerData.grades < 50:
			layoff_risk = 0.075
		if randf() < layoff_risk:
			var old_job: String = PlayerData.job_title
			quit_job()
			PlayerData.happiness = maxi(5, PlayerData.happiness - 18)
			add_life_event("📉 DOWNSIZED: Economic contraction forced your employer to terminate your role as %s! You are now unemployed." % old_job, "career")

	# 5. Bank Loan Interest (8% annual APR)
	if PlayerData.loan_balance > 0:
		var interest: int = maxi(10, int(PlayerData.loan_balance * PlayerData.loan_interest_rate))
		PlayerData.loan_balance += interest
		add_life_event("Your bank loan accrued $%s in annual interest (Loan Balance: $%s)." % [
			_format_number(interest),
			_format_number(PlayerData.loan_balance)
		], "finance")

	# 6. Bank Savings Interest (2.5% Annual Return)
	if PlayerData.bank_savings > 0:
		var savings_interest: int = int(PlayerData.bank_savings * 0.025)
		if savings_interest > 0:
			PlayerData.bank_savings += savings_interest
			add_life_event("Your high-yield bank savings account accrued $%s in annual interest (2.5%% APR)." % _format_number(savings_interest), "finance")

	# 7. Gym Membership Annual Auto-Debit
	if PlayerData.has_gym_membership:
		var gym_fee: int = PlayerData.gym_membership_annual_fee
		if PlayerData.bank_savings >= gym_fee:
			PlayerData.bank_savings -= gym_fee
			add_life_event("🏋️ GYM MEMBERSHIP: $%s was auto-debited from your bank account for your annual fitness club membership." % _format_number(gym_fee), "finance")
		elif PlayerData.money >= gym_fee:
			PlayerData.money -= gym_fee
			add_life_event("🏋️ GYM MEMBERSHIP: $%s was paid from your cash account for your annual fitness club membership." % _format_number(gym_fee), "finance")
		else:
			PlayerData.has_gym_membership = false
			PlayerData.happiness = maxi(5, PlayerData.happiness - 4)
			add_life_event("⚠️ GYM MEMBERSHIP CANCELLED: You lacked sufficient funds ($%s) in your bank account to renew your gym membership. It has been cancelled." % _format_number(gym_fee), "finance")

	# 8. Education Lifecycle Progression (Kindergarten @ 3, Primary @ 6, Middle @ 11, High @ 14, Grad @ 18)
	if PlayerData.age == 3:
		PlayerData.education_level = "Kindergarten"
		PlayerData.grades = 80
		add_life_event("🧸 You enrolled in Kindergarten! Learning letters, colors, and finger painting.", "milestone")
	elif PlayerData.age == 6:
		PlayerData.education_level = "Primary School"
		add_life_event("🎒 You completed Kindergarten and entered Primary School! Learning math, science, and reading.", "milestone")
	elif PlayerData.age == 11:
		PlayerData.education_level = "Middle School"
		add_life_event("🏫 You completed Primary School and advanced to Middle School! Academic subjects and social dynamics intensify.", "milestone")
	elif PlayerData.age == 14 and PlayerData.education_level != "High School Dropout":
		PlayerData.education_level = "High School"
		add_life_event("📘 You entered High School! Your academic marks directly determine future career qualification.", "milestone")
	elif PlayerData.age == 18 and PlayerData.education_level == "High School":
		PlayerData.education_level = "High School Graduate"
		add_life_event("🎓 You graduated from High School with a final academic grade of %d%% (%s)!" % [PlayerData.grades, PlayerData.get_letter_grade()], "milestone")
	elif PlayerData.education_level == "University Student":
		PlayerData.university_years += 1
		var tuition: int = PlayerData.university_tuition if PlayerData.university_tuition > 0 else 12000
		var uni_title: String = PlayerData.university_name if PlayerData.university_name != "" else "University"
		if PlayerData.has_scholarship:
			add_life_event("Your full-ride scholarship paid for your $%s %s tuition!" % [_format_number(tuition), uni_title], "education")
		else:
			if PlayerData.money >= tuition:
				PlayerData.money -= tuition
				add_life_event("You paid your $%s %s tuition from your pocket cash." % [_format_number(tuition), uni_title], "education")
			elif PlayerData.bank_savings >= tuition:
				PlayerData.bank_savings -= tuition
				add_life_event("Your $%s %s tuition was deducted from your bank savings." % [_format_number(tuition), uni_title], "education")
			else:
				PlayerData.loan_balance += tuition
				add_life_event("%s tuition of $%s was funded via a Student Loan (8%% APR)." % [uni_title, _format_number(tuition)], "finance")

		if PlayerData.university_years >= 4:
			PlayerData.education_level = "University Graduate"
			PlayerData.smarts = mini(100, PlayerData.smarts + 12)
			PlayerData.happiness = mini(100, PlayerData.happiness + 15)
			var deg_name: String = PlayerData.university_degree if PlayerData.university_degree != "" else "Bachelor's Degree"
			var maj_name: String = PlayerData.university_major_title if PlayerData.university_major_title != "" else "Specialized Major"
			add_life_event("🎓 CONGRATULATIONS! You graduated from %s with a %s in %s! Careers in %s are now unlocked." % [uni_title, deg_name, maj_name, maj_name], "milestone")
		else:
			var m_label: String = " (%s)" % PlayerData.university_major_title if PlayerData.university_major_title != "" else ""
			add_life_event("You finished Year %d of 4 at %s%s (Grades: %d%%)." % [PlayerData.university_years, uni_title, m_label, PlayerData.grades], "education")

	# Grade drift based on smarts
	if PlayerData.education_level in ["Kindergarten", "Primary School", "Middle School", "High School", "University Student"]:
		var smarts_bonus: int = int((float(PlayerData.smarts) - 50.0) / 10.0)
		var grade_delta: int = smarts_bonus + randi_range(-3, 3)
		PlayerData.grades = clamp(PlayerData.grades + grade_delta, 35, 100)

	# 8. Aging Health Curve & General Sickness
	randomize_stats()

	# 9. Multi-Stage Cancer & Illness Progression
	var cancer: Dictionary = PlayerData.get_illness("cancer")
	if not cancer.is_empty():
		var st: int = int(cancer.get("stage", 1))
		if st == 1:
			PlayerData.health = maxi(0, PlayerData.health - 4)
			cancer["stage"] = 2
			add_life_event("⚠️ MEDICAL ALERT: Your cancer has progressed to Stage 2. Please visit the clinic for chemotherapy treatment.", "health")
		elif st == 2:
			PlayerData.health = maxi(0, PlayerData.health - 8)
			cancer["stage"] = 3
			add_life_event("🚨 CRITICAL ALERT: Your cancer has reached Stage 3. Your immune system is deteriorating rapidly. Seek chemotherapy immediately!", "health")
		else:
			PlayerData.health = maxi(0, PlayerData.health - 15)
			add_life_event("💀 Terminal Stage 3 Cancer continues to severely weaken your body!", "health")

		if PlayerData.health <= 0:
			trigger_death("Untreated Stage 3 Lymphoma Cancer")
			return

	# 7. Random Illness Contraction by Age (Balanced chances)
	if not PlayerData.has_illness("cancer") and PlayerData.age >= 30:
		var cancer_chance: float = 0.004
		if PlayerData.age >= 75:
			cancer_chance = 0.025
		elif PlayerData.age >= 60:
			cancer_chance = 0.015
		elif PlayerData.age >= 45:
			cancer_chance = 0.008

		if randf() < cancer_chance:
			PlayerData.add_illness("cancer", "Lymphoma Cancer", 1)
			add_life_event("⚠️ DIAGNOSIS: You have been diagnosed with Stage 1 Lymphoma Cancer! Consult a medical doctor immediately for chemotherapy.", "health")

	# 8. Random Accidents (Extremely rare freak accidents with survivable damage)
	if randf() < 0.002 and PlayerData.age >= 16:
		if randf() < 0.6:
			var dmg: int = randi_range(12, 20)
			PlayerData.health = maxi(0, PlayerData.health - dmg)
			add_life_event("💥 VEHICLE COLLISION: You were involved in a traffic accident! Fortunately you survived with bruises (Health -%d%%)." % dmg, "health")
			if PlayerData.health <= 0:
				trigger_death("Fatal Highway Car Collision")
				return
		else:
			var dmg: int = randi_range(10, 18)
			PlayerData.health = maxi(0, PlayerData.health - dmg)
			add_life_event("⚡ ACCIDENT: You suffered minor injuries in a sudden mishap (Health -%d%%)." % dmg, "health")
			if PlayerData.health <= 0:
				trigger_death("Fatal Structural Collapse Accident")
				return

	# 9. Natural Old Age Mortality (Age 85+)
	if PlayerData.age >= 85:
		var nat_chance: float = float(PlayerData.age - 84) * 0.035
		if randf() < nat_chance:
			PlayerData.health = 0
			trigger_death("Old Age & Natural Cardiac Arrest")
			return

	# 10. Check if player health reached 0%
	if PlayerData.health <= 0:
		var fallback_cause: String = "Untreated Stage 3 Lymphoma Cancer" if PlayerData.has_illness("cancer") else ("Severe Physical Exhaustion & Debt-Induced Stress" if PlayerData.debt > 15000 else "Critical Medical Failure & Acute Complications")
		trigger_death(fallback_cause)
		return

	# 11. Parents Aging & Mortality
	_process_parents_aging()

	trigger_event()
	update_ui()
	SaveManager.save_game()


func randomize_stats() -> void:
	# Aging health curve: Young = stable/positive, Older = progressive deterioration
	var health_flux: int = 0
	if PlayerData.age < 30:
		health_flux = randi_range(-1, 2)
	elif PlayerData.age < 50:
		health_flux = randi_range(-2, 1)
	elif PlayerData.age < 65:
		health_flux = randi_range(-3, 0)
	elif PlayerData.age < 80:
		health_flux = randi_range(-5, -1)
	else:
		health_flux = randi_range(-7, -2)

	var random_effects := {
		"health": health_flux,
		"happiness": randi_range(-3, 3),
		"smarts": randi_range(-1, 2) if PlayerData.age < 65 else randi_range(-2, 0),
		"looks": randi_range(-1, 1) if PlayerData.age < 50 else randi_range(-3, -1)
	}

	PlayerData.apply_effects(random_effects)


func _process_parents_aging() -> void:
	# Mother
	if PlayerData.mother_alive:
		var mom_age: int = PlayerData.mother_base_age + PlayerData.age
		if mom_age >= 60:
			var decay: int = randi_range(3, 7) + int((mom_age - 60) / 4.0)
			PlayerData.mother_health = maxi(0, PlayerData.mother_health - decay)

		var mom_dead: bool = PlayerData.mother_health <= 0 or (mom_age >= 75 and randf() < (float(mom_age - 70) * 0.038))
		if mom_dead:
			PlayerData.mother_alive = false
			PlayerData.mother_health = 0
			PlayerData.happiness = maxi(5, PlayerData.happiness - 40) # Significantly drops, but not ZERO
			add_life_event("💔 TRAGEDY: Your mother, %s, has passed away at the age of %d. You are heartbroken and grieving." % [PlayerData.mother_name, mom_age], "relationship")

	# Father
	if PlayerData.father_alive and PlayerData.father_name != "" and PlayerData.father_name != "Unknown":
		var dad_age: int = PlayerData.father_base_age + PlayerData.age
		if dad_age >= 60:
			var decay: int = randi_range(3, 7) + int((dad_age - 60) / 4.0)
			PlayerData.father_health = maxi(0, PlayerData.father_health - decay)

		var dad_dead: bool = PlayerData.father_health <= 0 or (dad_age >= 75 and randf() < (float(dad_age - 70) * 0.038))
		if dad_dead:
			PlayerData.father_alive = false
			PlayerData.father_health = 0
			PlayerData.happiness = maxi(5, PlayerData.happiness - 40) # Significantly drops, but not ZERO
			add_life_event("💔 TRAGEDY: Your father, %s, has passed away at the age of %d. You are heartbroken and grieving." % [PlayerData.father_name, dad_age], "relationship")


func trigger_death(cause: String) -> void:
	PlayerData.health = 0
	PlayerData.is_dead = true
	PlayerData.cause_of_death = cause
	add_life_event("💀 You passed away at age %d. Cause of death: %s." % [PlayerData.age, cause], "death")
	update_ui()
	SaveManager.save_game()
	_show_death_screen(cause)


func add_life_event(text: String, kind: String = "event") -> void:
	if text.strip_edges() == "":
		return

	if life_feed.text.strip_edges() == "":
		life_feed.append_text(_format_life_entry(PlayerData.age, text))
	else:
		life_feed.append_text("\n\n" + _format_life_entry(PlayerData.age, text))

	PlayerData.add_life_log_entry(text, kind)
	_scroll_timeline_to_latest.call_deferred()


func rebuild_life_feed() -> void:
	life_feed.clear()

	for entry in PlayerData.life_log:
		var text_value: String = str(entry.get("text", ""))
		if text_value == "":
			continue

		var formatted_entry := _format_life_entry(int(entry.get("age", 0)), text_value)
		if life_feed.text.strip_edges() == "":
			life_feed.append_text(formatted_entry)
		else:
			life_feed.append_text("\n\n" + formatted_entry)

	_scroll_timeline_to_latest.call_deferred()


func _format_life_entry(entry_age: int, text: String) -> String:
	var year_word: String = "year" if entry_age == 1 else "years"
	return "[color=#38bdf8][b]Age: %d %s[/b][/color]\n%s" % [entry_age, year_word, text]


func _scroll_timeline_to_latest() -> void:
	if not is_inside_tree():
		return
	await get_tree().process_frame
	await get_tree().process_frame
	var bar := life_feed.get_v_scroll_bar()
	bar.value = maxf(bar.min_value, bar.max_value - bar.page)


func _scroll_after_layout() -> void:
	_scroll_timeline_to_latest.call_deferred()


func update_ui() -> void:
	_update_portrait()
	name_label.text = PlayerData.first_name
	phase_label.text = "%s %s" % [PlayerData.get_stage_icon(), PlayerData.get_stage_name()]
	balance_label.text = "$%s\nFunds" % _format_number(PlayerData.money + PlayerData.bank_savings)

	if nationality_flag != null and PlayerData.birthplace != "":
		nationality_flag.texture = CreationOptions.get_flag_for_country(PlayerData.birthplace)

	health_bar.value = PlayerData.health
	happiness_bar.value = PlayerData.happiness
	smarts_bar.value = PlayerData.smarts
	looks_bar.value = PlayerData.looks

	_update_stat_bar_color(health_bar, PlayerData.health, Color("#10b981"), Color("#047857"))
	_update_stat_bar_color(happiness_bar, PlayerData.happiness, Color("#f59e0b"), Color("#b45309"))
	_update_stat_bar_color(smarts_bar, PlayerData.smarts, Color("#0284c7"), Color("#1e3a8a"))
	_update_stat_bar_color(looks_bar, PlayerData.looks, Color("#db2777"), Color("#7e22ce"))

	# Update InfantButton icon with age progression (Strictly stage name, never occupation)
	if infant_button != null:
		var stage_icon_path := get_stage_icon_path(PlayerData.age)
		if ResourceLoader.exists(stage_icon_path):
			infant_button.icon = load(stage_icon_path)
		infant_button.text = PlayerData.get_stage_name()

	# If panels are open, refresh them
	if relationships_panel.visible:
		update_relationships_panel()
	if character_panel.visible:
		update_character_panel()


func _on_age_button_pressed() -> void:
	age_up()


func trigger_event() -> void:
	current_event = EventManager.get_random_event(
		PlayerData.age,
		PlayerData.event_history,
		PlayerData.get_stats()
	)

	if current_event == null:
		current_event_choices.clear()
		age_button.disabled = false
		return

	current_event_choices = generate_event_choices(current_event)
	show_event_popup()


func get_event_text(event: Dictionary) -> String:
	var variants: Array = event.get("text_variants", [])

	if not variants.is_empty():
		return str(variants.pick_random())

	return str(event.get("text", "Something happened."))


func generate_event_choices(event: Dictionary) -> Array:
	var all_choices: Array = event.get("choices", []).duplicate()
	all_choices.shuffle()

	var requested_count: int = int(event.get("choice_count", 3))
	var choice_count: int = min(requested_count, all_choices.size())

	return all_choices.slice(0, choice_count)


func _format_effects_summary(choice: Dictionary) -> String:
	if choice.has("description") and str(choice["description"]).strip_edges() != "":
		return str(choice["description"]).strip_edges()

	var effects: Dictionary = choice.get("effects", {})
	var parts: Array[String] = []
	if effects.has("karma") and effects["karma"] != 0:
		var v: int = int(effects["karma"])
		parts.append(("%+d Karma" if v > 0 else "%d Karma") % v)
	if effects.has("happiness") and effects["happiness"] != 0:
		var v: int = int(effects["happiness"])
		parts.append(("%+d Happiness" if v > 0 else "%d Happiness") % v)
	if effects.has("health") and effects["health"] != 0:
		var v: int = int(effects["health"])
		parts.append(("%+d Health" if v > 0 else "%d Health") % v)
	if effects.has("smarts") and effects["smarts"] != 0:
		var v: int = int(effects["smarts"])
		parts.append(("%+d Smarts" if v > 0 else "%d Smarts") % v)
	if effects.has("looks") and effects["looks"] != 0:
		var v: int = int(effects["looks"])
		parts.append(("%+d Looks" if v > 0 else "%d Looks") % v)
	if effects.has("money") and effects["money"] != 0:
		var v: int = int(effects["money"])
		parts.append(("$%+d Cash" if v > 0 else "$%d Cash") % v)

	if parts.is_empty():
		return "No major stat changes"
	return ", ".join(parts)


func show_event_popup() -> void:
	if event_overlay == null or event_description == null:
		push_error("Event popup nodes are missing.")
		current_event = null
		current_event_choices.clear()
		age_button.disabled = false
		return

	if event_title != null:
		event_title.text = str(current_event.get("title", "LIFE EVENT"))
		event_title.add_theme_color_override("font_color", Color("#00f0ff"))
		event_title.add_theme_font_size_override("font_size", 42)

	event_description.text = get_event_text(current_event) + "\n\nWhat do you do?"
	event_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_description.add_theme_font_size_override("normal_font_size", 30)
	event_description.add_theme_color_override("default_color", Color("#f8fafc"))

	event_overlay.visible = true
	age_button.disabled = true

	var buttons: Array[Button] = []
	for button in [event_choice_1, event_choice_2, event_choice_3, event_choice_4]:
		if button != null:
			buttons.append(button)
			button.visible = false

	for i in range(min(current_event_choices.size(), buttons.size())):
		var choice: Dictionary = current_event_choices[i]
		var title_text := str(choice.get("text", "Choose"))
		var desc_text := _format_effects_summary(choice)
		buttons[i].text = "%s\n%s" % [title_text, desc_text]
		buttons[i].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		buttons[i].add_theme_font_size_override("font_size", 21)
		buttons[i].custom_minimum_size.y = 100
		buttons[i].visible = true


func hide_event_popup() -> void:
	if event_overlay != null:
		event_overlay.visible = false


func choose_event_option(choice_index: int) -> void:
	if current_event == null:
		return

	if choice_index < 0 or choice_index >= current_event_choices.size():
		return

	var choice: Dictionary = current_event_choices[choice_index]
	var event_id: String = str(current_event.get("id", ""))
	var current_ev_title: String = str(current_event.get("title", ""))

	PlayerData.apply_effects(choice.get("effects", {}))

	var result_text: String = str(choice.get("result", ""))
	if result_text != "":
		add_life_event(result_text, "event")

	PlayerData.record_event(event_id)

	current_event = null
	current_event_choices.clear()
	hide_event_popup()
	age_button.disabled = false
	update_ui()
	SaveManager.save_game()

	# Unpredictable fatality / accident death check
	if PlayerData.health <= 0:
		var death_cause: String = _get_death_cause_from_event(event_id, current_ev_title, choice)
		trigger_death(death_cause)
		return


func _get_death_cause_from_event(ev_id: String, ev_title: String, _choice: Dictionary) -> String:
	match ev_id:
		"freak_car_crash":
			return "Fatal High-Speed Highway Collision"
		"joyriding_car":
			return "Fatal Joyriding Automobile Accident"
		"sudden_appendicitis":
			return "Ruptured Appendix & Septic Peritonitis"
		"heart_attack_warning":
			return "Acute Myocardial Infarction (Heart Attack)"
		"slip_and_fall":
			return "Fatal Traumatic Brain Injury from Fall"
		"dangerous_street_dare":
			return "Fatal Fall & Traumatic Physical Injuries"
		"office_whistleblower":
			return "Stress-Induced Acute Cardiac Arrest"
		"childhood_bicycle":
			return "Fatal Bicycle Collision & Head Trauma"
		"street_dog_encounter":
			return "Fatal Infection & Animal Attack Injuries"
		"highschool_fight":
			return "Fatal Physical Trauma from Altercation"
		"stray_kitten_rescue":
			return "Fatal Fall from Tree"

	if PlayerData.has_illness("cancer"):
		return "Untreated Stage 3 Lymphoma Cancer"

	if ev_title != "":
		var clean_title := ev_title.to_lower().capitalize()
		return "Fatal Incident during %s" % clean_title

	return "Critical Health Depletion & Physical Trauma"


func _on_event_choice_1_pressed() -> void:
	choose_event_option(0)


func _on_event_choice_2_pressed() -> void:
	choose_event_option(1)


func _on_event_choice_3_pressed() -> void:
	choose_event_option(2)


func _on_event_choice_4_pressed() -> void:
	choose_event_option(3)


func _on_settings_button_pressed() -> void:
	show_tab("settings")


func _on_close_settings_button_pressed() -> void:
	if settings_overlay != null:
		settings_overlay.visible = false
	show_tab("timeline")


func _on_reset_progress_button_pressed() -> void:
	if reset_confirmation_overlay != null:
		reset_confirmation_overlay.visible = true


func _on_cancel_reset_pressed() -> void:
	if reset_confirmation_overlay != null:
		reset_confirmation_overlay.visible = false


func _on_confirm_reset_pressed() -> void:
	if reset_confirmation_overlay != null:
		reset_confirmation_overlay.visible = false
	if settings_overlay != null:
		settings_overlay.visible = false

	SaveManager.delete_save()
	PlayerData.reset_player()

	current_event = null
	current_event_choices.clear()
	hide_event_popup()

	life_feed.clear()
	update_history_panel()
	update_character_panel()
	show_tab("timeline")
	show_new_game_screen()


func show_new_game_screen() -> void:
	if name_input != null:
		name_input.text = ""

	if birthplace_input != null:
		birthplace_input.select(8)

	if validation_label != null:
		validation_label.text = ""

	new_game_panel.visible = true


func hide_new_game_screen() -> void:
	new_game_panel.visible = false


func _on_start_game_button_pressed() -> void:
	if name_input == null:
		push_error("NameInput could not be found.")
		return

	if birthplace_input == null:
		push_error("BirthplaceInput could not be found.")
		return

	if validation_label == null:
		push_error("ValidationLabel could not be found.")
		return

	var entered_name: String = CreationOptions.normalize_name(name_input.text)
	var selected_country: String = birthplace_input.get_item_text(birthplace_input.selected)

	if entered_name == "":
		validation_label.text = "Please enter your name."
		return

	validation_label.text = ""

	PlayerData.reset_player()

	PlayerData.first_name = entered_name
	PlayerData.birthplace = selected_country
	PlayerData.gender = "MALE" if gender_input.selected == 0 else "FEMALE"
	PlayerData.portrait_variant = randi_range(0, 1)
	PlayerData.has_started_game = true

	# Generate rich, unique BitLife-style birth description & family background
	var profile: Dictionary = BirthStoryGenerator.generate_profile(
		entered_name,
		selected_country,
		PlayerData.gender
	)
	PlayerData.birth_story = str(profile.get("story", ""))
	PlayerData.birth_month = str(profile.get("birth_month", "January"))
	PlayerData.birth_day = int(profile.get("birth_day", 1))
	PlayerData.zodiac = str(profile.get("zodiac", "Capricorn"))
	PlayerData.mother_name = str(profile.get("mother_name", ""))
	PlayerData.mother_job = str(profile.get("mother_job", ""))
	PlayerData.mother_base_age = int(profile.get("mother_age", 35))
	PlayerData.father_name = str(profile.get("father_name", ""))
	PlayerData.father_job = str(profile.get("father_job", ""))
	PlayerData.father_base_age = int(profile.get("father_age", 37))

	hide_new_game_screen()

	life_feed.clear()

	# Add newborn character description to feed
	add_life_event(PlayerData.birth_story, "milestone")

	update_ui()
	update_history_panel()
	update_character_panel()
	update_relationships_panel()

	SaveManager.save_game()


func show_tab(tab_name: String) -> void:
	timeline_panel.visible = tab_name == "timeline"
	character_panel.visible = tab_name == "character"
	infant_panel.visible = tab_name == "infant"
	assets_panel.visible = tab_name == "assets"
	bank_panel.visible = tab_name == "bank"
	relationships_panel.visible = tab_name == "relationships"
	activities_panel.visible = tab_name == "activities"

	if tab_name == "settings":
		if settings_overlay != null:
			settings_overlay.visible = true
		return

	if tab_name == "character":
		update_character_panel()
	elif tab_name == "infant":
		update_infant_panel()
	elif tab_name == "assets":
		update_assets_panel()
	elif tab_name == "bank":
		update_bank_panel()
	elif tab_name == "relationships":
		update_relationships_panel()
	elif tab_name == "activities":
		_configure_button_contrasts()


# Avatar Button clicked -> opens Character profile panel!
func _on_avatar_button_pressed() -> void:
	show_tab("character")


func _on_settings_nav_button_pressed() -> void:
	show_tab("settings")


# 4 Action button signal handlers
func _on_infant_button_pressed() -> void:
	show_tab("infant")


func _on_assets_button_pressed() -> void:
	show_tab("assets")


func _on_relationships_button_pressed() -> void:
	show_tab("relationships")


func _on_activities_button_pressed() -> void:
	if PlayerData.age < 3:
		if PlayerData.age == 0:
			add_life_event("🍼 Infant: You are an infant! Infants spend their time sleeping, crying, and babbling. Tap the AGE button to grow up!", "event")
		else:
			add_life_event("🧸 Toddler: You are %d years old. Structured activities and Kindergarten unlock at age 3—tap the AGE button to play and grow!" % PlayerData.age, "event")
		return
	show_tab("activities")


# Panel Close & Back handlers
func _on_close_panel_button_pressed() -> void:
	show_tab("timeline")


func _on_bank_button_pressed() -> void:
	if PlayerData.age < 13:
		add_life_event("🏦 Banking accounts unlock at age 13 for youth accounts.", "finance")
		return
	show_tab("bank")


func _on_back_to_assets_button_pressed() -> void:
	show_tab("assets")


func _is_life_milestone(entry: Dictionary) -> bool:
	if str(entry.get("kind", "")) == "milestone":
		return true

	var txt := str(entry.get("text", "")).to_lower()
	if "born" in txt and ("world" in txt or "parents" in txt or "hospital" in txt or "birth" in txt):
		return true
	if "enrolled in kindergarten" in txt:
		return true
	if "entered primary school" in txt or "entered middle school" in txt or "entered high school" in txt:
		return true
	if "graduated from high school" in txt or "graduated from university" in txt:
		return true
	if "diploma earned" in txt:
		return true
	if "enrolled at" in txt or "enrolled in university" in txt:
		return true
	if "started working as" in txt:
		return true
	if "passed away" in txt:
		return true
	if "scholarship awarded" in txt:
		return true
	if "released from prison" in txt:
		return true
	if "diagnosed with" in txt:
		return true
	if "cured of" in txt:
		return true

	return false


func _is_routine_event(entry: Dictionary) -> bool:
	var txt := str(entry.get("text", "")).strip_edges().to_lower()
	if txt.is_empty():
		return true
	if txt.begins_with("you turned ") or txt.begins_with("you aged "):
		return true
	if txt.begins_with("you received your annual salary of"):
		return true
	if txt.begins_with("you paid your annual basic living"):
		return true
	if txt.begins_with("you paid your annual income tax"):
		return true
	if "bank loan accrued" in txt:
		return true
	if "bank savings account accrued" in txt:
		return true
	if "you finished year " in txt and "at university" in txt:
		return true
	if "you served another year behind bars" in txt:
		return true
	return false


func _is_unique_life_event(entry: Dictionary) -> bool:
	if _is_routine_event(entry):
		return false
	if _is_life_milestone(entry):
		return false
	return true


func _update_history_filter_buttons() -> void:
	var active_color := Color("#00f0ff")
	var normal_color := Color("#94a3b8")
	var active_bg := Color("#0e2f44")
	var normal_bg := Color("#091122")

	var btns := [
		{"btn": filter_all_btn, "key": "all", "text": "🌟 All Highlights"},
		{"btn": filter_milestones_btn, "key": "milestones", "text": "🏆 Life Milestones"},
		{"btn": filter_unique_btn, "key": "unique", "text": "✨ Unique Events"}
	]

	for item in btns:
		var btn: Button = item["btn"]
		if btn == null:
			continue
		var is_selected: bool = (overview_history_filter == item["key"])
		btn.text = item["text"]
		var style := StyleBoxFlat.new()
		style.bg_color = active_bg if is_selected else normal_bg
		style.border_color = active_color if is_selected else Color("#1e3a5f")
		style.set_border_width_all(2)
		style.set_corner_radius_all(6)
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("hover", style)
		btn.add_theme_stylebox_override("pressed", style)
		btn.add_theme_stylebox_override("focus", style)
		btn.add_theme_color_override("font_color", Color("#ffffff") if is_selected else normal_color)


func _on_filter_all_pressed() -> void:
	overview_history_filter = "all"
	_update_history_filter_buttons()
	update_history_panel()


func _on_filter_milestones_pressed() -> void:
	overview_history_filter = "milestones"
	_update_history_filter_buttons()
	update_history_panel()


func _on_filter_unique_pressed() -> void:
	overview_history_filter = "unique"
	_update_history_filter_buttons()
	update_history_panel()


func update_history_panel() -> void:
	if history_list == null:
		return

	for child in history_list.get_children():
		history_list.remove_child(child)
		child.queue_free()

	var count := 0
	for entry in PlayerData.life_log:
		var is_milestone: bool = _is_life_milestone(entry)
		var is_unique: bool = _is_unique_life_event(entry)

		if overview_history_filter == "milestones" and not is_milestone:
			continue
		elif overview_history_filter == "unique" and not is_unique:
			continue
		elif overview_history_filter == "all" and not (is_milestone or is_unique):
			continue

		count += 1
		var card := PanelContainer.new()
		var card_style := StyleBoxFlat.new()
		if is_milestone:
			card_style.bg_color = Color("#17120a")
			card_style.border_color = Color("#f59e0b")
		else:
			card_style.bg_color = Color("#091122")
			card_style.border_color = Color("#1e3a5f")
		card_style.set_border_width_all(2)
		card_style.set_corner_radius_all(8)
		card.add_theme_stylebox_override("panel", card_style)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 20)
		margin.add_theme_constant_override("margin_right", 20)
		margin.add_theme_constant_override("margin_top", 14)
		margin.add_theme_constant_override("margin_bottom", 14)
		card.add_child(margin)

		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 6)
		margin.add_child(vbox)

		var header_hbox := HBoxContainer.new()
		vbox.add_child(header_hbox)

		var badge_lbl := Label.new()
		if is_milestone:
			badge_lbl.text = "🏆 LIFE MILESTONE"
			badge_lbl.add_theme_color_override("font_color", Color("#fbbf24"))
		else:
			badge_lbl.text = "✨ UNIQUE EVENT"
			badge_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
		badge_lbl.add_theme_font_size_override("font_size", 20)
		badge_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header_hbox.add_child(badge_lbl)

		var age_lbl := Label.new()
		age_lbl.text = "AGE %d" % int(entry.get("age", 0))
		age_lbl.add_theme_font_size_override("font_size", 20)
		age_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
		header_hbox.add_child(age_lbl)

		var desc_lbl := Label.new()
		desc_lbl.text = str(entry.get("text", ""))
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.add_theme_font_size_override("font_size", 22)
		desc_lbl.add_theme_color_override("font_color", Color("#f8fafc"))
		vbox.add_child(desc_lbl)

		history_list.add_child(card)

	if count == 0:
		var empty := Label.new()
		if overview_history_filter == "milestones":
			empty.text = "No life milestones reached yet.\nEnrolling in school, graduating, starting a career, or key achievements will appear here!"
		elif overview_history_filter == "unique":
			empty.text = "No unique life events recorded yet.\nRandom occurrences, critical decisions, and special encounters will appear here!"
		else:
			empty.text = "No life events recorded yet.\nYour milestones, achievements, and unique choices will appear here."
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty.add_theme_font_size_override("font_size", 24)
		empty.add_theme_color_override("font_color", Color("#94a3b8"))
		history_list.add_child(empty)


func update_character_panel() -> void:
	if character_name != null:
		character_name.text = "Name: %s" % PlayerData.first_name
	if character_stage != null:
		character_stage.text = "Stage: %s %s (Age %d)" % [PlayerData.get_stage_icon(), PlayerData.get_stage_name(), PlayerData.age]
	if character_birthplace != null:
		character_birthplace.text = "Born in: %s" % PlayerData.birthplace
	if character_birthday != null:
		character_birthday.text = "Birthday: %s %d • %s" % [PlayerData.birth_month, PlayerData.birth_day, PlayerData.zodiac]

	if character_mother != null:
		if PlayerData.mother_name != "":
			var mom_age: int = PlayerData.mother_base_age + PlayerData.age
			character_mother.text = "Mother: %s, %s (age %d)" % [PlayerData.mother_name, PlayerData.mother_job, mom_age]
		else:
			character_mother.text = "Mother: Unknown"

	if character_father != null:
		if PlayerData.father_name != "" and PlayerData.father_name != "Unknown":
			var dad_age: int = PlayerData.father_base_age + PlayerData.age
			character_father.text = "Father: %s, %s (age %d)" % [PlayerData.father_name, PlayerData.father_job, dad_age]
		else:
			character_father.text = "Father: Unknown (Single mother)"

	if character_story != null:
		character_story.text = PlayerData.birth_story if PlayerData.birth_story != "" else "Born into the world."

	if character_money != null:
		character_money.text = "Cash: $%s • Savings: $%s" % [_format_number(PlayerData.money), _format_number(PlayerData.bank_savings)]

	if character_karma != null:
		var karma_prefix: String = "+" if PlayerData.karma > 0 else ""
		character_karma.text = "Karma: %s%d" % [karma_prefix, PlayerData.karma]


func update_infant_panel() -> void:
	var infant_title: Label = get_node_or_null("InfantPanel/InfantMargin/InfantContent/InfantHeaderRow/InfantTitle")
	if infant_title != null:
		infant_title.text = "%s & LIFE OVERVIEW" % PlayerData.get_stage_name().to_upper()

	# 1. Life Stage: NAME AND AGE
	if current_stage_label != null:
		var name_str: String = PlayerData.first_name if PlayerData.first_name != "" else "Character"
		current_stage_label.text = "👤 %s  •  %s %s (Age %d)" % [name_str, PlayerData.get_stage_icon(), PlayerData.get_stage_name(), PlayerData.age]

	# 4. CURRENT JOB
	if current_job_label != null:
		if PlayerData.job_title != "":
			current_job_label.text = "💼 Current Job: %s at %s ($%s/yr)" % [PlayerData.job_title, PlayerData.job_company, _format_number(PlayerData.job_salary)]
			current_job_label.add_theme_color_override("font_color", Color("#34d399"))
		else:
			current_job_label.text = "💼 Current Job: Unemployed"
			current_job_label.add_theme_color_override("font_color", Color("#94a3b8"))

	# 5. CURRENT EDUCATION LEVEL
	if current_edu_label != null:
		current_edu_label.text = "🎓 Current Education: %s" % PlayerData.get_education_display_string()

	# 6. CURRENT GRADES & GRADES PROGRESS BAR
	if grades_label != null:
		if PlayerData.age < 3:
			grades_label.text = "📊 Academic Readiness: %d%% • Kindergarten begins at Age 3" % PlayerData.grades
			grades_label.add_theme_color_override("font_color", Color("#38bdf8"))
		else:
			var standing: String = "Honor Roll" if PlayerData.grades >= 85 else ("Satisfactory" if PlayerData.grades >= 70 else ("Passing" if PlayerData.grades >= 55 else "Failing"))
			grades_label.text = "📊 Current Grades: %d%% (%s) • %s" % [PlayerData.grades, PlayerData.get_letter_grade(), standing]
			var g_color: Color = Color("#10b981") if PlayerData.grades >= 85 else (Color("#38bdf8") if PlayerData.grades >= 70 else (Color("#fbbf24") if PlayerData.grades >= 55 else Color("#ef4444")))
			grades_label.add_theme_color_override("font_color", g_color)

	if grades_progress_bar != null:
		grades_progress_bar.value = PlayerData.grades
		if PlayerData.grades >= 85:
			_update_stat_bar_color(grades_progress_bar, PlayerData.grades, Color("#10b981"), Color("#059669"))
		elif PlayerData.grades >= 70:
			_update_stat_bar_color(grades_progress_bar, PlayerData.grades, Color("#38bdf8"), Color("#0284c7"))
		elif PlayerData.grades >= 55:
			_update_stat_bar_color(grades_progress_bar, PlayerData.grades, Color("#f59e0b"), Color("#b45309"))
		else:
			_update_stat_bar_color(grades_progress_bar, PlayerData.grades, Color("#ef4444"), Color("#991b1b"))

	_update_history_filter_buttons()
	update_history_panel()


func apply_for_job(job_id: String) -> void:
	var job: Dictionary = JobManager.get_job_by_id(job_id)
	if job.is_empty():
		return

	var eval: Dictionary = JobManager.can_apply(job, PlayerData.age, PlayerData.get_stats(), {
		"grades": PlayerData.grades,
		"education_level": PlayerData.education_level,
		"major": PlayerData.university_major,
		"university_name": PlayerData.university_name
	})
	if not bool(eval.get("allowed", false)):
		return

	PlayerData.job_id = str(job.get("id", ""))
	PlayerData.job_title = str(job.get("title", ""))
	PlayerData.job_company = str(job.get("workplace", ""))
	PlayerData.job_salary = int(job.get("salary", 0))

	add_life_event("You started working as a %s at %s ($%s/yr)." % [
		PlayerData.job_title,
		PlayerData.job_company,
		_format_number(PlayerData.job_salary)
	], "milestone")
	update_ui()
	SaveManager.save_game()


func quit_job() -> void:
	if PlayerData.job_title == "":
		return

	var old_title: String = PlayerData.job_title
	PlayerData.job_id = ""
	PlayerData.job_title = ""
	PlayerData.job_company = ""
	PlayerData.job_salary = 0

	add_life_event("You resigned from your position as %s. You are now unemployed." % old_title, "job")
	update_ui()
	SaveManager.save_game()


func update_assets_panel() -> void:
	assets_cash_label.text = "Cash on Hand: $%s\nBank Savings: $%s\nTotal Net Worth: $%s" % [
		_format_number(PlayerData.money),
		_format_number(PlayerData.bank_savings),
		_format_number(PlayerData.get_net_worth())
	]
	_configure_button_contrasts()


func load_style_box_cyber_card(border_col: Color = Color("#22d3ee")) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#090f1d")
	style.border_color = border_col
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	style.shadow_color = Color(0, 0, 0, 0.6)
	style.shadow_size = 10
	return style


func update_bank_panel() -> void:
	bank_checking_label.text = "Checking (Cash): $%s   •   Savings: $%s" % [
		_format_number(PlayerData.money),
		_format_number(PlayerData.bank_savings)
	]

	if bank_list == null:
		return

	# Remove any previous dynamic cards added to bank_list (keep the first BankCard intact)
	for i in range(bank_list.get_child_count() - 1, 0, -1):
		var child: Node = bank_list.get_child(i)
		bank_list.remove_child(child)
		child.queue_free()

	# 1. High-Yield Savings Card
	var savings_card := PanelContainer.new()
	savings_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#10b981")))
	var sm := MarginContainer.new()
	sm.add_theme_constant_override("margin_left", 28)
	sm.add_theme_constant_override("margin_right", 28)
	sm.add_theme_constant_override("margin_top", 24)
	sm.add_theme_constant_override("margin_bottom", 24)
	savings_card.add_child(sm)

	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 10)
	sm.add_child(sv)

	var sav_title := Label.new()
	sav_title.text = "🏦 HIGH-YIELD SAVINGS ACCOUNT (2.5% APR)"
	sav_title.add_theme_font_size_override("font_size", 28)
	sav_title.add_theme_color_override("font_color", Color("#34d399"))
	sv.add_child(sav_title)

	var sav_bal := Label.new()
	sav_bal.text = "• Savings Balance: $%s  (Protected for Inheritance)\n• Pocket Cash: $%s" % [
		_format_number(PlayerData.bank_savings),
		_format_number(PlayerData.money)
	]
	sav_bal.add_theme_font_size_override("font_size", 24)
	sav_bal.add_theme_color_override("font_color", Color("#f8fafc"))
	sv.add_child(sav_bal)

	var dep_title := Label.new()
	dep_title.text = "Deposit Cash into Savings Account:"
	dep_title.add_theme_font_size_override("font_size", 22)
	dep_title.add_theme_color_override("font_color", Color("#38bdf8"))
	sv.add_child(dep_title)

	var dep_row := HBoxContainer.new()
	dep_row.add_theme_constant_override("separation", 8)
	sv.add_child(dep_row)

	var btn_dep_100 := _create_cyber_button("Deposit $100", Color("#10b981"), func(): _deposit_money(100))
	btn_dep_100.disabled = PlayerData.money < 100
	dep_row.add_child(btn_dep_100)

	var btn_dep_1k := _create_cyber_button("Deposit $1,000", Color("#10b981"), func(): _deposit_money(1000))
	btn_dep_1k.disabled = PlayerData.money < 1000
	dep_row.add_child(btn_dep_1k)

	var btn_dep_all := _create_cyber_button("Deposit All", Color("#10b981"), func(): _deposit_money(PlayerData.money))
	btn_dep_all.disabled = PlayerData.money <= 0
	dep_row.add_child(btn_dep_all)

	var wth_title := Label.new()
	wth_title.text = "Withdraw Cash from Savings Account:"
	wth_title.add_theme_font_size_override("font_size", 22)
	wth_title.add_theme_color_override("font_color", Color("#fbbf24"))
	sv.add_child(wth_title)

	var wth_row := HBoxContainer.new()
	wth_row.add_theme_constant_override("separation", 8)
	sv.add_child(wth_row)

	var btn_wth_100 := _create_cyber_button("Withdraw $100", Color("#fbbf24"), func(): _withdraw_money(100))
	btn_wth_100.disabled = PlayerData.bank_savings < 100
	wth_row.add_child(btn_wth_100)

	var btn_wth_1k := _create_cyber_button("Withdraw $1,000", Color("#fbbf24"), func(): _withdraw_money(1000))
	btn_wth_1k.disabled = PlayerData.bank_savings < 1000
	wth_row.add_child(btn_wth_1k)

	var btn_wth_all := _create_cyber_button("Withdraw All", Color("#fbbf24"), func(): _withdraw_money(PlayerData.bank_savings))
	btn_wth_all.disabled = PlayerData.bank_savings <= 0
	wth_row.add_child(btn_wth_all)

	bank_list.add_child(savings_card)

	# 2. Debt & Loan Summary Card
	var summary_card := PanelContainer.new()
	summary_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#38bdf8")))
	var summary_margin := MarginContainer.new()
	summary_margin.add_theme_constant_override("margin_left", 28)
	summary_margin.add_theme_constant_override("margin_right", 28)
	summary_margin.add_theme_constant_override("margin_top", 24)
	summary_margin.add_theme_constant_override("margin_bottom", 24)
	summary_card.add_child(summary_margin)

	var summary_vbox := VBoxContainer.new()
	summary_vbox.add_theme_constant_override("separation", 10)
	summary_margin.add_child(summary_vbox)

	var sum_title := Label.new()
	sum_title.text = "💳 LIABILITIES & DEBT OVERVIEW"
	sum_title.add_theme_font_size_override("font_size", 28)
	sum_title.add_theme_color_override("font_color", Color("#38bdf8"))
	summary_vbox.add_child(sum_title)

	var loan_lbl := Label.new()
	loan_lbl.text = "• Active Bank Loan: $%s  (@ %d%% APR)" % [_format_number(PlayerData.loan_balance), int(PlayerData.loan_interest_rate * 100)]
	loan_lbl.add_theme_font_size_override("font_size", 24)
	loan_lbl.add_theme_color_override("font_color", Color("#f8fafc"))
	summary_vbox.add_child(loan_lbl)

	var tax_lbl := Label.new()
	tax_lbl.text = "• Unpaid Tax Debt: $%s" % _format_number(PlayerData.debt)
	tax_lbl.add_theme_font_size_override("font_size", 24)
	tax_lbl.add_theme_color_override("font_color", Color("#f87171") if PlayerData.debt > 0 else Color("#f8fafc"))
	summary_vbox.add_child(tax_lbl)

	var total_debt_lbl := Label.new()
	total_debt_lbl.text = "• Total Debt Burden: $%s" % _format_number(PlayerData.get_total_debt())
	total_debt_lbl.add_theme_font_size_override("font_size", 26)
	total_debt_lbl.add_theme_color_override("font_color", Color("#ef4444") if PlayerData.get_total_debt() > 0 else Color("#22c55e"))
	summary_vbox.add_child(total_debt_lbl)

	bank_list.add_child(summary_card)

	# 2. Bank Loans Borrowing Card
	var loan_card := PanelContainer.new()
	loan_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#38bdf8")))
	var loan_margin := MarginContainer.new()
	loan_margin.add_theme_constant_override("margin_left", 28)
	loan_margin.add_theme_constant_override("margin_right", 28)
	loan_margin.add_theme_constant_override("margin_top", 24)
	loan_margin.add_theme_constant_override("margin_bottom", 24)
	loan_card.add_child(loan_margin)

	var loan_vbox := VBoxContainer.new()
	loan_vbox.add_theme_constant_override("separation", 12)
	loan_margin.add_child(loan_vbox)

	var loan_title := Label.new()
	loan_title.text = "🏦 BORROW FUNDS (INSTANT BANK LOANS)"
	loan_title.add_theme_font_size_override("font_size", 28)
	loan_title.add_theme_color_override("font_color", Color("#38bdf8"))
	loan_vbox.add_child(loan_title)

	var loan_tiers := [
		["Borrow $1,000 (Micro Advance • 5% APR)", 1000, 0.05],
		["Borrow $5,000 (Personal Loan • 7% APR)", 5000, 0.07],
		["Borrow $25,000 (Major Commercial • 8% APR)", 25000, 0.08],
		["Borrow $100,000 (Executive Capital • 10% APR)", 100000, 0.10]
	]

	for tier in loan_tiers:
		var btn := _create_cyber_button(tier[0], Color("#38bdf8"), func(): _borrow_loan(tier[1], tier[2]))
		loan_vbox.add_child(btn)

	bank_list.add_child(loan_card)

	# 3. Debt Repayment Card
	var repay_card := PanelContainer.new()
	repay_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#22c55e")))
	var repay_margin := MarginContainer.new()
	repay_margin.add_theme_constant_override("margin_left", 28)
	repay_margin.add_theme_constant_override("margin_right", 28)
	repay_margin.add_theme_constant_override("margin_top", 24)
	repay_margin.add_theme_constant_override("margin_bottom", 24)
	repay_card.add_child(repay_margin)

	var repay_vbox := VBoxContainer.new()
	repay_vbox.add_theme_constant_override("separation", 12)
	repay_margin.add_child(repay_vbox)

	var repay_title := Label.new()
	repay_title.text = "💸 REPAY OUTSTANDING DEBT & LOANS"
	repay_title.add_theme_font_size_override("font_size", 28)
	repay_title.add_theme_color_override("font_color", Color("#22c55e"))
	repay_vbox.add_child(repay_title)

	var btn_pay_1k := _create_cyber_button("Repay $1,000", Color("#22c55e"), func(): _repay_debt(1000))
	btn_pay_1k.disabled = PlayerData.money < 1000 or PlayerData.get_total_debt() <= 0
	repay_vbox.add_child(btn_pay_1k)

	var btn_pay_all := _create_cyber_button("Repay Full Debt ($%s)" % _format_number(PlayerData.get_total_debt()), Color("#22c55e"), func(): _repay_debt(PlayerData.get_total_debt()))
	btn_pay_all.disabled = PlayerData.money < PlayerData.get_total_debt() or PlayerData.get_total_debt() <= 0
	repay_vbox.add_child(btn_pay_all)

	bank_list.add_child(repay_card)


func _borrow_loan(amount: int, interest_rate: float) -> void:
	PlayerData.money += amount
	PlayerData.loan_balance += amount
	PlayerData.loan_interest_rate = interest_rate
	add_life_event("You approved a $%s loan from First National Pixel Bank (Interest: %d%% APR)." % [
		_format_number(amount),
		int(interest_rate * 100)
	], "finance")
	update_ui()
	update_bank_panel()
	SaveManager.save_game()


func _repay_debt(amount: int) -> void:
	var total_debt: int = PlayerData.get_total_debt()
	if total_debt <= 0 or PlayerData.money <= 0:
		return

	var pay_amount: int = mini(amount, mini(PlayerData.money, total_debt))
	PlayerData.money -= pay_amount

	# Pay tax debt first, then loan balance
	var remaining_pay: int = pay_amount
	if PlayerData.debt > 0:
		var paid_tax: int = mini(remaining_pay, PlayerData.debt)
		PlayerData.debt -= paid_tax
		remaining_pay -= paid_tax

	if remaining_pay > 0 and PlayerData.loan_balance > 0:
		var paid_loan: int = mini(remaining_pay, PlayerData.loan_balance)
		PlayerData.loan_balance -= paid_loan
		remaining_pay -= paid_loan

	add_life_event("You paid $%s towards your outstanding liabilities (Remaining Debt: $%s)." % [
		_format_number(pay_amount),
		_format_number(PlayerData.get_total_debt())
	], "finance")
	update_ui()
	update_bank_panel()
	SaveManager.save_game()


func _deposit_money(amount: int) -> void:
	if amount <= 0:
		return
	var actual := mini(amount, PlayerData.money)
	if actual <= 0:
		add_life_event("You do not have any cash on hand to deposit.", "finance")
		return
	PlayerData.money -= actual
	PlayerData.bank_savings += actual
	add_life_event("You deposited $%s into your high-yield bank savings account." % _format_number(actual), "finance")
	update_ui()
	update_bank_panel()
	SaveManager.save_game()


func _withdraw_money(amount: int) -> void:
	if amount <= 0:
		return
	var actual := mini(amount, PlayerData.bank_savings)
	if actual <= 0:
		add_life_event("You do not have any funds in your savings account to withdraw.", "finance")
		return
	PlayerData.bank_savings -= actual
	PlayerData.money += actual
	add_life_event("You withdrew $%s from your bank savings account." % _format_number(actual), "finance")
	update_ui()
	update_bank_panel()
	SaveManager.save_game()


func _relationship_status_text(val: int) -> String:
	if val >= 80:
		return "Warm & Loving (%d%%)" % val
	elif val >= 55:
		return "Good (%d%%)" % val
	elif val >= 30:
		return "Neutral (%d%%)" % val
	else:
		return "Strained (%d%%)" % val


func _setup_parent_action_row(vbox: VBoxContainer, parent_type: String) -> void:
	var row_name := parent_type.capitalize() + "ActionRow"
	var existing_row := vbox.get_node_or_null(row_name)
	if existing_row != null:
		existing_row.queue_free()

	var is_mother := parent_type == "mother"
	var is_alive := PlayerData.mother_alive if is_mother else PlayerData.father_alive
	if not is_alive:
		return

	var row := HBoxContainer.new()
	row.name = row_name
	row.add_theme_constant_override("separation", 8)

	var actions := [
		["Spend Time", "spend_time", "#0284c7"],
		["Compliment", "compliment", "#8b5cf6"],
		["Ask Money", "ask_money", "#10b981"]
	]

	# Age Gating: Infants and kids cannot pay for parents' medication (requires age >= 13)
	if PlayerData.age >= 13:
		actions.append(["🏥 Pay Meds ($800)", "pay_medication", "#ec4899"])

	# Doctor Occupation Special Perk: Care for parents' health with clinical checkup & vitamin shots
	# NOTE: Plastic surgery is STRICTLY PROHIBITED on parents per requirements
	if PlayerData.is_doctor():
		actions.append(["🩺 Doctor Checkup (Free)", "doctor_checkup", "#06b6d4"])
		actions.append(["💉 Vitamin Shot ($30)", "doctor_vitamin_shot", "#10b981"])

	for act in actions:
		var btn := Button.new()
		btn.text = act[0]
		btn.custom_minimum_size.y = 48
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_font_size_override("font_size", 18)

		var style := StyleBoxFlat.new()
		style.bg_color = Color("#1e293b")
		style.border_color = Color(act[2])
		style.set_border_width_all(2)
		style.set_corner_radius_all(6)
		btn.add_theme_stylebox_override("normal", style)

		var hover := style.duplicate() as StyleBoxFlat
		hover.bg_color = Color(act[2])
		hover.bg_color.a = 0.3
		btn.add_theme_stylebox_override("hover", hover)

		btn.add_theme_color_override("font_color", Color("#f1f5f9"))
		var act_key: String = act[1]
		btn.pressed.connect(func(): _interact_parent(parent_type, act_key))
		row.add_child(btn)

	vbox.add_child(row)


func _interact_parent(parent_type: String, action: String) -> void:
	var is_mother := parent_type == "mother"
	var parent_name := PlayerData.mother_name if is_mother else PlayerData.father_name
	var role := "mother" if is_mother else "father"

	match action:
		"spend_time":
			var rel_gain := randi_range(6, 12)
			var happy_gain := randi_range(4, 9)
			if is_mother:
				PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + rel_gain)
			else:
				PlayerData.father_relationship = mini(100, PlayerData.father_relationship + rel_gain)
			PlayerData.happiness = mini(100, PlayerData.happiness + happy_gain)
			add_life_event("You spent quality time chatting and hanging out with your %s, %s." % [role, parent_name], "relationship")

		"compliment":
			var rel_gain := randi_range(4, 8)
			if is_mother:
				PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + rel_gain)
			else:
				PlayerData.father_relationship = mini(100, PlayerData.father_relationship + rel_gain)
			PlayerData.karma = mini(100, PlayerData.karma + 2)
			PlayerData.happiness = mini(100, PlayerData.happiness + 2)
			add_life_event("You gave your %s, %s, a heartfelt compliment. They beamed with joy!" % [role, parent_name], "relationship")

		"ask_money":
			var rel := PlayerData.mother_relationship if is_mother else PlayerData.father_relationship
			if rel >= 40:
				var amount := randi_range(15, 60) if PlayerData.age < 18 else randi_range(30, 120)
				PlayerData.money += amount
				PlayerData.happiness = mini(100, PlayerData.happiness + 3)
				add_life_event("You asked your %s, %s, for some pocket cash. They happily gave you $%d!" % [role, parent_name, amount], "relationship")
			else:
				if is_mother:
					PlayerData.mother_relationship = maxi(0, PlayerData.mother_relationship - 3)
				else:
					PlayerData.father_relationship = maxi(0, PlayerData.father_relationship - 3)
				add_life_event("You asked your %s for money, but they lectured you about being responsible and gave you nothing." % role, "relationship")

		"pay_medication":
			if PlayerData.money >= 800:
				PlayerData.money -= 800
				var new_health: int = 0
				if is_mother:
					PlayerData.mother_health = mini(100, PlayerData.mother_health + 20)
					PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + 10)
					new_health = PlayerData.mother_health
				else:
					PlayerData.father_health = mini(100, PlayerData.father_health + 20)
					PlayerData.father_relationship = mini(100, PlayerData.father_relationship + 10)
					new_health = PlayerData.father_health
				PlayerData.karma += 4
				add_life_event("You paid $800 for your %s's medical prescriptions. Their condition stabilized to %d%%." % [role, new_health], "relationship")
			else:
				add_life_event("You didn't have enough money ($800 required) to pay for your %s's medication." % role, "relationship")

		"doctor_checkup":
			var health_boost := 15
			var rel_boost := 10
			if is_mother:
				PlayerData.mother_health = mini(100, PlayerData.mother_health + health_boost)
				PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + rel_boost)
			else:
				PlayerData.father_health = mini(100, PlayerData.father_health + health_boost)
				PlayerData.father_relationship = mini(100, PlayerData.father_relationship + rel_boost)
			PlayerData.karma = mini(100, PlayerData.karma + 3)
			add_life_event("Applying your medical doctor credentials, you gave your %s a thorough clinical examination. Their vitals improved (+%d%% Health)." % [role, health_boost], "relationship")

		"doctor_vitamin_shot":
			if PlayerData.money >= 30:
				PlayerData.money -= 30
				var health_boost := 10
				var rel_boost := 6
				if is_mother:
					PlayerData.mother_health = mini(100, PlayerData.mother_health + health_boost)
					PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + rel_boost)
				else:
					PlayerData.father_health = mini(100, PlayerData.father_health + health_boost)
					PlayerData.father_relationship = mini(100, PlayerData.father_relationship + rel_boost)
				PlayerData.karma = mini(100, PlayerData.karma + 2)
				add_life_event("You administered a clinical vitamin & nutrient infusion to your %s ($30 at-cost). Health +%d%%." % [role, health_boost], "relationship")
			else:
				add_life_event("You didn't have enough funds ($30 wholesale) for the vitamin infusion.", "relationship")

	update_ui()
	update_relationships_panel()
	show_tab("timeline")
	SaveManager.save_game()


func update_relationships_panel() -> void:
	var mom_age: int = PlayerData.mother_base_age + PlayerData.age
	var mom_vbox := mother_name_label.get_parent() as VBoxContainer

	if PlayerData.mother_alive:
		if PlayerData.mother_name != "":
			mother_name_label.text = "Mother: %s (Age %d)" % [PlayerData.mother_name, mom_age]
			mother_job_label.text = "Occupation: %s" % PlayerData.mother_job
		else:
			mother_name_label.text = "Mother: Unknown (Age %d)" % mom_age
			mother_job_label.text = "Occupation: Homemaker"
		mother_status_label.text = "Health: %d%%  •  Relationship: %s" % [PlayerData.mother_health, _relationship_status_text(PlayerData.mother_relationship)]
		mother_status_label.add_theme_color_override("font_color", Color("#22c55e") if PlayerData.mother_health > 35 else Color("#f59e0b"))
		if mom_vbox != null:
			_setup_parent_action_row(mom_vbox, "mother")
	else:
		mother_name_label.text = "Mother: %s (Deceased)" % PlayerData.mother_name
		mother_job_label.text = "Occupation: In Memoriam"
		mother_status_label.text = "Status: Passed Away • Rest in Peace"
		mother_status_label.add_theme_color_override("font_color", Color("#94a3b8"))
		if mom_vbox != null:
			var act_row := mom_vbox.get_node_or_null("MotherActionRow")
			if act_row != null:
				act_row.queue_free()

	mother_icon.texture = PortraitCatalog.texture(mom_age, "FEMALE", 0)
	mother_icon.material = PortraitCatalog.cutout_material()

	# Father
	if PlayerData.father_name != "" and PlayerData.father_name != "Unknown":
		father_card.visible = true
		var dad_age: int = PlayerData.father_base_age + PlayerData.age
		var dad_vbox := father_name_label.get_parent() as VBoxContainer

		if PlayerData.father_alive:
			father_name_label.text = "Father: %s (Age %d)" % [PlayerData.father_name, dad_age]
			father_job_label.text = "Occupation: %s" % PlayerData.father_job
			father_status_label.text = "Health: %d%%  •  Relationship: %s" % [PlayerData.father_health, _relationship_status_text(PlayerData.father_relationship)]
			father_status_label.add_theme_color_override("font_color", Color("#22c55e") if PlayerData.father_health > 35 else Color("#f59e0b"))
			if dad_vbox != null:
				_setup_parent_action_row(dad_vbox, "father")
		else:
			father_name_label.text = "Father: %s (Deceased)" % PlayerData.father_name
			father_job_label.text = "Occupation: In Memoriam"
			father_status_label.text = "Status: Passed Away • Rest in Peace"
			father_status_label.add_theme_color_override("font_color", Color("#94a3b8"))
			if dad_vbox != null:
				var act_row := dad_vbox.get_node_or_null("FatherActionRow")
				if act_row != null:
					act_row.queue_free()

		father_icon.texture = PortraitCatalog.texture(dad_age, "MALE", 0)
		father_icon.material = PortraitCatalog.cutout_material()
	else:
		father_card.visible = false


# Activity Item Handlers
func _on_jobs_item_pressed() -> void:
	_show_jobs_modal()


func _on_education_item_pressed() -> void:
	_show_education_modal()


func _on_doctor_item_pressed() -> void:
	if PlayerData.age < 5:
		if PlayerData.age == 0:
			add_life_event("🍼 Infant healthcare is handled automatically by your parents.", "health")
		else:
			add_life_event("🧸 Toddler healthcare is handled automatically by your parents.", "health")
		show_tab("timeline")
		return
	_show_doctor_modal()


func _on_gym_item_pressed() -> void:
	if PlayerData.age < 13:
		add_life_event("🏋️ Gym facilities and athletic clubs require an age of at least 13 (Current age: %d)." % PlayerData.age, "activity")
		show_tab("timeline")
		return
	_show_gym_modal()


func _on_lottery_item_pressed() -> void:
	if PlayerData.age < 21:
		add_life_event("🚫 Underage: You must be at least 21 years old to enter the casino and purchase lottery tickets (Current age: %d)." % PlayerData.age, "finance")
		show_tab("timeline")
		return
	_show_casino_modal()


func _on_street_hustle_item_pressed() -> void:
	if PlayerData.age < 17:
		add_life_event("🔒 Restricted: Underground street hustles and criminal syndicates unlock at age 17.", "crime")
		show_tab("timeline")
		return
	_show_crime_modal()


func _on_mind_item_pressed() -> void:
	if PlayerData.age < 5:
		if PlayerData.age == 0:
			add_life_event("🍼 You are an infant! Infants cannot meditate yet—tap the AGE button to grow up.", "activity")
		else:
			add_life_event("🧸 You are a toddler! Toddlers cannot meditate yet—tap the AGE button to grow up.", "activity")
		show_tab("timeline")
		return
	_show_meditation_modal()


func _show_jobs_modal() -> void:
	if jobs_modal_overlay != null and is_instance_valid(jobs_modal_overlay):
		jobs_modal_overlay.queue_free()

	var modal := _create_cyber_modal("💼 CAREERS & OCCUPATION", "Browse Opportunities, Apply for Roles & Manage Employment", Color("#38bdf8"))
	jobs_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# Current Employment Status Card
	var cur_card := PanelContainer.new()
	cur_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#38bdf8")))
	var cur_m := MarginContainer.new()
	cur_m.add_theme_constant_override("margin_left", 20)
	cur_m.add_theme_constant_override("margin_right", 20)
	cur_m.add_theme_constant_override("margin_top", 16)
	cur_m.add_theme_constant_override("margin_bottom", 16)
	cur_card.add_child(cur_m)

	var cur_v := VBoxContainer.new()
	cur_v.add_theme_constant_override("separation", 8)
	cur_m.add_child(cur_v)

	var cur_title := Label.new()
	cur_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cur_title.add_theme_font_size_override("font_size", 24)
	cur_title.add_theme_color_override("font_color", Color("#38bdf8"))

	var cur_desc := Label.new()
	cur_desc.add_theme_font_size_override("font_size", 22)
	cur_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if PlayerData.job_title != "":
		cur_title.text = "CURRENT OCCUPATION"
		cur_desc.text = "%s  •  %s\n💰 Annual Salary: $%s / yr" % [PlayerData.job_title, PlayerData.job_company, _format_number(PlayerData.job_salary)]
		cur_desc.add_theme_color_override("font_color", Color("#34d399"))
		cur_v.add_child(cur_title)
		cur_v.add_child(cur_desc)

		var btn_ot := _create_cyber_button("⏱️ Work Overtime\nPut in extra hours at %s. +$%s Bonus, -5 Happiness" % [PlayerData.job_company, _format_number(maxi(150, int(PlayerData.job_salary * 0.05)))], Color("#38bdf8"), func():
			var bonus := maxi(150, int(PlayerData.job_salary * 0.05))
			PlayerData.money += bonus
			PlayerData.happiness = maxi(5, PlayerData.happiness - 5)
			add_life_event("You worked late overtime at %s. Earned a hard-work bonus of $%s! (Happiness -5)." % [PlayerData.job_company, _format_number(bonus)], "job")
			update_ui()
			SaveManager.save_game()
			_show_jobs_modal()
		)
		cur_v.add_child(btn_ot)

		var btn_quit := _create_cyber_button("🚪 Resign / Quit Job", Color("#ef4444"), func():
			quit_job()
			_show_jobs_modal()
		)
		cur_v.add_child(btn_quit)
	elif PlayerData.age < 14:
		cur_title.text = "OCCUPATIONAL STATUS: STUDENT / MINOR (Age %d)" % PlayerData.age
		cur_desc.text = "👶 Child Labor Regulations: Formal employment opens at age 12-14 for odd jobs (Newspaper Courier, Babysitting, Lawn Care) and age 16 for standard careers. Childhood earnings and helper activities are available below:"
		cur_desc.add_theme_color_override("font_color", Color("#93c5fd"))
		cur_v.add_child(cur_title)
		cur_v.add_child(cur_desc)

		if PlayerData.age < 4:
			var btn_toy := _create_cyber_button("🍼 Toy Cash Register & Play Coins\nPlay with pretend cash and count plastic coins. +2 Smarts, +4 Happiness", Color("#38bdf8"), func():
				PlayerData.smarts = mini(100, PlayerData.smarts + 2)
				PlayerData.happiness = mini(100, PlayerData.happiness + 4)
				add_life_event("You had fun ringing up items on your toy cash register! 'Beep beep!' (+Smarts, +Happiness)", "activity")
				update_ui()
				SaveManager.save_game()
				_show_jobs_modal()
			)
			cur_v.add_child(btn_toy)
		elif PlayerData.age < 10:
			var btn_chores := _create_cyber_button("🧹 Help Parents with Household Chores ($15 Cash)\nClean your room and organize the kitchen. +$15 Cash, +5 Parent Relationship, +3 Happiness", Color("#10b981"), func():
				PlayerData.money += 15
				PlayerData.happiness = mini(100, PlayerData.happiness + 3)
				if PlayerData.mother_relationship > 0:
					PlayerData.mother_relationship = mini(100, PlayerData.mother_relationship + 5)
				if PlayerData.father_relationship > 0:
					PlayerData.father_relationship = mini(100, PlayerData.father_relationship + 5)
				add_life_event("You helped your parents vacuum and wash dishes. They proudly gave you $15 allowance!", "finance")
				update_ui()
				SaveManager.save_game()
				_show_jobs_modal()
			)
			cur_v.add_child(btn_chores)

			var btn_comics := _create_cyber_button("🎨 Draw & Sell Hand-Drawn Comics ($10 Cash)\nSketch mini comic strips and sell them to school friends. +$10 Cash, +3 Smarts, +4 Happiness", Color("#f59e0b"), func():
				PlayerData.money += 10
				PlayerData.smarts = mini(100, PlayerData.smarts + 3)
				PlayerData.happiness = mini(100, PlayerData.happiness + 4)
				add_life_event("You drew hilarious cartoon superhero comics and sold copies to schoolmates for $10!", "finance")
				update_ui()
				SaveManager.save_game()
				_show_jobs_modal()
			)
			cur_v.add_child(btn_comics)
		else:
			var btn_lemonade := _create_cyber_button("🍋 Run a Neighborhood Lemonade Stand ($35 Cash)\nMix fresh lemonade and sell cups on the sidewalk. +$35 Cash, +3 Smarts, +6 Happiness", Color("#f59e0b"), func():
				PlayerData.money += 35
				PlayerData.smarts = mini(100, PlayerData.smarts + 3)
				PlayerData.happiness = mini(100, PlayerData.happiness + 6)
				add_life_event("You set up a lemonade stand on a sunny afternoon and earned $35 in profit!", "finance")
				update_ui()
				SaveManager.save_game()
				_show_jobs_modal()
			)
			cur_v.add_child(btn_lemonade)

			var btn_mow := _create_cyber_button("🌱 Mow Lawns & Rake Leaves for Neighbors ($45 Cash)\nOffer yard work services to neighbors on weekends. +$45 Cash, +4 Health, +3 Karma", Color("#10b981"), func():
				PlayerData.money += 45
				PlayerData.health = mini(100, PlayerData.health + 4)
				PlayerData.karma += 3
				add_life_event("You spent the morning mowing lawns and raking leaves for neighbors. Earned $45!", "finance")
				update_ui()
				SaveManager.save_game()
				_show_jobs_modal()
			)
			cur_v.add_child(btn_mow)
	else:
		cur_title.text = "CURRENT OCCUPATION"
		cur_desc.text = "Status: Currently Unemployed\nBrowse the open positions below and apply for jobs you qualify for!"
		cur_desc.add_theme_color_override("font_color", Color("#94a3b8"))
		cur_v.add_child(cur_title)
		cur_v.add_child(cur_desc)

	list.add_child(cur_card)

	# Available Jobs List
	var all_jobs: Array = JobManager.get_all_jobs()
	for job in all_jobs:
		if job is not Dictionary:
			continue

		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#1e3a5f")))

		var m := MarginContainer.new()
		m.add_theme_constant_override("margin_left", 20)
		m.add_theme_constant_override("margin_right", 20)
		m.add_theme_constant_override("margin_top", 16)
		m.add_theme_constant_override("margin_bottom", 16)
		card.add_child(m)

		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 8)
		m.add_child(vbox)

		var title_lbl := Label.new()
		title_lbl.text = "%s  •  %s" % [job.get("title", "Job"), job.get("workplace", "Company")]
		title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title_lbl.add_theme_font_size_override("font_size", 26)
		title_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
		vbox.add_child(title_lbl)

		var salary_val: int = int(job.get("salary", 0))
		var salary_lbl := Label.new()
		salary_lbl.text = "💰 Salary: $%s / yr   •   Min Age: %d" % [_format_number(salary_val), int(job.get("min_age", 16))]
		salary_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		salary_lbl.add_theme_font_size_override("font_size", 22)
		salary_lbl.add_theme_color_override("font_color", Color("#34d399"))
		vbox.add_child(salary_lbl)

		var reqs: Dictionary = job.get("requirements", {})
		var req_parts: Array = []
		if reqs.has("min_grades"):
			req_parts.append("Min Grades: %d%%" % int(reqs["min_grades"]))
		if reqs.has("min_education"):
			req_parts.append("Degree: %s" % str(reqs["min_education"]))
		if reqs.has("required_major"):
			var m_title := JobManager.get_major_display_name(str(reqs["required_major"]))
			req_parts.append("Major: %s" % m_title)

		if not req_parts.is_empty():
			var req_lbl := Label.new()
			req_lbl.text = "📋 " + " • ".join(req_parts)
			req_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			req_lbl.add_theme_font_size_override("font_size", 20)
			req_lbl.add_theme_color_override("font_color", Color("#fbbf24"))
			vbox.add_child(req_lbl)

		var desc_lbl := Label.new()
		desc_lbl.text = str(job.get("description", ""))
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.add_theme_font_size_override("font_size", 20)
		desc_lbl.add_theme_color_override("font_color", Color("#e2e8f0"))
		vbox.add_child(desc_lbl)

		var eval: Dictionary = JobManager.can_apply(job, PlayerData.age, PlayerData.get_stats(), {
			"grades": PlayerData.grades,
			"education_level": PlayerData.education_level,
			"major": PlayerData.university_major,
			"university_name": PlayerData.university_name
		})
		var is_qualified: bool = bool(eval.get("allowed", false))
		var is_current: bool = PlayerData.job_id == str(job.get("id", ""))

		var btn := Button.new()
		btn.custom_minimum_size.y = 56
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.add_theme_font_size_override("font_size", 22)

		if is_current:
			btn.text = "✓ CURRENT OCCUPATION"
			btn.disabled = true
			var cur_style := StyleBoxFlat.new()
			cur_style.bg_color = Color("#0e3a2f")
			cur_style.border_color = Color("#10b981")
			cur_style.set_border_width_all(2)
			cur_style.set_corner_radius_all(6)
			btn.add_theme_stylebox_override("disabled", cur_style)
			btn.add_theme_color_override("font_color", Color("#6ee7b7"))
		elif is_qualified:
			btn.text = "APPLY FOR ROLE"
			var app_style := StyleBoxFlat.new()
			app_style.bg_color = Color("#10b981")
			app_style.border_color = Color("#059669")
			app_style.set_border_width_all(2)
			app_style.set_corner_radius_all(6)
			btn.add_theme_stylebox_override("normal", app_style)
			btn.add_theme_color_override("font_color", Color("#ffffff"))
			var jid: String = str(job.get("id", ""))
			btn.pressed.connect(func():
				apply_for_job(jid)
				_show_jobs_modal()
			)
		else:
			if PlayerData.age < int(job.get("min_age", 16)):
				btn.text = "🔒 LOCKED: Requires Age %d+ (Current: %d)" % [int(job.get("min_age", 16)), PlayerData.age]
			else:
				btn.text = "🔒 LOCKED: " + str(eval.get("reason", "Not qualified"))
			btn.disabled = true
			var lock_style := StyleBoxFlat.new()
			lock_style.bg_color = Color("#1e293b")
			lock_style.border_color = Color("#334155")
			lock_style.set_border_width_all(2)
			lock_style.set_corner_radius_all(6)
			btn.add_theme_stylebox_override("disabled", lock_style)
			btn.add_theme_color_override("font_color", Color("#94a3b8"))

		vbox.add_child(btn)
		list.add_child(card)

	jobs_modal_overlay.visible = true


func _show_education_modal() -> void:
	if education_modal_overlay != null and is_instance_valid(education_modal_overlay):
		education_modal_overlay.queue_free()

	var modal := _create_cyber_modal("🎓 ACADEMY & EDUCATION", "Academic Records, Grades, Study Habits & Scholarships", Color("#818cf8"))
	education_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# Academic Summary Card
	var summary_card := PanelContainer.new()
	summary_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#818cf8")))
	var sm := MarginContainer.new()
	sm.add_theme_constant_override("margin_left", 20)
	sm.add_theme_constant_override("margin_right", 20)
	sm.add_theme_constant_override("margin_top", 16)
	sm.add_theme_constant_override("margin_bottom", 16)
	summary_card.add_child(sm)

	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 8)
	sm.add_child(sv)

	var level_lbl := Label.new()
	if PlayerData.age < 3:
		level_lbl.text = "🏫 Academic Status: Early Childhood (Age %d)" % PlayerData.age
	else:
		level_lbl.text = "🏫 Academic Status: %s" % PlayerData.get_education_display_string()
	level_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	level_lbl.add_theme_font_size_override("font_size", 24)
	level_lbl.add_theme_color_override("font_color", Color("#c7d2fe"))
	sv.add_child(level_lbl)

	var grade_color := Color("#22c55e") if PlayerData.grades >= 80 else (Color("#38bdf8") if PlayerData.grades >= 65 else Color("#f87171"))
	var grade_lbl := Label.new()
	if PlayerData.age < 3:
		grade_lbl.text = "🧸 School Enrollment: Kindergarten begins at age 3 (in %d year%s)" % [3 - PlayerData.age, "s" if (3 - PlayerData.age) > 1 else ""]
		grade_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
	else:
		grade_lbl.text = "📊 Current Marks / GPA: %d%% (%s)" % [PlayerData.grades, PlayerData.get_letter_grade()]
		grade_lbl.add_theme_color_override("font_color", grade_color)
	grade_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	grade_lbl.add_theme_font_size_override("font_size", 24)
	sv.add_child(grade_lbl)

	var schol_lbl := Label.new()
	if PlayerData.has_scholarship:
		schol_lbl.text = "🏆 University Scholarship: 100% Full-Ride Tuition Waiver Active"
		schol_lbl.add_theme_color_override("font_color", Color("#34d399"))
	elif PlayerData.education_level == "University Student":
		schol_lbl.text = "🏛️ University Tuition: $%s / yr (%s)" % [_format_number(PlayerData.university_tuition), PlayerData.university_name]
		schol_lbl.add_theme_color_override("font_color", Color("#fbbf24"))
	elif PlayerData.age < 14:
		schol_lbl.text = "🏆 University Scholarship: Unlocks in High School (Age 16+)"
		schol_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	else:
		schol_lbl.text = "🏆 University Scholarship: None (Tuition varies by institution)"
		schol_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	schol_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	schol_lbl.add_theme_font_size_override("font_size", 22)
	sv.add_child(schol_lbl)

	var impact_lbl := Label.new()
	impact_lbl.text = "Career Impact: Academic marks directly dictate career qualification. High grades unlock high-paying corporate, tech, and medical careers; failing grades restrict you to low-paying manual labor."
	impact_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	impact_lbl.add_theme_font_size_override("font_size", 20)
	impact_lbl.add_theme_color_override("font_color", Color("#cbd5e1"))
	sv.add_child(impact_lbl)

	list.add_child(summary_card)

	# Annual Action Gating Banner to prevent status modifier exploits
	var has_done_school_activity_this_year: bool = (PlayerData.last_school_activity_age == PlayerData.age)
	if has_done_school_activity_this_year:
		var lock_banner := PanelContainer.new()
		lock_banner.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
		var lm := MarginContainer.new()
		lm.add_theme_constant_override("margin_left", 18)
		lm.add_theme_constant_override("margin_right", 18)
		lm.add_theme_constant_override("margin_top", 12)
		lm.add_theme_constant_override("margin_bottom", 12)
		lock_banner.add_child(lm)

		var ll := Label.new()
		ll.text = "⏳ ANNUAL SCHOOL PARTICIPATION COMPLETED\nYou have already taken a school activity for Age %d.\nTo prevent status modifier exploits, all study options are locked until next year. Advance age (+1 Year) to participate again!" % PlayerData.age
		ll.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ll.add_theme_font_size_override("font_size", 20)
		ll.add_theme_color_override("font_color", Color("#fbbf24"))
		lm.add_child(ll)
		list.add_child(lock_banner)

	# Interactive Academic Options
	var is_student: bool = PlayerData.education_level in ["Kindergarten", "Primary School", "Middle School", "High School", "University Student"]

	if PlayerData.age < 3:
		# Early Childhood Development Activities
		var infant_tip := Label.new()
		infant_tip.text = "🧸 Early Cognitive Development: Kindergarten enrollment begins at age 3. Interactive learning activities build your character's intelligence and emotional happiness early on:"
		infant_tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		infant_tip.add_theme_font_size_override("font_size", 21)
		infant_tip.add_theme_color_override("font_color", Color("#93c5fd"))
		list.add_child(infant_tip)

		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("🧸 Picture Books & Nursery Rhymes\nExplore colorful books and alphabet songs. +4 Smarts, +6 Happiness", "Completed for Age %d (Age up to continue next year)" % PlayerData.age))
			list.add_child(_create_disabled_cyber_button("🧩 Shape Sorting & Building Blocks\nSolve motor puzzles and spatial coordination. +5 Smarts, +4 Happiness", "Completed for Age %d (Age up to continue next year)" % PlayerData.age))
			list.add_child(_create_disabled_cyber_button("🎨 Finger Painting & Music Play\nExplore vibrant colors and playful sounds. +2 Smarts, +8 Happiness", "Completed for Age %d (Age up to continue next year)" % PlayerData.age))
		else:
			var btn_books := _create_cyber_button("🧸 Picture Books & Nursery Rhymes\nExplore colorful books and alphabet songs. +4 Smarts, +6 Happiness", Color("#818cf8"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				PlayerData.smarts = mini(100, PlayerData.smarts + randi_range(3, 5))
				PlayerData.happiness = mini(100, PlayerData.happiness + randi_range(5, 8))
				add_life_event("You flipped through colorful picture books and learned letters and animal sounds. (+Smarts, +Happiness)", "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_books)

			var btn_blocks := _create_cyber_button("🧩 Shape Sorting & Building Blocks\nSolve motor puzzles and spatial coordination. +5 Smarts, +4 Happiness", Color("#38bdf8"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				PlayerData.smarts = mini(100, PlayerData.smarts + randi_range(4, 6))
				PlayerData.happiness = mini(100, PlayerData.happiness + randi_range(3, 6))
				add_life_event("You successfully fitted triangular and circular wooden blocks into the sorter! (+Smarts, +Happiness)", "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_blocks)

			var btn_music := _create_cyber_button("🎨 Finger Painting & Music Play\nExplore vibrant colors and playful sounds. +2 Smarts, +8 Happiness", Color("#ec4899"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				PlayerData.smarts = mini(100, PlayerData.smarts + randi_range(1, 3))
				PlayerData.happiness = mini(100, PlayerData.happiness + randi_range(7, 10))
				add_life_event("You gleefully smeared bright finger paint all over paper (and your face)! (+Happiness)", "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_music)

	elif is_student:
		# 1. Study Hard
		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("📖 Study Diligently\n+8% Grades, +3 Smarts, -4 Happiness", "Already studied or engaged in school activities for Age %d (Age up to next year)" % PlayerData.age))
		else:
			var btn_study := _create_cyber_button("📖 Study Diligently\n+8% Grades, +3 Smarts, -4 Happiness", Color("#818cf8"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				var g_gain := randi_range(6, 10)
				var s_gain := randi_range(2, 4)
				var h_loss := randi_range(3, 5)
				PlayerData.grades = mini(100, PlayerData.grades + g_gain)
				PlayerData.smarts = mini(100, PlayerData.smarts + s_gain)
				PlayerData.happiness = maxi(0, PlayerData.happiness - h_loss)
				add_life_event("You studied diligently, completing extra credit and reviewing notes. Grades +%d%%, Smarts +%d." % [g_gain, s_gain], "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_study)

		# 2. Slack Off at School
		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("🎮 Slack Off in Class\n-10% Grades, +8 Happiness, -1 Smarts (Risk of Detention)", "Already participated in school activities for Age %d (Age up to next year)" % PlayerData.age))
		else:
			var btn_slack := _create_cyber_button("🎮 Slack Off in Class\n-10% Grades, +8 Happiness, -1 Smarts (Risk of Detention)", Color("#f59e0b"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				var g_loss := randi_range(8, 14)
				var h_gain := randi_range(6, 11)
				PlayerData.grades = maxi(0, PlayerData.grades - g_loss)
				PlayerData.happiness = mini(100, PlayerData.happiness + h_gain)
				PlayerData.smarts = maxi(0, PlayerData.smarts - 1)
				if randf() < 0.28:
					PlayerData.happiness = maxi(5, PlayerData.happiness - 8)
					add_life_event("🚨 DETENTION: A teacher caught you goofing off during class and assigned after-school detention! Grades -%d%%." % g_loss, "education")
				else:
					add_life_event("You slacked off in class, joked around with friends, and skipped homework. Grades -%d%%, Happiness +%d." % [g_loss, h_gain], "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_slack)

		# 3. Bully Someone
		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("😈 Bully a Classmate\n-20 Karma, Risk of Getting Beaten Up or Suspended", "Already engaged in school conduct for Age %d (Age up to next year)" % PlayerData.age))
		else:
			var btn_bully := _create_cyber_button("😈 Bully a Classmate\n-20 Karma, Risk of Getting Beaten Up or Suspended", Color("#ef4444"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				var roll := randf()
				if roll < 0.40:
					PlayerData.karma -= 20
					PlayerData.happiness = mini(100, PlayerData.happiness + 4)
					add_life_event("😈 Cruel Victory: You bullied a classmate and mocked their clothes. They ran away crying. Karma -20.", "education")
				elif roll < 0.75:
					PlayerData.karma -= 20
					PlayerData.health = maxi(5, PlayerData.health - randi_range(8, 15))
					PlayerData.happiness = maxi(5, PlayerData.happiness - 10)
					add_life_event("💥 RETALIATION: You tried to bully someone, but they punched you right in the nose! Health -12%, Karma -20.", "education")
				else:
					PlayerData.karma -= 25
					PlayerData.happiness = maxi(5, PlayerData.happiness - 15)
					if PlayerData.mother_relationship > 0:
						PlayerData.mother_relationship = maxi(0, PlayerData.mother_relationship - 15)
					add_life_event("🚨 SUSPENDED: The principal caught you bullying and suspended you for 3 days! Your parents are thoroughly disgusted.", "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_bully)

		# 4. Lead Group Study
		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("👥 Lead Group Study\n+6% Grades, +3 Smarts, +12 Karma, +5 Happiness (Req: 55%+ Grades)", "Already participated in school activities for Age %d (Age up to next year)" % PlayerData.age))
		else:
			var btn_group := _create_cyber_button("👥 Lead Group Study\n+6% Grades, +3 Smarts, +12 Karma, +5 Happiness (Req: 55%+ Grades)", Color("#22c55e"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				if PlayerData.grades < 55:
					add_life_event("Low Marks: You need at least 55% academic marks to tutor and lead a study group (Current: %d%%)." % PlayerData.grades, "education")
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				var g_gain := randi_range(4, 7)
				var s_gain := randi_range(2, 4)
				var k_gain := randi_range(10, 15)
				PlayerData.grades = mini(100, PlayerData.grades + g_gain)
				PlayerData.smarts = mini(100, PlayerData.smarts + s_gain)
				PlayerData.karma += k_gain
				PlayerData.happiness = mini(100, PlayerData.happiness + 6)
				add_life_event("👥 Group Leadership: You organized an effective peer study group. Everyone's marks improved! Karma +%d, Grades +%d%%." % [k_gain, g_gain], "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_group)

		# 5. Drop Out of School (High School only; forbidden for younger)
		if PlayerData.education_level == "High School":
			var btn_dropout := _create_cyber_button("🚪 Drop Out of High School\nQuit school permanently. Locks out college & professional degree careers.", Color("#dc2626"), func():
				PlayerData.education_level = "High School Dropout"
				PlayerData.happiness = maxi(5, PlayerData.happiness - 10)
				add_life_event("🚪 You made the drastic decision to drop out of High School at age %d to enter the real world. University is now out of reach." % PlayerData.age, "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_dropout)
		elif PlayerData.education_level in ["Kindergarten", "Primary School", "Middle School"]:
			var btn_dropout_lock := _create_cyber_button("🚪 Drop Out of School [LOCKED]\nTruancy laws mandate compulsory education. Kindergarten, Primary, and Middle schoolers cannot drop out!", Color("#475569"), func():
				add_life_event("Compulsory Education: By law, students cannot drop out before High School (Age 14+).", "education")
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_dropout_lock)

		# 6. Private Tutor
		if has_done_school_activity_this_year:
			list.add_child(_create_disabled_cyber_button("👨‍🏫 Hire Academic Tutor ($200)\n+12% Grades, -$200 Cash", "Already engaged private tutoring or study activities for Age %d (Age up to next year)" % PlayerData.age))
		else:
			var btn_tutor := _create_cyber_button("👨‍🏫 Hire Academic Tutor ($200)\n+12% Grades, -$200 Cash", Color("#38bdf8"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				if PlayerData.money >= 200:
					PlayerData.last_school_activity_age = PlayerData.age
					PlayerData.money -= 200
					var g_gain := randi_range(10, 15)
					PlayerData.grades = mini(100, PlayerData.grades + g_gain)
					add_life_event("You worked with a private academic tutor ($200). Grades improved +%d%%!" % g_gain, "education")
					update_ui()
					SaveManager.save_game()
					_close_education_modal_and_return_to_main()
				elif PlayerData.age < 18 and (PlayerData.mother_relationship >= 60 or PlayerData.father_relationship >= 60):
					PlayerData.last_school_activity_age = PlayerData.age
					var g_gain := randi_range(10, 15)
					PlayerData.grades = mini(100, PlayerData.grades + g_gain)
					add_life_event("Your supportive parents happily paid $200 for a private tutor. Grades improved +%d%%!" % g_gain, "education")
					update_ui()
					SaveManager.save_game()
					_close_education_modal_and_return_to_main()
				else:
					add_life_event("You cannot afford a private academic tutor ($200 required).", "education")
					_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_tutor)

	# Apply for Scholarship (High Schoolers Age 16+)
	if PlayerData.age >= 16 and PlayerData.education_level == "High School" and not PlayerData.has_scholarship:
		if PlayerData.last_scholarship_applied_age == PlayerData.age:
			list.add_child(_create_disabled_cyber_button("🏆 Apply for Full-Ride Scholarship\n100% University Tuition Waiver (Req: 82%+ Grades, 65+ Smarts)", "Scholarship application already submitted for Age %d (Awaiting board review next year)" % PlayerData.age))
		else:
			var btn_schol := _create_cyber_button("🏆 Apply for Full-Ride Scholarship\n100% University Tuition Waiver (Req: 82%+ Grades, 65+ Smarts)", Color("#fbbf24"), func():
				PlayerData.last_scholarship_applied_age = PlayerData.age
				if PlayerData.grades >= 82 and PlayerData.smarts >= 65:
					PlayerData.has_scholarship = true
					PlayerData.happiness = mini(100, PlayerData.happiness + 20)
					PlayerData.karma += 5
					add_life_event("🏆 SCHOLARSHIP AWARDED! The National Academic Board awarded you a 100% full-ride tuition waiver for university!", "education")
				else:
					PlayerData.happiness = maxi(0, PlayerData.happiness - 5)
					add_life_event("Scholarship Denied: Committee requires at least 82%% academic grades and 65 smarts (Current: %d%% grades, %d smarts)." % [PlayerData.grades, PlayerData.smarts], "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_schol)

	# Enroll in University Institutions (High School Graduates)
	if PlayerData.age >= 18 and PlayerData.education_level in ["High School", "High School Graduate"]:
		var uni_header := Label.new()
		uni_header.text = "🏛️ UNIVERSITY ENROLLMENT & MAJORS"
		uni_header.add_theme_font_size_override("font_size", 26)
		uni_header.add_theme_color_override("font_color", Color("#38bdf8"))
		list.add_child(uni_header)

		var uni_sub := Label.new()
		uni_sub.text = "Choose an institution and major. Your degree directly dictates career qualification (e.g. IT Major for Tech, Business Management for Store Management)."
		uni_sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		uni_sub.add_theme_font_size_override("font_size", 20)
		uni_sub.add_theme_color_override("font_color", Color("#94a3b8"))
		list.add_child(uni_sub)

		var institutions: Array = EducationCatalog.get_all_institutions()
		for inst in institutions:
			if not (inst is Dictionary):
				continue
			var col := Color(str(inst.get("theme_color", "#38bdf8")))
			var card := PanelContainer.new()
			card.add_theme_stylebox_override("panel", load_style_box_cyber_card(col))

			var m := MarginContainer.new()
			m.add_theme_constant_override("margin_left", 20)
			m.add_theme_constant_override("margin_right", 20)
			m.add_theme_constant_override("margin_top", 14)
			m.add_theme_constant_override("margin_bottom", 14)
			card.add_child(m)

			var vb := VBoxContainer.new()
			vb.add_theme_constant_override("separation", 6)
			m.add_child(vb)

			var inst_title := Label.new()
			inst_title.text = "%s  %s" % [str(inst.get("icon", "🏛️")), str(inst.get("name", ""))]
			inst_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			inst_title.add_theme_font_size_override("font_size", 24)
			inst_title.add_theme_color_override("font_color", col)
			vb.add_child(inst_title)

			var inst_tagline := Label.new()
			inst_tagline.text = str(inst.get("tagline", ""))
			inst_tagline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			inst_tagline.add_theme_font_size_override("font_size", 20)
			inst_tagline.add_theme_color_override("font_color", Color("#93c5fd"))
			vb.add_child(inst_tagline)

			var inst_major := Label.new()
			inst_major.text = "🎓 Major: %s  •  %s" % [str(inst.get("major_title", "")), str(inst.get("degree_title", ""))]
			inst_major.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			inst_major.add_theme_font_size_override("font_size", 21)
			inst_major.add_theme_color_override("font_color", Color("#f8fafc"))
			vb.add_child(inst_major)

			var inst_careers := Label.new()
			var c_list: Array = inst.get("unlocked_careers", [])
			inst_careers.text = "🎯 Unlocks Careers: %s" % ", ".join(c_list)
			inst_careers.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			inst_careers.add_theme_font_size_override("font_size", 19)
			inst_careers.add_theme_color_override("font_color", Color("#34d399"))
			vb.add_child(inst_careers)

			var inst_desc := Label.new()
			inst_desc.text = str(inst.get("description", ""))
			inst_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			inst_desc.add_theme_font_size_override("font_size", 19)
			inst_desc.add_theme_color_override("font_color", Color("#cbd5e1"))
			vb.add_child(inst_desc)

			var tuition_amount: int = int(inst.get("tuition", 12000))
			var tuition_text := "Free (Scholarship Active)" if PlayerData.has_scholarship else "$%s / yr" % _format_number(tuition_amount)
			var req_eval: Dictionary = EducationCatalog.can_enroll(inst, PlayerData.grades, PlayerData.smarts)
			var is_eligible: bool = bool(req_eval.get("allowed", false))

			if is_eligible:
				var enroll_btn := _create_cyber_button("🏛️ Enroll in %s (%s)\nReq Met: %d%% GPA & %d Smarts" % [
					str(inst.get("major_title", "")),
					tuition_text,
					int(inst.get("min_grades", 60)),
					int(inst.get("min_smarts", 50))
				], col, func():
					PlayerData.education_level = "University Student"
					PlayerData.university_name = str(inst.get("name", ""))
					PlayerData.university_major = str(inst.get("major", ""))
					PlayerData.university_major_title = str(inst.get("major_title", ""))
					PlayerData.university_degree = str(inst.get("degree_title", ""))
					PlayerData.university_tuition = tuition_amount
					PlayerData.university_years = 0
					add_life_event("🏛️ You enrolled at %s majoring in %s! Complete 4 years to earn your %s." % [
						PlayerData.university_name,
						PlayerData.university_major_title,
						PlayerData.university_degree
					], "milestone")
					update_ui()
					SaveManager.save_game()
					_close_education_modal_and_return_to_main()
				)
				vb.add_child(enroll_btn)
			else:
				var locked_btn := Button.new()
				locked_btn.custom_minimum_size.y = 54
				locked_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				locked_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				locked_btn.text = "🔒 LOCKED: " + str(req_eval.get("reason", "Ineligible"))
				locked_btn.disabled = true
				var lk_style := StyleBoxFlat.new()
				lk_style.bg_color = Color("#181f2f")
				lk_style.border_color = Color("#334155")
				lk_style.set_border_width_all(2)
				lk_style.set_corner_radius_all(6)
				locked_btn.add_theme_stylebox_override("disabled", lk_style)
				locked_btn.add_theme_color_override("font_color", Color("#94a3b8"))
				locked_btn.add_theme_font_size_override("font_size", 20)
				vb.add_child(locked_btn)

			list.add_child(card)

	# Active University Student Status Card
	if PlayerData.education_level == "University Student":
		var uni_active := PanelContainer.new()
		uni_active.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#00f0ff")))
		var um := MarginContainer.new()
		um.add_theme_constant_override("margin_left", 20)
		um.add_theme_constant_override("margin_right", 20)
		um.add_theme_constant_override("margin_top", 14)
		um.add_theme_constant_override("margin_bottom", 14)
		uni_active.add_child(um)

		var uv := VBoxContainer.new()
		uv.add_theme_constant_override("separation", 8)
		um.add_child(uv)

		var u_title := Label.new()
		u_title.text = "🏛️ ACTIVE UNIVERSITY ENROLLMENT"
		u_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		u_title.add_theme_font_size_override("font_size", 24)
		u_title.add_theme_color_override("font_color", Color("#00f0ff"))
		uv.add_child(u_title)

		var u_inst := Label.new()
		u_inst.text = "Institution: %s\nMajor: %s   •   Degree in Progress: %s\nProgress: Year %d of 4 completed" % [
			PlayerData.university_name,
			PlayerData.university_major_title,
			PlayerData.university_degree,
			PlayerData.university_years
		]
		u_inst.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		u_inst.add_theme_font_size_override("font_size", 21)
		u_inst.add_theme_color_override("font_color", Color("#f8fafc"))
		uv.add_child(u_inst)

		var t_info := Label.new()
		var t_cost: int = PlayerData.university_tuition if PlayerData.university_tuition > 0 else 12000
		t_info.text = "Annual Tuition: Free (Scholarship Active)" if PlayerData.has_scholarship else "Annual Tuition: $%s / yr" % _format_number(t_cost)
		t_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		t_info.add_theme_font_size_override("font_size", 20)
		t_info.add_theme_color_override("font_color", Color("#34d399") if PlayerData.has_scholarship else Color("#fbbf24"))
		uv.add_child(t_info)

		if has_done_school_activity_this_year:
			uv.add_child(_create_disabled_cyber_button("📖 Intensive Major Coursework Study\nHit the library and master course exams. Grades +2-4%, Smarts +2-4", "Completed for Age %d (Age up to study again next year)" % PlayerData.age))
		else:
			var btn_study_uni := _create_cyber_button("📖 Intensive Major Coursework Study\nHit the library and master course exams. Grades +2-4%, Smarts +2-4", Color("#38bdf8"), func():
				if PlayerData.last_school_activity_age == PlayerData.age:
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_school_activity_age = PlayerData.age
				var g_gain := randi_range(2, 4)
				var s_gain := randi_range(2, 4)
				PlayerData.grades = mini(100, PlayerData.grades + g_gain)
				PlayerData.smarts = mini(100, PlayerData.smarts + s_gain)
				PlayerData.happiness = maxi(5, PlayerData.happiness - 3)
				add_life_event("You studied late into the night preparing for %s midterms. Grades +%d%%, Smarts +%d." % [PlayerData.university_major_title, g_gain, s_gain], "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			uv.add_child(btn_study_uni)

		var btn_drop_uni := _create_cyber_button("🚪 Drop Out of University\nAbandon your degree program and enter the workforce.", Color("#ef4444"), func():
			PlayerData.education_level = "High School Graduate"
			add_life_event("You dropped out of %s. You forfeited your degree in %s." % [PlayerData.university_name, PlayerData.university_major_title], "education")
			PlayerData.university_years = 0
			PlayerData.university_name = ""
			PlayerData.university_major = ""
			PlayerData.university_major_title = ""
			PlayerData.university_degree = ""
			update_ui()
			SaveManager.save_game()
			_close_education_modal_and_return_to_main()
		)
		uv.add_child(btn_drop_uni)

		list.add_child(uni_active)

	# Dropout Overview Card & GED option
	if PlayerData.education_level == "High School Dropout":
		var drop_card := PanelContainer.new()
		drop_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#ef4444")))
		var dm := MarginContainer.new()
		dm.add_theme_constant_override("margin_left", 20)
		dm.add_theme_constant_override("margin_right", 20)
		dm.add_theme_constant_override("margin_top", 14)
		dm.add_theme_constant_override("margin_bottom", 14)
		drop_card.add_child(dm)
		var dl := Label.new()
		dl.text = "⚠️ DROPOUT STATUS: You dropped out of high school. High-skill careers and University admission are barred. You can study for your GED to restore high school credential."
		dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dl.add_theme_font_size_override("font_size", 21)
		dl.add_theme_color_override("font_color", Color("#fca5a5"))
		dm.add_child(dl)
		list.add_child(drop_card)

		if PlayerData.last_ged_attempt_age == PlayerData.age:
			list.add_child(_create_disabled_cyber_button("📜 Study & Sit for GED Equivalency ($500)\nHigh school equivalency credential restores university admission (Req: 60+ Smarts)", "Already sat for GED examination for Age %d (Retakes available next year)" % PlayerData.age))
		else:
			var btn_ged := _create_cyber_button("📜 Study & Sit for GED Equivalency ($500)\nHigh school equivalency credential restores university admission (Req: 60+ Smarts)", Color("#38bdf8"), func():
				if PlayerData.money < 500:
					add_life_event("You cannot afford the $500 GED exam registration fees.", "education")
					_close_education_modal_and_return_to_main()
					return
				PlayerData.last_ged_attempt_age = PlayerData.age
				PlayerData.money -= 500
				if PlayerData.smarts >= 60:
					PlayerData.education_level = "High School Graduate"
					PlayerData.grades = 75
					PlayerData.happiness = mini(100, PlayerData.happiness + 20)
					add_life_event("🎉 DIPLOMA EARNED! You passed the GED examinations! You are now a certified High School Graduate.", "education")
				else:
					PlayerData.happiness = maxi(5, PlayerData.happiness - 10)
					add_life_event("GED Failed: You scored below passing grade. Boost your Smarts before retaking.", "education")
				update_ui()
				SaveManager.save_game()
				_close_education_modal_and_return_to_main()
			)
			list.add_child(btn_ged)

	# University Graduate Honors Card
	if PlayerData.education_level == "University Graduate":
		var grad_card := PanelContainer.new()
		grad_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#10b981")))
		var gm := MarginContainer.new()
		gm.add_theme_constant_override("margin_left", 20)
		gm.add_theme_constant_override("margin_right", 20)
		gm.add_theme_constant_override("margin_top", 14)
		gm.add_theme_constant_override("margin_bottom", 14)
		grad_card.add_child(gm)

		var gv := VBoxContainer.new()
		gv.add_theme_constant_override("separation", 6)
		gm.add_child(gv)

		var gl := Label.new()
		gl.text = "🎓 UNIVERSITY ALUMNUS - %s" % (PlayerData.university_name.to_upper() if PlayerData.university_name != "" else "ALUMNUS")
		gl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		gl.add_theme_font_size_override("font_size", 24)
		gl.add_theme_color_override("font_color", Color("#34d399"))
		gv.add_child(gl)

		var g_sub := Label.new()
		var d_str: String = PlayerData.university_degree if PlayerData.university_degree != "" else "Bachelor's Degree"
		var m_str: String = PlayerData.university_major_title if PlayerData.university_major_title != "" else "Specialized Major"
		g_sub.text = "%s in %s\nFinal Academic Marks: %d%% (%s)\nCareers requiring %s are fully unlocked!" % [
			d_str,
			m_str,
			PlayerData.grades,
			PlayerData.get_letter_grade(),
			m_str
		]
		g_sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		g_sub.add_theme_font_size_override("font_size", 21)
		g_sub.add_theme_color_override("font_color", Color("#a7f3d0"))
		gv.add_child(g_sub)

		list.add_child(grad_card)

	education_modal_overlay.visible = true


# ==========================================
# MODAL OVERLAY SYSTEMS (Doctor, Crime, Casino, Death)
# ==========================================

var doctor_modal_overlay: ColorRect = null
var crime_modal_overlay: ColorRect = null
var casino_modal_overlay: ColorRect = null
var death_screen_overlay: ColorRect = null
var gym_modal_overlay: ColorRect = null
var meditation_modal_overlay: ColorRect = null


func _create_cyber_modal(title_text: String, subtitle_text: String, border_color: Color) -> Dictionary:
	var overlay := ColorRect.new()
	overlay.color = Color(0.012, 0.035, 0.07, 0.88)
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.grow_horizontal = Control.GROW_DIRECTION_BOTH
	overlay.grow_vertical = Control.GROW_DIRECTION_BOTH
	overlay.z_index = 80
	overlay.visible = true
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)

	var center := CenterContainer.new()
	center.anchors_preset = Control.PRESET_FULL_RECT
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(center)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(920, 1180)
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("#090f1d")
	card_style.border_color = border_color
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(12)
	card_style.shadow_color = Color(0, 0, 0, 0.85)
	card_style.shadow_size = 20
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	# Click outside card on dim backdrop to close
	overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			overlay.queue_free()
	)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 36)
	margin.add_theme_constant_override("margin_right", 36)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_bottom", 32)
	card.add_child(margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 16)
	margin.add_child(main_vbox)

	# Header row
	var header_row := HBoxContainer.new()
	main_vbox.add_child(header_row)

	var title_lbl := Label.new()
	title_lbl.text = title_text
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.add_theme_color_override("font_color", border_color)
	title_lbl.add_theme_font_size_override("font_size", 34)
	header_row.add_child(title_lbl)

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(64, 52)
	close_btn.add_theme_font_size_override("font_size", 28)
	close_btn.add_theme_color_override("font_color", Color("#e2e8f0"))
	close_btn.add_theme_color_override("font_hover_color", Color("#f43f5e"))
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color("#1e293b")
	close_style.border_color = border_color
	close_style.set_border_width_all(2)
	close_style.set_corner_radius_all(6)
	close_btn.add_theme_stylebox_override("normal", close_style)
	close_btn.pressed.connect(func(): overlay.queue_free())
	header_row.add_child(close_btn)

	var sub_lbl := Label.new()
	sub_lbl.text = subtitle_text
	sub_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	sub_lbl.add_theme_font_size_override("font_size", 22)
	sub_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	main_vbox.add_child(sub_lbl)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_vbox.add_child(scroll)

	var scroll_margin := MarginContainer.new()
	scroll_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_margin.add_theme_constant_override("margin_left", 4)
	scroll_margin.add_theme_constant_override("margin_right", 28)
	scroll_margin.add_theme_constant_override("margin_top", 4)
	scroll_margin.add_theme_constant_override("margin_bottom", 24)
	scroll.add_child(scroll_margin)

	var content_list := VBoxContainer.new()
	content_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_list.add_theme_constant_override("separation", 14)
	scroll_margin.add_child(content_list)

	return {
		"overlay": overlay,
		"card": card,
		"title": title_lbl,
		"subtitle": sub_lbl,
		"list": content_list,
		"close_button": close_btn
	}


func _create_cyber_button(btn_text: String, border_col: Color, on_click: Callable) -> Button:
	var btn := Button.new()
	btn.text = btn_text
	btn.custom_minimum_size.y = 86
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.add_theme_font_size_override("font_size", 21)
	btn.add_theme_color_override("font_color", Color("#f8fafc"))
	btn.add_theme_color_override("font_hover_color", Color("#ffffff"))
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#111827")
	style.border_color = border_col
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	btn.add_theme_stylebox_override("normal", style)

	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#1f2937")
	hover.border_color = Color("#ffffff")
	btn.add_theme_stylebox_override("hover", hover)

	btn.pressed.connect(on_click)
	return btn


func _create_disabled_cyber_button(btn_text: String, reason: String) -> Button:
	var btn := Button.new()
	btn.text = "%s\n🔒 %s" % [btn_text, reason]
	btn.custom_minimum_size.y = 86
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.add_theme_font_size_override("font_size", 20)
	btn.disabled = true
	var lock_style := StyleBoxFlat.new()
	lock_style.bg_color = Color("#0f172a")
	lock_style.border_color = Color("#334155")
	lock_style.set_border_width_all(2)
	lock_style.set_corner_radius_all(8)
	lock_style.content_margin_left = 20
	lock_style.content_margin_right = 20
	lock_style.content_margin_top = 12
	lock_style.content_margin_bottom = 12
	btn.add_theme_stylebox_override("disabled", lock_style)
	btn.add_theme_color_override("font_color", Color("#64748b"))
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	return btn


func _close_education_modal_and_return_to_main() -> void:
	if education_modal_overlay != null and is_instance_valid(education_modal_overlay):
		education_modal_overlay.queue_free()
		education_modal_overlay = null
	show_tab("timeline")


func _close_gym_modal_and_return_to_main() -> void:
	if gym_modal_overlay != null and is_instance_valid(gym_modal_overlay):
		gym_modal_overlay.queue_free()
		gym_modal_overlay = null
	show_tab("timeline")


func _close_meditation_modal_and_return_to_main() -> void:
	if meditation_modal_overlay != null and is_instance_valid(meditation_modal_overlay):
		meditation_modal_overlay.queue_free()
		meditation_modal_overlay = null
	show_tab("timeline")


func _purchase_gym_membership() -> bool:
	var fee: int = PlayerData.gym_membership_annual_fee
	if PlayerData.bank_savings >= fee:
		PlayerData.bank_savings -= fee
	elif PlayerData.money >= fee:
		PlayerData.money -= fee
	else:
		add_life_event("❌ You need at least $%d to activate a Gym Membership." % fee, "finance")
		_close_gym_modal_and_return_to_main()
		return false
	PlayerData.has_gym_membership = true
	add_life_event("🏋️ Gym Membership ACTIVATED! ($%d/yr auto-debited annually). All gym workouts, classes, and athletic facilities are now 100%% FREE!" % fee, "activity")
	update_ui()
	SaveManager.save_game()
	_close_gym_modal_and_return_to_main()
	return true


func _cancel_gym_membership() -> void:
	PlayerData.has_gym_membership = false
	add_life_event("🚫 Gym Membership CANCELLED. You will no longer be billed annually, and gym workouts will now require day-pass fees.", "activity")
	update_ui()
	SaveManager.save_game()
	_close_gym_modal_and_return_to_main()


func _execute_gym_workout(w: Dictionary) -> bool:
	if PlayerData.last_gym_activity_age == PlayerData.age:
		_close_gym_modal_and_return_to_main()
		return false
	var effective_fee: int = 0 if PlayerData.has_gym_membership else int(w["cost"] if w.has("cost") else w.get("fee", 0))
	if effective_fee > 0 and PlayerData.money < effective_fee:
		add_life_event("You cannot afford the $%d day-pass fee for %s." % [effective_fee, str(w.get("name", w.get("title", "Workout")))], "finance")
		_close_gym_modal_and_return_to_main()
		return false
	if effective_fee > 0:
		PlayerData.money -= effective_fee
	PlayerData.last_gym_activity_age = PlayerData.age
	var h_gain: int = int(w.get("health", 0))
	if h_gain == 0 and w.has("health_min"):
		h_gain = randi_range(int(w["health_min"]), int(w["health_max"]))
	var l_gain: int = int(w.get("looks", 0))
	if l_gain == 0 and w.has("looks_min"):
		l_gain = randi_range(int(w["looks_min"]), int(w["looks_max"]))
	var hap_gain: int = int(w.get("happiness", 0))
	if hap_gain == 0 and w.has("hap_min"):
		hap_gain = randi_range(int(w["hap_min"]), int(w["hap_max"]))
	PlayerData.health = mini(100, PlayerData.health + h_gain)
	PlayerData.looks = mini(100, PlayerData.looks + l_gain)
	PlayerData.happiness = mini(100, PlayerData.happiness + hap_gain)
	var w_title: String = str(w.get("name", w.get("title", "Workout")))
	var w_msg: String = str(w.get("msg", "completed your training session."))
	if PlayerData.has_gym_membership:
		add_life_event("🏋️ [MEMBER PASS - FREE] You visited the gym for %s and %s (Health +%d, Looks +%d, Happiness +%d)." % [w_title, w_msg, h_gain, l_gain, hap_gain], "activity")
	else:
		add_life_event("🏋️ You paid a $%d day pass for %s and %s (Health +%d, Looks +%d, Happiness +%d)." % [effective_fee, w_title, w_msg, h_gain, l_gain, hap_gain], "activity")
	update_ui()
	SaveManager.save_game()
	_close_gym_modal_and_return_to_main()
	return true


func _execute_meditation(p: Dictionary) -> bool:
	if PlayerData.last_meditation_activity_age == PlayerData.age:
		_close_meditation_modal_and_return_to_main()
		return false
	var fee_val: int = int(p.get("cost", p.get("fee", 0)))
	if fee_val > 0 and PlayerData.money < fee_val:
		add_life_event("You cannot afford the $%d fee for %s." % [fee_val, str(p.get("name", p.get("title", "Meditation")))], "finance")
		_close_meditation_modal_and_return_to_main()
		return false
	if fee_val > 0:
		PlayerData.money -= fee_val
	PlayerData.last_meditation_activity_age = PlayerData.age
	var hap_gain: int = int(p.get("happiness", 0))
	if hap_gain == 0 and p.has("hap_min"):
		hap_gain = randi_range(int(p["hap_min"]), int(p["hap_max"]))
	var s_gain: int = int(p.get("smarts", 0))
	if s_gain == 0 and p.has("smarts_min"):
		s_gain = randi_range(int(p["smarts_min"]), int(p["smarts_max"]))
	var h_gain: int = int(p.get("health", 0))
	if h_gain == 0 and p.has("health_min"):
		h_gain = randi_range(int(p["health_min"]), int(p["health_max"]))
	var l_gain: int = int(p.get("looks", 0))
	if l_gain == 0 and p.has("looks_min"):
		l_gain = randi_range(int(p["looks_min"]), int(p["looks_max"]))
	var k_gain: int = int(p.get("karma", 0))
	if k_gain == 0 and p.has("karma_min"):
		k_gain = randi_range(int(p["karma_min"]), int(p["karma_max"]))
	PlayerData.happiness = mini(100, PlayerData.happiness + hap_gain)
	PlayerData.smarts = mini(100, PlayerData.smarts + s_gain)
	if h_gain > 0:
		PlayerData.health = mini(100, PlayerData.health + h_gain)
	if l_gain > 0:
		PlayerData.looks = mini(100, PlayerData.looks + l_gain)
	PlayerData.karma += k_gain
	var p_title: String = str(p.get("name", p.get("title", "Meditation")))
	if fee_val == 0:
		add_life_event("🧘 You engaged in %s. Serenity and peace wash over your mind. Happiness +%d, Karma +%d." % [p_title, hap_gain, k_gain], "activity")
	else:
		add_life_event("🧘 You attended %s ($%d). Deep tranquility and spiritual rejuvenation achieved! Happiness +%d, Karma +%d." % [p_title, fee_val, hap_gain, k_gain], "activity")
	update_ui()
	SaveManager.save_game()
	_close_meditation_modal_and_return_to_main()
	return true


func _show_gym_modal() -> void:
	if gym_modal_overlay != null and is_instance_valid(gym_modal_overlay):
		gym_modal_overlay.queue_free()

	var modal := _create_cyber_modal("🏋️ TITAN CYBER GYM & FITNESS", "Strength Training, Athletics, Aquatics & Annual Memberships", Color("#10b981"))
	gym_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# 1. Physical Fitness & Health Summary Card
	var summary_card := PanelContainer.new()
	summary_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#10b981")))
	var sm := MarginContainer.new()
	sm.add_theme_constant_override("margin_left", 20)
	sm.add_theme_constant_override("margin_right", 20)
	sm.add_theme_constant_override("margin_top", 16)
	sm.add_theme_constant_override("margin_bottom", 16)
	summary_card.add_child(sm)

	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 8)
	sm.add_child(sv)

	var stat_title := Label.new()
	stat_title.text = "💪 PHYSICAL PROFILE & HEALTH VITALS"
	stat_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stat_title.add_theme_font_size_override("font_size", 24)
	stat_title.add_theme_color_override("font_color", Color("#34d399"))
	sv.add_child(stat_title)

	var vitals_lbl := Label.new()
	vitals_lbl.text = "❤️ Health: %d%%   •   ✨ Looks: %d%%   •   😊 Happiness: %d%%" % [
		PlayerData.health,
		PlayerData.looks,
		PlayerData.happiness
	]
	vitals_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vitals_lbl.add_theme_font_size_override("font_size", 22)
	vitals_lbl.add_theme_color_override("font_color", Color("#f8fafc"))
	sv.add_child(vitals_lbl)

	var bank_lbl := Label.new()
	bank_lbl.text = "💰 Bank Savings: $%d   •   💵 Cash in Hand: $%d" % [
		PlayerData.bank_savings,
		PlayerData.money
	]
	bank_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bank_lbl.add_theme_font_size_override("font_size", 20)
	bank_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	sv.add_child(bank_lbl)

	list.add_child(summary_card)

	# 2. Gym Membership Card
	var mem_card := PanelContainer.new()
	var mem_border := Color("#38bdf8") if PlayerData.has_gym_membership else Color("#f59e0b")
	mem_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(mem_border))
	var mm := MarginContainer.new()
	mm.add_theme_constant_override("margin_left", 20)
	mm.add_theme_constant_override("margin_right", 20)
	mm.add_theme_constant_override("margin_top", 16)
	mm.add_theme_constant_override("margin_bottom", 16)
	mem_card.add_child(mm)

	var mv := VBoxContainer.new()
	mv.add_theme_constant_override("separation", 10)
	mm.add_child(mv)

	var mem_title := Label.new()
	mem_title.text = "💳 ALL-INCLUSIVE ANNUAL GYM MEMBERSHIP"
	mem_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mem_title.add_theme_font_size_override("font_size", 24)
	mem_title.add_theme_color_override("font_color", Color("#38bdf8"))
	mv.add_child(mem_title)

	var mem_desc := Label.new()
	if PlayerData.has_gym_membership:
		mem_desc.text = "STATUS: ACTIVE MEMBER ✅
Annual Fee: $%d/year (automatically debited from your bank account every year).
PERK: ALL gym visits, classes, weight rooms, and athletic tracks are 100%% FREE!" % PlayerData.gym_membership_annual_fee
		mem_desc.add_theme_color_override("font_color", Color("#34d399"))
	else:
		mem_desc.text = "STATUS: NON-MEMBER ❌
Annual Fee: $%d/year (debited directly from your bank account yearly).
BENEFIT: Unlocks 100%% FREE unlimited access to all workouts, swimming laps, spin classes, and boxing. Never pay individual day passes again!" % PlayerData.gym_membership_annual_fee
		mem_desc.add_theme_color_override("font_color", Color("#e2e8f0"))
	mem_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mem_desc.add_theme_font_size_override("font_size", 20)
	mv.add_child(mem_desc)

	if not PlayerData.has_gym_membership:
		var buy_btn := _create_cyber_button("💳 ACTIVATE GYM MEMBERSHIP ($300/yr Auto-Debit)
Start enjoying 100% free visits across all facilities", Color("#10b981"), func():
			_purchase_gym_membership()
		)
		mv.add_child(buy_btn)
	else:
		var cancel_btn := _create_cyber_button("❌ CANCEL GYM MEMBERSHIP
Stop annual auto-debit payments (Visits will revert to standard day-pass fees)", Color("#ef4444"), func():
			_cancel_gym_membership()
		)
		mv.add_child(cancel_btn)

	list.add_child(mem_card)

	# 3. Annual Workout Anti-Spam Gating Banner
	var has_worked_out_this_year: bool = (PlayerData.last_gym_activity_age == PlayerData.age)
	if has_worked_out_this_year:
		var lock_banner := PanelContainer.new()
		lock_banner.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
		var lm := MarginContainer.new()
		lm.add_theme_constant_override("margin_left", 18)
		lm.add_theme_constant_override("margin_right", 18)
		lm.add_theme_constant_override("margin_top", 12)
		lm.add_theme_constant_override("margin_bottom", 12)
		lock_banner.add_child(lm)

		var ll := Label.new()
		ll.text = "⏳ ANNUAL WORKOUT COMPLETED
You have already pushed your limits at the gym for Age %d.
To avoid muscle strain and exploit prevention, training options are locked until next year. Advance age (+1 Year) to train again!" % PlayerData.age
		ll.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ll.add_theme_font_size_override("font_size", 20)
		ll.add_theme_color_override("font_color", Color("#fbbf24"))
		lm.add_child(ll)
		list.add_child(lock_banner)

	# 4. Workout Options
	var workouts: Array = [
		{
			"title": "🏋️ Heavy Weight Training",
			"fee": 40,
			"health_min": 7, "health_max": 10,
			"looks_min": 6, "looks_max": 9,
			"hap_min": 4, "hap_max": 6,
			"desc": "Intense barbell squats, deadlifts, and bench presses. Builds substantial muscle and physical strength.",
			"msg": "pushed maximum reps on deadlifts and bench presses.",
			"color": Color("#34d399")
		},
		{
			"title": "🏃 Track Day & Sprint Intervals",
			"fee": 25,
			"health_min": 6, "health_max": 9,
			"looks_min": 4, "looks_max": 7,
			"hap_min": 5, "hap_max": 8,
			"desc": "High-octane sprint intervals, hurdles, and endurance laps on the Olympic synthetic track.",
			"msg": "burned rubber doing 400m sprint intervals on the track.",
			"color": Color("#38bdf8")
		},
		{
			"title": "🚴 HIIT Spin & Cardio Blast",
			"fee": 30,
			"health_min": 7, "health_max": 9,
			"looks_min": 5, "looks_max": 8,
			"hap_min": 6, "hap_max": 9,
			"desc": "High-intensity interval rhythm cycling class with motivating neon lights and pumping techno beats.",
			"msg": "sweated through an intense 45-minute HIIT spin blast.",
			"color": Color("#a855f7")
		},
		{
			"title": "🏊 Olympic Swimming & Laps",
			"fee": 50,
			"health_min": 8, "health_max": 11,
			"looks_min": 5, "looks_max": 7,
			"hap_min": 6, "hap_max": 8,
			"desc": "Low-impact, full-body cardiovascular workout swimming continuous freestyle laps in the heated pool.",
			"msg": "swam 40 continuous freestyle laps in the Olympic pool.",
			"color": Color("#06b6d4")
		},
		{
			"title": "🥊 Combat Boxing & Sparring",
			"fee": 60,
			"health_min": 8, "health_max": 12,
			"looks_min": 5, "looks_max": 8,
			"hap_min": 5, "hap_max": 8,
			"desc": "Heavy bag combos, speed bag agility, and controlled sparring with veteran pugilists.",
			"msg": "sharpened footwork and landed crisp combos in boxing sparring.",
			"color": Color("#f43f5e")
		},
		{
			"title": "💎 Elite VIP Personal Trainer",
			"fee": 120,
			"health_min": 11, "health_max": 15,
			"looks_min": 8, "looks_max": 12,
			"hap_min": 7, "hap_max": 10,
			"desc": "1-on-1 private conditioning, biomechanical analysis, and targeted aesthetic hypertrophy routine.",
			"msg": "trained with an elite master coach on a bespoke conditioning routine.",
			"color": Color("#eab308")
		}
	]

	for w in workouts:
		var fee_val: int = int(w["fee"])
		var price_str: String = "100% FREE (Membership Active)" if PlayerData.has_gym_membership else "$%d Day Pass" % fee_val
		var w_text: String = "%s (%s)
%s" % [str(w["title"]), price_str, str(w["desc"])]

		if has_worked_out_this_year:
			list.add_child(_create_disabled_cyber_button(w_text, "Completed for Age %d (Age up to workout next year)" % PlayerData.age))
		else:
			var btn := _create_cyber_button(w_text, w["color"], func():
				_execute_gym_workout(w)
			)
			list.add_child(btn)

	gym_modal_overlay.visible = true


func _show_meditation_modal() -> void:
	if meditation_modal_overlay != null and is_instance_valid(meditation_modal_overlay):
		meditation_modal_overlay.queue_free()

	var modal := _create_cyber_modal("🧘 NIRVANA MINDFULNESS & MEDITATION", "Breathwork, Yoga, Acoustic Sound Baths & Spiritual Healing", Color("#a855f7"))
	meditation_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# 1. Mental Wellness & Inner Peace Summary Card
	var summary_card := PanelContainer.new()
	summary_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#a855f7")))
	var sm := MarginContainer.new()
	sm.add_theme_constant_override("margin_left", 20)
	sm.add_theme_constant_override("margin_right", 20)
	sm.add_theme_constant_override("margin_top", 16)
	sm.add_theme_constant_override("margin_bottom", 16)
	summary_card.add_child(sm)

	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 8)
	sm.add_child(sv)

	var stat_title := Label.new()
	stat_title.text = "🧘 MENTAL WELLNESS & SPIRITUAL ALIGNMENT"
	stat_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stat_title.add_theme_font_size_override("font_size", 24)
	stat_title.add_theme_color_override("font_color", Color("#c084fc"))
	sv.add_child(stat_title)

	var mood_desc := "Serene & Blissful" if PlayerData.happiness >= 80 else ("Content" if PlayerData.happiness >= 60 else ("Stressed" if PlayerData.happiness >= 40 else "Depressed & Exhausted"))
	var vitals_lbl := Label.new()
	vitals_lbl.text = "😊 Happiness: %d%% (%s)   •   🧠 Smarts: %d%%   •   ☯ Karma: %d" % [
		PlayerData.happiness,
		mood_desc,
		PlayerData.smarts,
		PlayerData.karma
	]
	vitals_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vitals_lbl.add_theme_font_size_override("font_size", 22)
	vitals_lbl.add_theme_color_override("font_color", Color("#f8fafc"))
	sv.add_child(vitals_lbl)

	var benefit_lbl := Label.new()
	benefit_lbl.text = "Mindfulness Impact: Regular meditation cleanses mental fatigue, sharpens focus, reduces existential anxiety, and harmonizes positive karma. Advanced spiritual retreats grant major karmic redemption."
	benefit_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	benefit_lbl.add_theme_font_size_override("font_size", 20)
	benefit_lbl.add_theme_color_override("font_color", Color("#cbd5e1"))
	sv.add_child(benefit_lbl)

	list.add_child(summary_card)

	# 2. Annual Meditation Anti-Spam Gating Banner
	var has_meditated_this_year: bool = (PlayerData.last_meditation_activity_age == PlayerData.age)
	if has_meditated_this_year:
		var lock_banner := PanelContainer.new()
		lock_banner.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
		var lm := MarginContainer.new()
		lm.add_theme_constant_override("margin_left", 18)
		lm.add_theme_constant_override("margin_right", 18)
		lm.add_theme_constant_override("margin_top", 12)
		lm.add_theme_constant_override("margin_bottom", 12)
		lock_banner.add_child(lm)

		var ll := Label.new()
		ll.text = "⏳ ANNUAL MINDFULNESS SESSION COMPLETED
You have already completed your meditation session for Age %d.
To prevent status modifier exploits, mindfulness options are locked until next year. Advance age (+1 Year) to meditate again!" % PlayerData.age
		ll.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ll.add_theme_font_size_override("font_size", 20)
		ll.add_theme_color_override("font_color", Color("#fbbf24"))
		lm.add_child(ll)
		list.add_child(lock_banner)

	# 3. Meditation Options
	var practices: Array = [
		{
			"title": "🍃 Zen Breathwork & Vipassana (Free)",
			"fee": 0,
			"min_age": 5,
			"hap_min": 10, "hap_max": 14,
			"smarts_min": 1, "smarts_max": 2,
			"health_min": 0, "health_max": 0,
			"looks_min": 0, "looks_max": 0,
			"karma_min": 2, "karma_max": 3,
			"desc": "Sit quietly in lotus posture, focus on diaphragmatic breathing, and ground your awareness in the present moment.",
			"color": Color("#34d399")
		},
		{
			"title": "🧘 Vinyasa Flow Yoga Class ($25)",
			"fee": 25,
			"min_age": 5,
			"hap_min": 14, "hap_max": 18,
			"smarts_min": 1, "smarts_max": 2,
			"health_min": 3, "health_max": 5,
			"looks_min": 3, "looks_max": 4,
			"karma_min": 2, "karma_max": 4,
			"desc": "An energizing flow of warrior postures, spinal stretches, and mindful deep breathing led by a certified yogi.",
			"color": Color("#38bdf8")
		},
		{
			"title": "🔔 Tibetan Singing Bowls & Sound Bath ($50)",
			"fee": 50,
			"min_age": 5,
			"hap_min": 18, "hap_max": 24,
			"smarts_min": 3, "smarts_max": 5,
			"health_min": 1, "health_max": 3,
			"looks_min": 0, "looks_max": 0,
			"karma_min": 4, "karma_max": 6,
			"desc": "Harmonic vibrational acoustic therapy with hammered bronze bowls and quartz gongs to calm your central nervous system.",
			"color": Color("#f59e0b")
		},
		{
			"title": "✨ Spiritual Healing & Chakra Alignment ($90)",
			"fee": 90,
			"min_age": 10,
			"hap_min": 24, "hap_max": 30,
			"smarts_min": 2, "smarts_max": 3,
			"health_min": 2, "health_max": 4,
			"looks_min": 0, "looks_max": 0,
			"karma_min": 10, "karma_max": 14,
			"desc": "Realign your bio-energetic chakras, cleanse residual emotional trauma, and restore karmic purity with an ordained spiritual master.",
			"color": Color("#ec4899")
		},
		{
			"title": "🌌 Transcendental Sanctuary Retreat ($180)",
			"fee": 180,
			"min_age": 14,
			"hap_min": 32, "hap_max": 42,
			"smarts_min": 4, "smarts_max": 6,
			"health_min": 4, "health_max": 6,
			"looks_min": 2, "looks_max": 4,
			"karma_min": 16, "karma_max": 20,
			"desc": "An immersive all-day luxury digital detox retreat with botanical tea ceremonies, sensory rest, and profound guided enlightenment.",
			"color": Color("#a855f7")
		}
	]

	for p in practices:
		var fee_val: int = int(p["fee"])
		var fee_text: String = "Free" if fee_val == 0 else "$%d Cash" % fee_val
		var p_text: String = "%s (%s)
%s" % [str(p["title"]), fee_text, str(p["desc"])]
		var min_age_req: int = int(p["min_age"])

		if PlayerData.age < min_age_req:
			list.add_child(_create_disabled_cyber_button(p_text, "Requires Age %d+ (Current: %d)" % [min_age_req, PlayerData.age]))
		elif has_meditated_this_year:
			list.add_child(_create_disabled_cyber_button(p_text, "Completed for Age %d (Age up to meditate next year)" % PlayerData.age))
		else:
			var btn := _create_cyber_button(p_text, p["color"], func():
				_execute_meditation(p)
			)
			list.add_child(btn)

	meditation_modal_overlay.visible = true


# --- 1. DOCTOR MODAL ---
func _show_doctor_modal() -> void:
	if doctor_modal_overlay != null and is_instance_valid(doctor_modal_overlay):
		doctor_modal_overlay.queue_free()

	var modal := _create_cyber_modal("🩺 ST. JUDE MEDICAL CLINIC", "Advanced Diagnostics, Surgeries & Oncology", Color("#38bdf8"))
	doctor_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# Status Card
	var stat_card := PanelContainer.new()
	stat_card.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#38bdf8")))
	var stat_m := MarginContainer.new()
	stat_m.add_theme_constant_override("margin_left", 20)
	stat_m.add_theme_constant_override("margin_right", 20)
	stat_m.add_theme_constant_override("margin_top", 16)
	stat_m.add_theme_constant_override("margin_bottom", 16)
	stat_card.add_child(stat_m)

	var stat_v := VBoxContainer.new()
	stat_v.add_theme_constant_override("separation", 6)
	stat_m.add_child(stat_v)

	var health_lbl := Label.new()
	health_lbl.text = "Current Health: %d%%   •   Cash: $%s" % [PlayerData.health, _format_number(PlayerData.money)]
	health_lbl.add_theme_font_size_override("font_size", 24)
	health_lbl.add_theme_color_override("font_color", Color("#22c55e") if PlayerData.health > 40 else Color("#f87171"))
	stat_v.add_child(health_lbl)

	var illness_lbl := Label.new()
	if PlayerData.has_illness("cancer"):
		var cancer_info := PlayerData.get_illness("cancer")
		illness_lbl.text = "⚠️ ACTIVE SICKNESS: Stage %d Lymphoma Cancer (Urgent: Seek Chemotherapy!)" % int(cancer_info.get("stage", 1))
		illness_lbl.add_theme_color_override("font_color", Color("#ef4444"))
	else:
		illness_lbl.text = "Medical Status: No active malignant illnesses detected."
		illness_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	illness_lbl.add_theme_font_size_override("font_size", 21)
	stat_v.add_child(illness_lbl)

	list.add_child(stat_card)

	# Procedures:
	# 1. Vitamin Shot
	var btn_vit := _create_cyber_button("💉 Vitamin & Bio-Booster Shot ($150)  [+8 Health]", Color("#38bdf8"), func():
		if PlayerData.money >= 150:
			PlayerData.money -= 150
			PlayerData.health = mini(100, PlayerData.health + 8)
			add_life_event("You received a potent Vitamin & Bio-Booster injection ($150). Health +8%.", "health")
			update_ui()
			SaveManager.save_game()
			_show_doctor_modal()
		else:
			add_life_event("You couldn't afford a Vitamin Shot ($150 required).", "health")
	)
	list.add_child(btn_vit)

	# 2. General Checkup
	var btn_checkup := _create_cyber_button("🩺 Full Diagnostic Checkup ($300)  [+10 Health, Screen Illness]", Color("#38bdf8"), func():
		if PlayerData.money >= 300:
			PlayerData.money -= 300
			PlayerData.health = mini(100, PlayerData.health + 10)
			if PlayerData.has_illness("cancer"):
				var c: Dictionary = PlayerData.get_illness("cancer")
				add_life_event("Diagnostics warning: Physician confirmed Stage %d Cancer! Chemotherapy is urgently advised." % int(c.get("stage", 1)), "health")
			else:
				add_life_event("Physician examination concluded ($300). Clean bill of health! Health +10%.", "health")
			update_ui()
			SaveManager.save_game()
			_show_doctor_modal()
		else:
			add_life_event("You couldn't afford a Diagnostic Checkup ($300 required).", "health")
	)
	list.add_child(btn_checkup)

	# 3. Plastic Surgery
	var btn_surgery := _create_cyber_button("✨ Aesthetic Plastic Surgery ($3,500)  [+20 Looks, -12 Health, -8 Happy]", Color("#ec4899"), func():
		if PlayerData.money >= 3500:
			PlayerData.money -= 3500
			if randf() < 0.10: # 10% risk of botched surgery
				PlayerData.looks = maxi(0, PlayerData.looks - 12)
				PlayerData.health = maxi(0, PlayerData.health - 25)
				PlayerData.happiness = maxi(0, PlayerData.happiness - 20)
				add_life_event("⚠️ BOTCHED SURGERY: Surgical complications resulted in severe facial scarring and agony! Looks -12%, Health -25%, Happiness -20%.", "health")
			else:
				PlayerData.looks = mini(100, PlayerData.looks + 20)
				PlayerData.health = maxi(0, PlayerData.health - 12)
				PlayerData.happiness = maxi(0, PlayerData.happiness - 8)
				add_life_event("Aesthetic surgery successful! Looks surged by +20%, though post-op recovery is uncomfortable (Health -12%, Happiness -8%).", "health")

			update_ui()
			SaveManager.save_game()
			if PlayerData.health <= 0:
				doctor_modal_overlay.visible = false
				trigger_death("Complications from Botched Surgery")
			else:
				_show_doctor_modal()
		else:
			add_life_event("You couldn't afford Plastic Surgery ($3,500 required).", "health")
	)
	list.add_child(btn_surgery)

	# 4. Chemotherapy Treatment
	var btn_chemo := _create_cyber_button("🧬 Chemotherapy Treatment ($5,000)  [Treats & Cures Cancer]", Color("#f43f5e"), func():
		if PlayerData.money >= 5000:
			PlayerData.money -= 5000
			if PlayerData.has_illness("cancer"):
				if randf() < 0.60:
					PlayerData.cure_illness("cancer")
					PlayerData.health = mini(100, PlayerData.health + 15)
					PlayerData.happiness = mini(100, PlayerData.happiness + 25)
					add_life_event("🎉 REMISSION ACHIEVED: Intensive chemotherapy eradicated all cancer cells! You are officially CANCER-FREE!", "health")
				else:
					var c := PlayerData.get_illness("cancer")
					c["stage"] = maxi(1, int(c.get("stage", 1)) - 1)
					PlayerData.happiness = mini(100, PlayerData.happiness + 10)
					add_life_event("Chemotherapy stabilized your tumor growth and reduced metastasis. Continued vigilance recommended.", "health")
			else:
				add_life_event("The oncologist ran full scans ($5,000). No malignant tumors detected! Chemotherapy was not administered.", "health")
			update_ui()
			SaveManager.save_game()
			_show_doctor_modal()
		else:
			add_life_event("You couldn't afford Chemotherapy Treatment ($5,000 required).", "health")
	)
	list.add_child(btn_chemo)

	# 5. Psychotherapy & Grief Counseling
	var btn_therapy := _create_cyber_button("🧠 Psychotherapy & Grief Counseling ($250)  [+20 Happiness]", Color("#8b5cf6"), func():
		if PlayerData.money >= 250:
			PlayerData.money -= 250
			PlayerData.happiness = mini(100, PlayerData.happiness + 20)
			add_life_event("You attended an enlightening psychotherapy session ($250). Grief and emotional weight lifted. Happiness +20%.", "health")
			update_ui()
			SaveManager.save_game()
			_show_doctor_modal()
		else:
			add_life_event("You couldn't afford Psychotherapy ($250 required).", "health")
	)
	list.add_child(btn_therapy)

	# 6. Emergency Trauma Care
	var btn_er := _create_cyber_button("🚨 Emergency ER Resuscitation ($1,500)  [+40 Health]", Color("#eab308"), func():
		if PlayerData.money >= 1500:
			PlayerData.money -= 1500
			PlayerData.health = mini(100, PlayerData.health + 40)
			add_life_event("ER medical trauma team stabilized your critical vitals ($1,500). Health +40%.", "health")
			update_ui()
			SaveManager.save_game()
			_show_doctor_modal()
		else:
			add_life_event("You couldn't afford Emergency ER care ($1,500 required).", "health")
	)
	list.add_child(btn_er)

	doctor_modal_overlay.visible = true


# --- 2. CRIME & PRISON MODAL ---
func _show_crime_modal() -> void:
	if crime_modal_overlay != null and is_instance_valid(crime_modal_overlay):
		crime_modal_overlay.queue_free()

	if PlayerData.is_in_prison:
		var prison_modal := _create_cyber_modal("🔒 STATE PENITENTIARY", "Inmate Profile • Sentence Remaining: %d years" % PlayerData.prison_sentence_years, Color("#ef4444"))
		crime_modal_overlay = prison_modal.overlay
		var p_list: VBoxContainer = prison_modal.list

		var info_lbl := Label.new()
		info_lbl.text = "You are currently incarcerated. Your criminal record stripped your job and credentials.\nAge up to advance your sentence years."
		info_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		info_lbl.add_theme_font_size_override("font_size", 22)
		info_lbl.add_theme_color_override("font_color", Color("#f87171"))
		p_list.add_child(info_lbl)

		var btn_yard := _create_cyber_button("🏋️ Hit the Prison Yard Weights  [+6 Health, +3 Looks, +5 Happy]", Color("#ef4444"), func():
			PlayerData.health = mini(100, PlayerData.health + 6)
			PlayerData.looks = mini(100, PlayerData.looks + 3)
			PlayerData.happiness = mini(100, PlayerData.happiness + 5)
			add_life_event("You pumped iron in the prison yard. Fellow inmates respect your discipline.", "crime")
			update_ui()
			SaveManager.save_game()
			_show_crime_modal()
		)
		p_list.add_child(btn_yard)

		var btn_read := _create_cyber_button("📖 Read in Prison Library  [+5 Smarts, +4 Happy]", Color("#38bdf8"), func():
			PlayerData.smarts = mini(100, PlayerData.smarts + 5)
			PlayerData.happiness = mini(100, PlayerData.happiness + 4)
			add_life_event("You immersed yourself in law and literature in the penitentiary library.", "crime")
			update_ui()
			SaveManager.save_game()
			_show_crime_modal()
		)
		p_list.add_child(btn_read)

		var btn_sleep := _create_cyber_button("💤 Rest in Cell / Keep Low Profile  [+2 Health]", Color("#94a3b8"), func():
			PlayerData.health = mini(100, PlayerData.health + 2)
			add_life_event("You kept to yourself and avoided penitentiary gang disputes.", "crime")
			update_ui()
			SaveManager.save_game()
			_show_crime_modal()
		)
		p_list.add_child(btn_sleep)

		crime_modal_overlay.visible = true
		return

	# Free Citizen Underground Menu
	var modal := _create_cyber_modal("🕶️ UNDERGROUND SYNDICATE", "Cash: $%s   •   Karma: %d   •   High Risk Activities" % [_format_number(PlayerData.money), PlayerData.karma], Color("#a855f7"))
	crime_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	var warning_lbl := Label.new()
	warning_lbl.text = "⚠️ WARNING: Getting apprehended by law enforcement will strip all your jobs and sentence you to prison."
	warning_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	warning_lbl.add_theme_font_size_override("font_size", 21)
	warning_lbl.add_theme_color_override("font_color", Color("#fbbf24"))
	list.add_child(warning_lbl)

	var crimes := [
		["👝 Pickpocket Commuters (Risk: 20% • Gain: $60-$180)", 0.20, 60, 180, 1, 2, 5],
		["🏬 Shoplift Cyber Tech Store (Risk: 38% • Gain: $400-$1,200)", 0.38, 400, 1200, 2, 6, 10],
		["🚗 Grand Theft Auto (Risk: 55% • Gain: $3,500-$8,000)", 0.55, 3500, 8000, 4, 14, 20],
		["💻 Syndicate Wire Fraud (Risk: 70% • Gain: $15,000-$35,000)", 0.70, 15000, 35000, 7, 25, 35]
	]

	for c in crimes:
		var crime_name: String = c[0]
		var risk: float = c[1]
		var min_g: int = c[2]
		var max_g: int = c[3]
		var sentence: int = c[4]
		var karma_loss: int = c[5]
		var caught_karma: int = c[6]

		var btn := _create_cyber_button(crime_name, Color("#a855f7"), func():
			if randf() < risk:
				# Arrested!
				PlayerData.is_in_prison = true
				PlayerData.prison_sentence_years = sentence
				PlayerData.job_id = ""
				PlayerData.job_title = ""
				PlayerData.job_company = ""
				PlayerData.job_salary = 0
				PlayerData.karma -= caught_karma
				PlayerData.happiness = maxi(5, PlayerData.happiness - 30)
				add_life_event("🚨 ARRESTED! Caught red-handed by the police and sentenced to %d years in State Penitentiary. You lost your career!" % sentence, "crime")
				update_ui()
				SaveManager.save_game()
				_show_crime_modal()
			else:
				var earn: int = randi_range(min_g, max_g)
				PlayerData.money += earn
				PlayerData.karma -= karma_loss
				add_life_event("You pulled off an underground heist and pocketed $%s!" % _format_number(earn), "crime")
				update_ui()
				SaveManager.save_game()
				_show_crime_modal()
		)
		list.add_child(btn)

	crime_modal_overlay.visible = true


# --- 3. CASINO & GAMBLING MODAL ---
var casino_scratch_result_lbl: Label = null
var casino_slots_display_lbl: Label = null
var casino_slots_result_lbl: Label = null
var casino_dice_display_lbl: Label = null
var casino_dice_result_lbl: Label = null
var current_dice_bet_amount: int = 100

func _show_casino_modal() -> void:
	if casino_modal_overlay != null and is_instance_valid(casino_modal_overlay):
		casino_modal_overlay.queue_free()

	var modal := _create_cyber_modal("🎰 THE NEON PALACE CASINO", "Cash on Hand: $%s  •  Dice, Slots & Scratchcards" % _format_number(PlayerData.money), Color("#f59e0b"))
	casino_modal_overlay = modal.overlay
	var list: VBoxContainer = modal.list

	# GAME 1: Cyber Scratchcard ($25)
	var card_scratch := PanelContainer.new()
	card_scratch.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
	var m_scratch := MarginContainer.new()
	m_scratch.add_theme_constant_override("margin_left", 20)
	m_scratch.add_theme_constant_override("margin_right", 20)
	m_scratch.add_theme_constant_override("margin_top", 16)
	m_scratch.add_theme_constant_override("margin_bottom", 16)
	card_scratch.add_child(m_scratch)

	var v_scratch := VBoxContainer.new()
	v_scratch.add_theme_constant_override("separation", 10)
	m_scratch.add_child(v_scratch)

	var scratch_title := Label.new()
	scratch_title.text = "🎟️ LUCKY CYBER SCRATCHCARD ($25)"
	scratch_title.add_theme_font_size_override("font_size", 26)
	scratch_title.add_theme_color_override("font_color", Color("#fbbf24"))
	v_scratch.add_child(scratch_title)

	casino_scratch_result_lbl = Label.new()
	casino_scratch_result_lbl.text = "Reveal 3 matching symbols to win up to $500!"
	casino_scratch_result_lbl.add_theme_font_size_override("font_size", 22)
	casino_scratch_result_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	v_scratch.add_child(casino_scratch_result_lbl)

	var btn_scratch := _create_cyber_button("Scratch Ticket ($25)", Color("#f59e0b"), func():
		if PlayerData.money >= 25:
			PlayerData.money -= 25
			# 30% winning chance with house edge
			if randf() < 0.30:
				var roll := randf()
				var win := 50
				var sym := "💎"
				if roll < 0.12:
					win = 500
					sym = "7️⃣"
				elif roll < 0.40:
					win = 150
					sym = "🔔"

				PlayerData.money += win
				casino_scratch_result_lbl.text = "[ %s | %s | %s ] -> WINNER! You won $%d!" % [sym, sym, sym, win]
				casino_scratch_result_lbl.add_theme_color_override("font_color", Color("#22c55e"))
				add_life_event("You scratched a winning lottery ticket and cashed out $%d!" % win, "finance")
			else:
				var symbols := ["🍒", "🔔", "💀", "⭐", "🍋"]
				symbols.shuffle()
				casino_scratch_result_lbl.text = "[ %s | %s | %s ] -> No match. Better luck next time!" % [symbols[0], symbols[1], symbols[2]]
				casino_scratch_result_lbl.add_theme_color_override("font_color", Color("#f87171"))
			update_ui()
			SaveManager.save_game()
			modal.subtitle.text = "Cash on Hand: $%s  •  Dice, Slots & Scratchcards" % _format_number(PlayerData.money)
		else:
			casino_scratch_result_lbl.text = "Insufficient funds for $25 scratchcard."
			casino_scratch_result_lbl.add_theme_color_override("font_color", Color("#ef4444"))
	)
	v_scratch.add_child(btn_scratch)
	list.add_child(card_scratch)

	# GAME 2: Neon 3-Reel Slots ($50)
	var card_slots := PanelContainer.new()
	card_slots.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
	var m_slots := MarginContainer.new()
	m_slots.add_theme_constant_override("margin_left", 20)
	m_slots.add_theme_constant_override("margin_right", 20)
	m_slots.add_theme_constant_override("margin_top", 16)
	m_slots.add_theme_constant_override("margin_bottom", 16)
	card_slots.add_child(m_slots)

	var v_slots := VBoxContainer.new()
	v_slots.add_theme_constant_override("separation", 10)
	m_slots.add_child(v_slots)

	var slots_title := Label.new()
	slots_title.text = "🎰 NEON 3-REEL SLOT MACHINE ($50 / SPIN)"
	slots_title.add_theme_font_size_override("font_size", 26)
	slots_title.add_theme_color_override("font_color", Color("#fbbf24"))
	v_slots.add_child(slots_title)

	casino_slots_display_lbl = Label.new()
	casino_slots_display_lbl.text = "[ 🎰 | 🎰 | 🎰 ]"
	casino_slots_display_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	casino_slots_display_lbl.add_theme_font_size_override("font_size", 42)
	casino_slots_display_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
	v_slots.add_child(casino_slots_display_lbl)

	casino_slots_result_lbl = Label.new()
	casino_slots_result_lbl.text = "Payouts: 7️⃣7️⃣7️⃣ = $5,000  •  💎💎💎 = $1,200  •  🔔🔔🔔 = $450  •  🍒🍒🍒 = $180"
	casino_slots_result_lbl.add_theme_font_size_override("font_size", 20)
	casino_slots_result_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	v_slots.add_child(casino_slots_result_lbl)

	var btn_spin := _create_cyber_button("Spin Reels ($50)", Color("#f59e0b"), func():
		if PlayerData.money >= 50:
			PlayerData.money -= 50
			var syms := ["🍒", "🔔", "💎", "7️⃣", "💀"]
			# 24% chance of 3-match
			if randf() < 0.24:
				var r := randf()
				var win_sym := "🍒"
				var payout := 180
				if r < 0.08:
					win_sym = "7️⃣"
					payout = 5000
				elif r < 0.28:
					win_sym = "💎"
					payout = 1200
				elif r < 0.60:
					win_sym = "🔔"
					payout = 450
				elif r < 0.70:
					win_sym = "💀"
					payout = 0

				PlayerData.money += payout
				casino_slots_display_lbl.text = "[ %s | %s | %s ]" % [win_sym, win_sym, win_sym]
				if payout > 0:
					casino_slots_result_lbl.text = "JACKPOT! Three matching %s pays $%d!" % [win_sym, payout]
					casino_slots_result_lbl.add_theme_color_override("font_color", Color("#22c55e"))
					add_life_event("You hit 3 %s on the slot machine and won $%d!" % [win_sym, payout], "finance")
				else:
					casino_slots_result_lbl.text = "Cursed Skull Spin! No payout."
					casino_slots_result_lbl.add_theme_color_override("font_color", Color("#f87171"))
			else:
				var s1: String = str(syms.pick_random())
				var s2: String = str(syms.pick_random())
				var s3: String = str(syms.pick_random())
				if s1 == s2 and s2 == s3:
					s3 = "🍒" if s1 != "🍒" else "🔔"
				casino_slots_display_lbl.text = "[ %s | %s | %s ]" % [s1, s2, s3]
				if s1 == s2 or s2 == s3 or s1 == s3:
					PlayerData.money += 25
					casino_slots_result_lbl.text = "Pair match! Consolation prize: $25."
					casino_slots_result_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
				else:
					casino_slots_result_lbl.text = "No match. Spin again!"
					casino_slots_result_lbl.add_theme_color_override("font_color", Color("#94a3b8"))

			update_ui()
			SaveManager.save_game()
			modal.subtitle.text = "Cash on Hand: $%s  •  Dice, Slots & Scratchcards" % _format_number(PlayerData.money)
		else:
			casino_slots_result_lbl.text = "Insufficient funds for $50 spin."
			casino_slots_result_lbl.add_theme_color_override("font_color", Color("#ef4444"))
	)
	v_slots.add_child(btn_spin)
	list.add_child(card_slots)

	# GAME 3: High-Stakes Craps (Dice Roll)
	var card_dice := PanelContainer.new()
	card_dice.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f59e0b")))
	var m_dice := MarginContainer.new()
	m_dice.add_theme_constant_override("margin_left", 20)
	m_dice.add_theme_constant_override("margin_right", 20)
	m_dice.add_theme_constant_override("margin_top", 16)
	m_dice.add_theme_constant_override("margin_bottom", 16)
	card_dice.add_child(m_dice)

	var v_dice := VBoxContainer.new()
	v_dice.add_theme_constant_override("separation", 10)
	m_dice.add_child(v_dice)

	var dice_title := Label.new()
	dice_title.text = "🎲 HIGH-STAKES CRAPS & DICE ROLL"
	dice_title.add_theme_font_size_override("font_size", 26)
	dice_title.add_theme_color_override("font_color", Color("#fbbf24"))
	v_dice.add_child(dice_title)

	casino_dice_display_lbl = Label.new()
	casino_dice_display_lbl.text = "🎲 [ ? ] + 🎲 [ ? ] = ?"
	casino_dice_display_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	casino_dice_display_lbl.add_theme_font_size_override("font_size", 38)
	casino_dice_display_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
	v_dice.add_child(casino_dice_display_lbl)

	casino_dice_result_lbl = Label.new()
	casino_dice_result_lbl.text = "Choose your wager amount and place your prediction:"
	casino_dice_result_lbl.add_theme_font_size_override("font_size", 21)
	casino_dice_result_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	v_dice.add_child(casino_dice_result_lbl)

	# Bet Amount Selector Row
	var bet_row := HBoxContainer.new()
	bet_row.add_theme_constant_override("separation", 10)
	v_dice.add_child(bet_row)

	var bet_amounts := [100, 500, 2000]
	for amt in bet_amounts:
		var btn_b := Button.new()
		btn_b.text = "Wager $%d" % amt
		btn_b.custom_minimum_size.y = 52
		btn_b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_b.add_theme_font_size_override("font_size", 20)
		var b_style := StyleBoxFlat.new()
		b_style.bg_color = Color("#1e293b")
		b_style.border_color = Color("#f59e0b")
		b_style.set_border_width_all(2)
		b_style.set_corner_radius_all(6)
		btn_b.add_theme_stylebox_override("normal", b_style)
		btn_b.add_theme_color_override("font_color", Color("#f8fafc"))
		btn_b.pressed.connect(func():
			current_dice_bet_amount = amt
			casino_dice_result_lbl.text = "Active Wager Set: $%d. Pick your prediction below!" % amt
			casino_dice_result_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
		)
		bet_row.add_child(btn_b)

	# Prediction Roll Buttons
	var roll_options := [
		["Under 7 (Roll 2 - 6 • 2x Payout)", "under"],
		["Over 7 (Roll 8 - 12 • 2x Payout)", "over"],
		["Lucky Seven (Roll exactly 7 • 4x Payout)", "seven"],
		["Snake Eyes or Boxcars (Roll 2 or 12 • 15x Payout)", "extreme"]
	]

	for opt in roll_options:
		var opt_text: String = opt[0]
		var opt_key: String = opt[1]
		var btn_opt := _create_cyber_button(opt_text, Color("#f59e0b"), func():
			_play_dice_roll(opt_key, modal)
		)
		v_dice.add_child(btn_opt)

	list.add_child(card_dice)
	casino_modal_overlay.visible = true


func _play_dice_roll(prediction: String, modal: Dictionary) -> void:
	if PlayerData.money < current_dice_bet_amount:
		casino_dice_result_lbl.text = "Insufficient funds for $%d wager!" % current_dice_bet_amount
		casino_dice_result_lbl.add_theme_color_override("font_color", Color("#ef4444"))
		return

	PlayerData.money -= current_dice_bet_amount
	var d1: int = randi_range(1, 6)
	var d2: int = randi_range(1, 6)
	var sum: int = d1 + d2
	casino_dice_display_lbl.text = "🎲 [ %d ] + 🎲 [ %d ] = %d" % [d1, d2, sum]

	var won: bool = false
	var multiplier: int = 0

	match prediction:
		"under":
			if sum < 7:
				won = true
				multiplier = 2
		"over":
			if sum > 7:
				won = true
				multiplier = 2
		"seven":
			if sum == 7:
				won = true
				multiplier = 4
		"extreme":
			if sum == 2 or sum == 12:
				won = true
				multiplier = 15

	if won:
		var win_amount: int = current_dice_bet_amount * multiplier
		PlayerData.money += win_amount
		casino_dice_result_lbl.text = "WINNER! The dice landed on %d! You won $%s!" % [sum, _format_number(win_amount)]
		casino_dice_result_lbl.add_theme_color_override("font_color", Color("#22c55e"))
		add_life_event("You rolled a %d in craps and won $%s!" % [sum, _format_number(win_amount)], "finance")
	else:
		casino_dice_result_lbl.text = "LOST: The dice landed on %d. Lost $%d wager." % [sum, current_dice_bet_amount]
		casino_dice_result_lbl.add_theme_color_override("font_color", Color("#f87171"))

	update_ui()
	SaveManager.save_game()
	modal.subtitle.text = "Cash on Hand: $%s  •  Dice, Slots & Scratchcards" % _format_number(PlayerData.money)


# --- 4. DEATH SCREEN SYSTEM ---
func _show_death_screen(cause: String) -> void:
	if death_screen_overlay != null and is_instance_valid(death_screen_overlay):
		death_screen_overlay.queue_free()

	death_screen_overlay = ColorRect.new()
	death_screen_overlay.color = Color(0.015, 0.01, 0.03, 0.95)
	death_screen_overlay.anchors_preset = Control.PRESET_FULL_RECT
	death_screen_overlay.anchor_right = 1.0
	death_screen_overlay.anchor_bottom = 1.0
	death_screen_overlay.grow_horizontal = Control.GROW_DIRECTION_BOTH
	death_screen_overlay.grow_vertical = Control.GROW_DIRECTION_BOTH
	death_screen_overlay.z_index = 80
	add_child(death_screen_overlay)

	var center := CenterContainer.new()
	center.anchors_preset = Control.PRESET_FULL_RECT
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	death_screen_overlay.add_child(center)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(920, 1180)
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("#07050d")
	card_style.border_color = Color("#f43f5e")
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(14)
	card_style.shadow_color = Color(0, 0, 0, 0.95)
	card_style.shadow_size = 24
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 42)
	margin.add_theme_constant_override("margin_right", 42)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	card.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	margin.add_child(vbox)

	var title_lbl := Label.new()
	title_lbl.text = "💀 FLATLINED • REST IN PEACE 💀"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 38)
	title_lbl.add_theme_color_override("font_color", Color("#f43f5e"))
	vbox.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "YOUR SIMULATED LIFETIME HAS COME TO AN END"
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.add_theme_font_size_override("font_size", 22)
	sub_lbl.add_theme_color_override("font_color", Color("#94a3b8"))
	vbox.add_child(sub_lbl)

	# Stats breakdown card
	var stats_p := PanelContainer.new()
	stats_p.add_theme_stylebox_override("panel", load_style_box_cyber_card(Color("#f43f5e")))
	var sp_m := MarginContainer.new()
	sp_m.add_theme_constant_override("margin_left", 24)
	sp_m.add_theme_constant_override("margin_right", 24)
	sp_m.add_theme_constant_override("margin_top", 20)
	sp_m.add_theme_constant_override("margin_bottom", 20)
	stats_p.add_child(sp_m)

	var stats_v := VBoxContainer.new()
	stats_v.add_theme_constant_override("separation", 8)
	sp_m.add_child(stats_v)

	var name_lbl := Label.new()
	name_lbl.text = "Identity: %s   •   Birthplace: %s" % [PlayerData.first_name, PlayerData.birthplace]
	name_lbl.add_theme_font_size_override("font_size", 26)
	name_lbl.add_theme_color_override("font_color", Color("#38bdf8"))
	stats_v.add_child(name_lbl)

	var clean_cause: String = cause.strip_edges()
	if clean_cause == "":
		clean_cause = "Acute Medical Complications"

	var age_cause_lbl := Label.new()
	age_cause_lbl.text = "Age of Demise: %d years\nCause of Death: %s" % [PlayerData.age, clean_cause]
	age_cause_lbl.add_theme_font_size_override("font_size", 24)
	age_cause_lbl.add_theme_color_override("font_color", Color("#f87171"))
	stats_v.add_child(age_cause_lbl)

	var wealth_lbl := Label.new()
	wealth_lbl.text = "Final Net Worth: $%s" % _format_number(PlayerData.get_net_worth())
	wealth_lbl.add_theme_font_size_override("font_size", 24)
	wealth_lbl.add_theme_color_override("font_color", Color("#22c55e"))
	stats_v.add_child(wealth_lbl)

	var career_str := "%s at %s" % [PlayerData.job_title, PlayerData.job_company] if PlayerData.job_title != "" else "Unemployed"
	var career_lbl := Label.new()
	career_lbl.text = "Last Occupation: %s" % career_str
	career_lbl.add_theme_font_size_override("font_size", 24)
	career_lbl.add_theme_color_override("font_color", Color("#f1f5f9"))
	stats_v.add_child(career_lbl)

	vbox.add_child(stats_p)

	# Dedicated Coroner Report & Death Narrative Card
	var coroner_p := PanelContainer.new()
	var coroner_style := StyleBoxFlat.new()
	coroner_style.bg_color = Color("#0c0915")
	coroner_style.border_color = Color("#475569")
	coroner_style.set_border_width_all(2)
	coroner_style.set_corner_radius_all(10)
	coroner_p.add_theme_stylebox_override("panel", coroner_style)

	var cp_m := MarginContainer.new()
	cp_m.add_theme_constant_override("margin_left", 22)
	cp_m.add_theme_constant_override("margin_right", 22)
	cp_m.add_theme_constant_override("margin_top", 18)
	cp_m.add_theme_constant_override("margin_bottom", 18)
	coroner_p.add_child(cp_m)

	var cp_v := VBoxContainer.new()
	cp_v.add_theme_constant_override("separation", 10)
	cp_m.add_child(cp_v)

	var coroner_header := Label.new()
	coroner_header.text = "📋 OFFICIAL DEATH REPORT & CIRCUMSTANCES"
	coroner_header.add_theme_font_size_override("font_size", 20)
	coroner_header.add_theme_color_override("font_color", Color("#fbbf24"))
	cp_v.add_child(coroner_header)

	var death_desc_lbl := Label.new()
	death_desc_lbl.text = _generate_death_narrative(clean_cause)
	death_desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	death_desc_lbl.add_theme_font_size_override("font_size", 22)
	death_desc_lbl.add_theme_color_override("font_color", Color("#f8fafc"))
	cp_v.add_child(death_desc_lbl)

	var eulogy_header := Label.new()
	eulogy_header.text = "MEMORIAL EPITAPH:"
	eulogy_header.add_theme_font_size_override("font_size", 18)
	eulogy_header.add_theme_color_override("font_color", Color("#94a3b8"))
	cp_v.add_child(eulogy_header)

	var epitaph_lbl := Label.new()
	var eulogy: String = ""
	if PlayerData.age >= 75:
		eulogy = "\"Having walked a long, memorable journey through youth, adulthood, and twilight years, %s passed peacefully from this realm. Their deeds echo in memory.\"" % PlayerData.first_name
	elif PlayerData.age >= 40:
		eulogy = "\"Cut short in the prime of life, %s left behind friends, memories, and aspirations. May their soul rest in eternal peace.\"" % PlayerData.first_name
	else:
		eulogy = "\"Taken far too soon at age %d by tragic misfortune, %s's life was a fleeting spark that touched those who loved them.\"" % [PlayerData.age, PlayerData.first_name]
	epitaph_lbl.text = eulogy
	epitaph_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	epitaph_lbl.add_theme_font_size_override("font_size", 20)
	epitaph_lbl.add_theme_color_override("font_color", Color("#cbd5e1"))
	cp_v.add_child(epitaph_lbl)

	vbox.add_child(coroner_p)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)

	# Start New Life Button
	var btn_new_life := Button.new()
	btn_new_life.text = "✨ START A NEW LIFE"
	btn_new_life.custom_minimum_size.y = 84
	btn_new_life.add_theme_font_size_override("font_size", 28)
	var new_life_style := StyleBoxFlat.new()
	new_life_style.bg_color = Color("#15803d")
	new_life_style.border_color = Color("#22c55e")
	new_life_style.set_border_width_all(3)
	new_life_style.set_corner_radius_all(10)
	btn_new_life.add_theme_stylebox_override("normal", new_life_style)
	var new_life_hover := new_life_style.duplicate() as StyleBoxFlat
	new_life_hover.bg_color = Color("#16a34a")
	btn_new_life.add_theme_stylebox_override("hover", new_life_hover)
	btn_new_life.add_theme_color_override("font_color", Color("#ffffff"))
	btn_new_life.pressed.connect(_on_start_new_life_pressed)
	vbox.add_child(btn_new_life)


func _on_start_new_life_pressed() -> void:
	if death_screen_overlay != null and is_instance_valid(death_screen_overlay):
		death_screen_overlay.queue_free()
		death_screen_overlay = null

	SaveManager.delete_save()
	PlayerData.reset_player()

	current_event = null
	current_event_choices.clear()
	hide_event_popup()

	life_feed.clear()
	update_history_panel()
	update_character_panel()
	show_tab("timeline")
	show_new_game_screen()


func _generate_death_narrative(cause: String) -> String:
	var c_lower := cause.to_lower()
	var char_name := PlayerData.first_name
	var age := PlayerData.age

	if "cancer" in c_lower or "lymphoma" in c_lower:
		return "At the age of %d, %s succumbed to %s after their health depleted to 0%%. The malignant illness proved fatal despite all warnings." % [age, char_name, cause]
	elif "collision" in c_lower or "crash" in c_lower or "accident" in c_lower:
		return "At the age of %d, %s lost their life in a %s. Fatal trauma instantly depleted their vital signs to 0%%." % [age, char_name, cause]
	elif "surgery" in c_lower or "botched" in c_lower:
		return "At the age of %d, %s passed away due to %s during an invasive surgical procedure." % [age, char_name, cause]
	elif "cardiac" in c_lower or "heart" in c_lower:
		return "At the age of %d, %s suffered acute heart failure caused by %s, causing their vital signs to flatline." % [age, char_name, cause]
	elif "old age" in c_lower:
		return "%s passed away peacefully in their sleep at the age of %d from %s, concluding a long simulated lifetime." % [char_name, age, cause]
	elif "exhaustion" in c_lower or "stress" in c_lower or "debt" in c_lower:
		return "At the age of %d, %s succumbed to %s after severe financial and physical strain depleted their health to 0%%." % [age, char_name, cause]
	else:
		return "At the age of %d, %s passed away. The primary registered cause of death is %s, which reduced their vital health to 0%%." % [age, char_name, cause]


func _configure_creation() -> void:
	name_input.max_length = 40
	name_input.focus_exited.connect(func(): name_input.text = CreationOptions.normalize_name(name_input.text))
	birthplace_input.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	birthplace_input.add_theme_constant_override("icon_max_width", 64)
	var popup := birthplace_input.get_popup()
	popup.max_size = Vector2i(760, 700)
	popup.add_theme_constant_override("icon_max_width", 64)
	popup.add_theme_constant_override("v_separation", 16)
	popup.add_theme_font_size_override("font_size", 28)
	for country in CreationOptions.COUNTRIES:
		birthplace_input.add_icon_item(CreationOptions.flag_texture(country[1], country[2]), country[0])
	birthplace_input.select(8)
	var content := name_input.get_parent()

	var gender_label := Label.new()
	gender_label.name = "GenderLabel"
	gender_label.text = "GENDER"
	gender_label.add_theme_font_size_override("font_size", 24)
	content.add_child(gender_label)
	content.move_child(gender_label, birthplace_input.get_index() + 1)

	gender_input = OptionButton.new()
	gender_input.name = "GenderInput"
	gender_input.add_item("MALE")
	gender_input.add_item("FEMALE")
	gender_input.custom_minimum_size.y = 76
	content.add_child(gender_input)
	content.move_child(gender_input, gender_label.get_index() + 1)

	var random_button := Button.new()
	random_button.name = "RandomizeButton"
	random_button.text = "🎲 Randomize Name & Country"
	random_button.custom_minimum_size.y = 76
	random_button.pressed.connect(_randomize_identity)
	content.add_child(random_button)
	content.move_child(random_button, gender_input.get_index() + 1)

	# Card Styling: High-contrast Dark Cyber Card
	var card := content.get_parent() as PanelContainer
	card.custom_minimum_size = Vector2(860, 1140)
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("#090f1d") # Rich dark cyber navy
	card_style.border_color = Color("#38bdf8") # Radiant cyan border
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(12)
	card_style.shadow_color = Color(0, 0, 0, 0.85)
	card_style.shadow_size = 20
	card_style.content_margin_left = 40
	card_style.content_margin_right = 40
	card_style.content_margin_top = 36
	card_style.content_margin_bottom = 36
	card.add_theme_stylebox_override("panel", card_style)

	# High contrast text for all labels in creator card
	for child in content.get_children():
		if child is Label:
			if child.name == "NewGameTitle":
				child.add_theme_color_override("font_color", Color("#00f0ff")) # Glowing neon cyan
				child.add_theme_font_size_override("font_size", 38)
			elif child == validation_label:
				child.add_theme_color_override("font_color", Color("#f87171")) # Bright warning red
				child.add_theme_font_size_override("font_size", 22)
			else:
				child.add_theme_color_override("font_color", Color("#bae6fd")) # Ice blue for crisp legibility
				child.add_theme_font_size_override("font_size", 24)

	# Input field styling: Dark tech navy with cyan/blue borders
	var field_style := StyleBoxFlat.new()
	field_style.bg_color = Color("#111827")
	field_style.border_color = Color("#2563eb")
	field_style.set_border_width_all(2)
	field_style.set_corner_radius_all(6)
	field_style.content_margin_left = 18
	field_style.content_margin_right = 18

	var field_hover := field_style.duplicate() as StyleBoxFlat
	field_hover.border_color = Color("#38bdf8")

	var field_focus := field_style.duplicate() as StyleBoxFlat
	field_focus.border_color = Color("#00f0ff")
	field_focus.set_border_width_all(3)

	for field in [name_input, birthplace_input, gender_input]:
		field.add_theme_stylebox_override("normal", field_style)
		field.add_theme_stylebox_override("hover", field_hover)
		field.add_theme_stylebox_override("focus", field_focus)
		field.add_theme_color_override("font_color", Color("#ffffff"))
		field.add_theme_color_override("font_hover_color", Color("#ffffff"))
		field.add_theme_font_size_override("font_size", 26)

	name_input.add_theme_color_override("font_placeholder_color", Color("#94a3b8"))

	# Randomize Button: Stylish cyber button
	var rand_style := StyleBoxFlat.new()
	rand_style.bg_color = Color("#1e293b")
	rand_style.border_color = Color("#6366f1")
	rand_style.set_border_width_all(2)
	rand_style.set_corner_radius_all(6)
	var rand_hover := rand_style.duplicate() as StyleBoxFlat
	rand_hover.bg_color = Color("#312e81")
	rand_hover.border_color = Color("#818cf8")
	random_button.add_theme_stylebox_override("normal", rand_style)
	random_button.add_theme_stylebox_override("hover", rand_hover)
	random_button.add_theme_stylebox_override("pressed", rand_style)
	random_button.add_theme_color_override("font_color", Color("#ffffff"))
	random_button.add_theme_color_override("font_hover_color", Color("#c7d2fe"))
	random_button.add_theme_font_size_override("font_size", 24)

	# Country selector popup
	var popup_style := StyleBoxFlat.new()
	popup_style.bg_color = Color("#0f172a")
	popup_style.border_color = Color("#38bdf8")
	popup_style.set_border_width_all(2)
	popup_style.set_corner_radius_all(6)
	popup.add_theme_stylebox_override("panel", popup_style)
	popup.add_theme_color_override("font_color", Color("#f8fafc"))
	popup.add_theme_color_override("font_hover_color", Color("#38bdf8"))
	popup.add_theme_constant_override("h_separation", 16)

	# Start Life Button: High-visibility green
	var start_btn := content.get_node_or_null("StartGameButton") as Button
	if start_btn != null:
		var start_style := StyleBoxFlat.new()
		start_style.bg_color = Color("#22c55e")
		start_style.border_color = Color("#15803d")
		start_style.set_border_width_all(2)
		start_style.set_corner_radius_all(8)
		var start_hover := start_style.duplicate() as StyleBoxFlat
		start_hover.bg_color = Color("#4ade80")
		start_btn.add_theme_stylebox_override("normal", start_style)
		start_btn.add_theme_stylebox_override("hover", start_hover)
		start_btn.add_theme_stylebox_override("pressed", start_style)
		start_btn.add_theme_color_override("font_color", Color("#052e16"))
		start_btn.add_theme_color_override("font_hover_color", Color("#052e16"))
		start_btn.add_theme_font_size_override("font_size", 30)


func _randomize_identity() -> void:
	birthplace_input.select(randi_range(0, birthplace_input.item_count - 1))
	var country := birthplace_input.get_item_text(birthplace_input.selected)
	name_input.text = NameCatalog.random_name(country, gender_input.selected == 1)
	validation_label.text = ""


func _configure_age_art() -> void:
	age_button.text = ""
	age_button.tooltip_text = "Age up one year"
	for state in ["normal", "hover", "pressed", "disabled"]:
		age_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())

	var existing_art := age_button.get_node_or_null("AgeArtwork")
	if existing_art != null:
		existing_art.queue_free()

	var artwork := TextureRect.new()
	artwork.name = "AgeArtwork"
	artwork.texture = load("res://assets/icons/4x/icon_age.png")
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	artwork.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	artwork.pivot_offset = Vector2(115, 115)
	age_button.add_child(artwork)
	artwork.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Additive Age-only splash; the existing artwork tweens stay unchanged.
	if age_button.get_node_or_null("AgePixelBurst") == null:
		var splash := preload("res://scripts/ui/age_pixel_burst.gd").new()
		splash.name = "AgePixelBurst"
		age_button.add_child(splash)

	# Micro-interactions for tactile responsiveness
	if not age_button.mouse_entered.is_connected(_on_age_btn_hover):
		age_button.mouse_entered.connect(_on_age_btn_hover)
	if not age_button.mouse_exited.is_connected(_on_age_btn_exit):
		age_button.mouse_exited.connect(_on_age_btn_exit)
	if not age_button.button_down.is_connected(_on_age_btn_down):
		age_button.button_down.connect(_on_age_btn_down)
	if not age_button.button_up.is_connected(_on_age_btn_up):
		age_button.button_up.connect(_on_age_btn_up)


func _on_age_btn_hover() -> void:
	var art := age_button.get_node_or_null("AgeArtwork") as TextureRect
	if art != null:
		var tween := create_tween()
		tween.tween_property(art, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_age_btn_exit() -> void:
	var art := age_button.get_node_or_null("AgeArtwork") as TextureRect
	if art != null:
		var tween := create_tween()
		tween.tween_property(art, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_age_btn_down() -> void:
	var art := age_button.get_node_or_null("AgeArtwork") as TextureRect
	if art != null:
		var tween := create_tween()
		tween.tween_property(art, "scale", Vector2(0.95, 0.95), 0.06).set_trans(Tween.TRANS_QUAD)


func _on_age_btn_up() -> void:
	var art := age_button.get_node_or_null("AgeArtwork") as TextureRect
	if art != null:
		var tween := create_tween()
		tween.tween_property(art, "scale", Vector2(1.05, 1.05), 0.08).set_trans(Tween.TRANS_QUAD)


func _create_stat_gradient_texture(c1: Color, c2: Color) -> GradientTexture2D:
	var grad := Gradient.new()
	grad.colors = PackedColorArray([c1, c2])
	grad.offsets = PackedFloat32Array([0.0, 1.0])
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.width = 256
	tex.height = 28
	tex.fill = GradientTexture2D.FILL_LINEAR
	tex.fill_from = Vector2(0.0, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	return tex


func _configure_stat_bars() -> void:
	var stats_panel_node := get_node_or_null("SafeArea/MainColumn/StatsPanel") as PanelContainer
	if stats_panel_node != null:
		var stats_box := StyleBoxFlat.new()
		stats_box.bg_color = Color("#080e1c")
		stats_box.border_color = Color("#1e3a5f")
		stats_box.set_border_width_all(2)
		stats_box.set_corner_radius_all(10)
		stats_box.shadow_color = Color(0, 0, 0, 0.6)
		stats_box.shadow_size = 10
		stats_panel_node.add_theme_stylebox_override("panel", stats_box)

	var bars := [
		{"node": health_bar, "label": "Health", "c1": Color("#10b981"), "c2": Color("#047857"), "label_color": Color("#34d399")},
		{"node": happiness_bar, "label": "Happiness", "c1": Color("#f59e0b"), "c2": Color("#b45309"), "label_color": Color("#fbbf24")},
		{"node": smarts_bar, "label": "Smarts", "c1": Color("#0284c7"), "c2": Color("#1e3a8a"), "label_color": Color("#38bdf8")},
		{"node": looks_bar, "label": "Looks", "c1": Color("#db2777"), "c2": Color("#7e22ce"), "label_color": Color("#f472b6")}
	]

	# Track Style: Deep cyber inset casing with clean pixel bevel
	var track_style := StyleBoxFlat.new()
	track_style.bg_color = Color("#060b17")
	track_style.border_color = Color("#1e3a5f")
	track_style.set_border_width_all(2)
	track_style.set_corner_radius_all(4)
	track_style.content_margin_left = 3
	track_style.content_margin_right = 3
	track_style.content_margin_top = 3
	track_style.content_margin_bottom = 3

	for entry in bars:
		var bar: ProgressBar = entry["node"]
		if bar == null:
			continue

		bar.custom_minimum_size.y = 30
		bar.show_percentage = true
		bar.add_theme_font_size_override("font_size", 20)
		bar.add_theme_color_override("font_color", Color("#ffffff"))
		bar.add_theme_color_override("font_outline_color", Color("#000000"))
		bar.add_theme_constant_override("outline_size", 4)
		bar.add_theme_stylebox_override("background", track_style)

		var fill_style := StyleBoxTexture.new()
		fill_style.texture = _create_stat_gradient_texture(entry["c1"], entry["c2"])
		bar.add_theme_stylebox_override("fill", fill_style)

		var label := get_node_or_null("SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/" + entry["label"] + "Label") as Label
		if label != null:
			label.add_theme_color_override("font_color", entry["label_color"])
			label.add_theme_font_size_override("font_size", 22)

	if grades_progress_bar != null:
		grades_progress_bar.custom_minimum_size.y = 26
		grades_progress_bar.show_percentage = true
		grades_progress_bar.add_theme_font_size_override("font_size", 18)
		grades_progress_bar.add_theme_color_override("font_color", Color("#ffffff"))
		grades_progress_bar.add_theme_color_override("font_outline_color", Color("#000000"))
		grades_progress_bar.add_theme_constant_override("outline_size", 4)
		grades_progress_bar.add_theme_stylebox_override("background", track_style)
		var fill_style := StyleBoxTexture.new()
		fill_style.texture = _create_stat_gradient_texture(Color("#10b981"), Color("#047857"))
		grades_progress_bar.add_theme_stylebox_override("fill", fill_style)


func _update_stat_bar_color(bar: ProgressBar, value: int, col_left: Color, col_right: Color) -> void:
	if bar == null:
		return
	var fill := bar.get_theme_stylebox("fill") as StyleBoxTexture
	if fill == null:
		fill = StyleBoxTexture.new()
		bar.add_theme_stylebox_override("fill", fill)

	if value < 25:
		fill.texture = _create_stat_gradient_texture(Color("#ef4444"), Color("#991b1b"))
	else:
		fill.texture = _create_stat_gradient_texture(col_left, col_right)


func _configure_custom_icons() -> void:
	var sheet: Texture2D = load("res://assets/sheets/emojis.jpg")
	if sheet != null:
		var factor := float(sheet.get_width()) / 2048.0
		var regions := {
			"Health": Rect2(185, 590, 178, 151),
			"Happiness": Rect2(184, 189, 180, 177),
			"Smarts": Rect2(1067, 588, 170, 151),
			"Looks": Rect2(1318, 188, 181, 179)
		}
		var cutout_shader := Shader.new()
		cutout_shader.code = "shader_type canvas_item; void fragment(){vec4 c=texture(TEXTURE,UV); bool backing=c.b>c.r*1.13 && c.b>0.07 && c.b<0.46 && c.r<0.29 && c.g<c.b; if(backing){discard;} COLOR=c;}"
		for stat in regions:
			var label := get_node_or_null("SafeArea/MainColumn/StatsPanel/StatsMargin/StatsContainer/" + stat + "Label") as Label
			if label != null:
				label.text = stat.to_upper()
				var icon := TextureRect.new()
				icon.name = stat + "Icon"
				var atlas := AtlasTexture.new()
				atlas.atlas = sheet
				var region: Rect2 = regions[stat]
				atlas.region = Rect2(region.position * factor, region.size * factor)
				atlas.filter_clip = true
				icon.texture = atlas
				icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
				var cutout := ShaderMaterial.new()
				cutout.shader = cutout_shader
				icon.material = cutout
				label.add_child(icon)
				icon.position = Vector2(145, 1)
				icon.size = Vector2(20, 20)


func _configure_portrait() -> void:
	var holder := $ProfileStrip/ProfileMargin/ProfileRow/AvatarButton/Avatar
	portrait = TextureRect.new()
	portrait.name = "Portrait"
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.material = PortraitCatalog.cutout_material()
	holder.add_child(portrait)
	portrait.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait.offset_left = 10
	portrait.offset_right = -10
	portrait.offset_top = 10
	portrait.offset_bottom = -10


func _update_portrait() -> void:
	var stage := PortraitCatalog.stage_index(PlayerData.age)
	var key := "%d/%s/%d" % [stage, PlayerData.gender, PlayerData.portrait_variant]
	if key != portrait_key:
		portrait.texture = PortraitCatalog.texture(PlayerData.age, PlayerData.gender, PlayerData.portrait_variant)
		portrait_key = key
	portrait.tooltip_text = "%s %s" % [PlayerData.get_stage_icon(), PlayerData.get_stage_name()]

func _start_loading_animation() -> void:
	if loading_screen == null or loading_progress_label == null:
		return
	loading_progress_label.text = "0 %"
	var tween := create_tween()
	tween.tween_method(func(val: float) -> void:
		if loading_progress_label != null:
			loading_progress_label.text = "%d %%" % int(val)
	, 0.0, 100.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.2)
	# Silky-smooth cinematic dissolve/fade out transition into main game screen
	tween.set_parallel(true)
	tween.tween_property(loading_screen, "modulate:a", 0.0, 0.65).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(loading_screen, "scale", Vector2(1.03, 1.03), 0.65).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(func() -> void:
		if loading_screen != null:
			loading_screen.visible = false
			loading_screen.scale = Vector2(1.0, 1.0)
	)


# ==========================================
# BUTTON MICRO-INTERACTIONS (Settings & Action Bar)
# ==========================================

func _on_menu_btn_hover() -> void:
	var menu_btn := get_node_or_null("TopBar/Row/MenuButton") as Button
	if menu_btn != null:
		menu_btn.pivot_offset = menu_btn.size / 2.0
		var tween := create_tween().set_parallel(true)
		tween.tween_property(menu_btn, "scale", Vector2(1.16, 1.16), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(menu_btn, "rotation_degrees", menu_btn.rotation_degrees + 90.0, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(menu_btn, "modulate", Color(1.2, 1.3, 1.5, 1.0), 0.2)


func _on_menu_btn_exit() -> void:
	var menu_btn := get_node_or_null("TopBar/Row/MenuButton") as Button
	if menu_btn != null:
		var tween := create_tween().set_parallel(true)
		tween.tween_property(menu_btn, "scale", Vector2(1.0, 1.0), 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(menu_btn, "modulate", Color.WHITE, 0.18)


func _on_menu_btn_down() -> void:
	var menu_btn := get_node_or_null("TopBar/Row/MenuButton") as Button
	if menu_btn != null:
		var tween := create_tween()
		tween.tween_property(menu_btn, "scale", Vector2(0.9, 0.9), 0.06).set_trans(Tween.TRANS_QUAD)


func _on_menu_btn_up() -> void:
	var menu_btn := get_node_or_null("TopBar/Row/MenuButton") as Button
	if menu_btn != null:
		var tween := create_tween()
		tween.tween_property(menu_btn, "scale", Vector2(1.16, 1.16), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_action_bar_btn_hover(btn: Button) -> void:
	if btn == null:
		return
	btn.pivot_offset = btn.size / 2.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "modulate", Color(1.15, 1.25, 1.4, 1.0), 0.12)


func _on_action_bar_btn_exit(btn: Button) -> void:
	if btn == null:
		return
	var tween := create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "modulate", Color.WHITE, 0.12)


func _on_action_bar_btn_down(btn: Button) -> void:
	if btn == null:
		return
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2(0.94, 0.94), 0.06).set_trans(Tween.TRANS_QUAD)


func _on_action_bar_btn_up(btn: Button) -> void:
	if btn == null:
		return
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
