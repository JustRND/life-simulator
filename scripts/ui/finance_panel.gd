extends Node

var main: Control
var overlay: Control
var selected_tab := "Exchange"
var message := ""


func install(screen: Control) -> void:
	main = screen
	var list := main.get_node("ActivitiesPanel/ActMargin/ActContent/ActScroll/ActList")
	var jobs := list.get_node("JobsActItem")
	var button: Button = jobs.duplicate(0)
	button.name = "FinanceMarketItem"
	button.text = "📈  Finance Market"
	list.add_child(button)
	list.move_child(button, jobs.get_index() + 1)
	button.pressed.connect(open)
	var learning: Button = jobs.duplicate(0)
	learning.name = "LearningItem"
	learning.text = "📚  Learning & Smarts"
	list.add_child(learning)
	learning.pressed.connect(open_learning)
	FinanceMarket.ensure.call_deferred(PlayerData)


func label(parent: Node, text: String, size: int = 24) -> Label:
	var node := Label.new()
	node.text = text
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", Color("#aee4f5"))
	parent.add_child(node)
	return node


func button(parent: Node, text: String, action: Callable, disabled: bool = false) -> Button:
	var node: Button = main._create_cyber_button(text, Color("#06b6d4"), action)
	node.disabled = disabled
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(node)
	return node


func open() -> void:
	FinanceMarket.ensure(PlayerData)
	if is_instance_valid(overlay):
		overlay.queue_free()
	var modal: Dictionary = main._create_cyber_modal(GameLocale.translate("FINANCE MARKET"), GameLocale.translate("Prices update when you age up. NPC trading and business results move the market. Trading fee: 1%."), Color("#06b6d4"))
	overlay = modal.overlay
	var list: VBoxContainer = modal.list
	label(list, GameLocale.translate("Cash: %s • Portfolio: %s") % [GameLocale.money(PlayerData.money), GameLocale.money(FinanceMarket.portfolio_value(PlayerData))])
	if PlayerData.age < 18 or PlayerData.is_in_prison or PlayerData.is_dead:
		label(list, GameLocale.translate("Trading and acquisitions require age 18 and freedom from prison."))
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 10)
	list.add_child(tabs)
	for tab in ["Exchange", "Portfolio", "My Businesses"]:
		var b := button(tabs, GameLocale.translate(tab), func(): selected_tab = tab; message = ""; open())
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_size_override("font_size", 22)
	if not message.is_empty():
		label(list, GameLocale.translate(message))
	match selected_tab:
		"Exchange": _exchange(list)
		"Portfolio": _portfolio(list)
		"My Businesses": _businesses(list)


func _perform(result: String) -> void:
	message = result
	main.update_ui()
	SaveManager.save_game()
	open()


func _exchange(list: VBoxContainer) -> void:
	label(list, GameLocale.translate("8 active listings • 24 company archetypes • NPC-owned businesses can close and reopen."))
	label(list, GameLocale.translate("Acquisitions need no license. Price includes a 25% control premium; shares you already own reduce the cost. Delisting returns 80% of share value; bankruptcy returns zero."), 21)
	for c in FinanceMarket.active(PlayerData):
		var card := VBoxContainer.new()
		card.add_theme_constant_override("separation", 10)
		list.add_child(card)
		label(card, str(c.name), 29)
		var change := (float(c.price) / maxf(0.01, float(c.previous)) - 1.0) * 100.0
		label(card, GameLocale.translate("Owner: %s • Price: %s (%+.1f%%)") % [c.owner, GameLocale.money(c.price), change])
		label(card, GameLocale.translate("NPC buys: %d • NPC sells: %d • Shares available: %d") % [int(c.npc_buys), int(c.npc_sells), int(c.available)], 21)
		if not str(c.business_uid).is_empty():
			label(card, GameLocale.translate("Your public company • 80% controlling stake"))
			continue
		var quantity := SpinBox.new()
		quantity.min_value = 1
		quantity.max_value = 10000
		quantity.value = 10
		quantity.step = 1
		quantity.custom_minimum_size.y = 60
		card.add_child(quantity)
		var row := HBoxContainer.new()
		card.add_child(row)
		button(row, GameLocale.translate("Buy Shares"), func(): _perform(FinanceMarket.trade(PlayerData, c.uid, int(quantity.value), true)))
		button(row, GameLocale.translate("Sell Shares"), func(): _perform(FinanceMarket.trade(PlayerData, c.uid, int(quantity.value), false)))
		button(card, GameLocale.translate("Acquire Business • %s") % GameLocale.money(FinanceMarket.acquisition_price(PlayerData, c)), func():
			main.get_node("OptionsMenu").confirm(GameLocale.translate("ACQUIRE BUSINESS"), GameLocale.translate("Acquire %s for %s from cash and savings? No license is required.") % [c.name, GameLocale.money(FinanceMarket.acquisition_price(PlayerData, c))], func(): _perform(FinanceMarket.acquire(PlayerData, c.uid)))
		)
	for news in PlayerData.finance_market.news:
		label(list, str(news), 21)


func _portfolio(list: VBoxContainer) -> void:
	label(list, GameLocale.translate("Blue: portfolio value • Gold: net cash invested"))
	var chart := preload("res://scripts/ui/portfolio_chart.gd").new()
	chart.history = PlayerData.finance_market.history
	list.add_child(chart)
	label(list, GameLocale.translate("Realized profit / loss: %s") % GameLocale.money(int(PlayerData.finance_market.realized)))
	if PlayerData.finance_market.holdings.is_empty():
		label(list, GameLocale.translate("No shares owned. Buy shares in the Exchange tab."))
	for uid in PlayerData.finance_market.holdings:
		var position: Dictionary = PlayerData.finance_market.holdings[uid]
		var company := FinanceMarket.issuer(PlayerData, uid)
		var value := int(position.quantity) * float(company.price)
		label(list, "%s • %d\n%s / %s • %s" % [company.name, position.quantity, GameLocale.money(value), GameLocale.money(position.cost), GameLocale.money(value - int(position.cost))])
		button(list, GameLocale.translate("Sell All"), func(): _perform(FinanceMarket.trade(PlayerData, uid, mini(10000, int(position.quantity)), false)))


func _businesses(list: VBoxContainer) -> void:
	label(list, GameLocale.translate("IPO: exceed $1,000,000 cumulative after-tax net profit, pay outstanding business taxes, and maintain a non-negative treasury. Float 20%; retain 80%. Underwriting fee: 5%."))
	if PlayerData.owned_businesses.is_empty():
		label(list, GameLocale.translate("No businesses owned. Acquire an NPC business or incorporate one."))
	for business in PlayerData.owned_businesses:
		label(list, str(business.name), 28)
		label(list, GameLocale.translate("Net profit to date: %s • Valuation: %s • Ownership: %d%%") % [GameLocale.money(int(business.get("cumulative_net_profit", 0))), GameLocale.money(int(business.get("valuation", 0))), int(float(business.get("owner_fraction", 1.0)) * 100)])
		button(list, GameLocale.translate("Request IPO"), func():
			main.get_node("OptionsMenu").confirm(GameLocale.translate("Request IPO"), GameLocale.translate("Sell 20% of this company to the public market? Proceeds enter the business treasury."), func(): _perform(FinanceMarket.request_ipo(PlayerData, business)))
		, business.has("listing_uid"))
		button(list, GameLocale.translate("Manage Business"), func(): main._show_business_modal("financials", business.uid))
		button(list, GameLocale.translate("Resell Business"), func():
			main.get_node("OptionsMenu").confirm(GameLocale.translate("Resell Business"), GameLocale.translate("Sell your ownership stake? Proceeds deduct debt and unpaid taxes."), func():
				var result := BusinessManager.liquidate_business(business.uid)
				_perform(str(result.message))
			)
		)


func open_learning() -> void:
	var view: Dictionary = main._create_cyber_modal(GameLocale.translate("LEARNING & SMARTS"), GameLocale.translate("Each activity is available once per year. Any activity protects smarts from annual decay. Gains taper above 85 smarts."), Color("#38bdf8"))
	for activity in BalanceRules.LEARNING:
		var used := int(PlayerData.learning_activities.get(activity.id, -1)) == PlayerData.age
		button(view.list, GameLocale.translate(activity.name) + "\n" + GameLocale.translate("Cost: %s • Smarts +%d • Age %d+") % [GameLocale.money(activity.cost), int(activity.smarts) if PlayerData.smarts < 85 else maxi(1, int(activity.smarts) / 2), activity.age], func():
			var result := BalanceRules.learn(PlayerData, activity.id)
			main.update_ui()
			SaveManager.save_game()
			view.overlay.queue_free()
			open_learning()
			message = result
		, used or PlayerData.age < int(activity.age) or PlayerData.money < int(activity.cost) or PlayerData.is_in_prison or PlayerData.is_dead)
