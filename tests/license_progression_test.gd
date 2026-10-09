extends Node


func _ready() -> void:
	# Run in a separate process; never load or write a player's save.
	PlayerData.licenses = []
	PlayerData.age = 18
	PlayerData.money = 0
	PlayerData.bank_savings = 100000
	assert(not LicenseManager.take_license("license_pilot").allowed)
	assert(PlayerData.money == 0 and PlayerData.bank_savings == 100000)
	assert(LicenseManager.take_license("license_boating").allowed)
	assert(PlayerData.has_license("license_boating"))
	assert(not LicenseManager.can_take_license("license_pilot").allowed)
	assert(LicenseManager.take_license("flight_school").allowed)
	assert(PlayerData.money == 0 and PlayerData.bank_savings == 43000)
	assert(not PlayerData.has_license("license_pilot"))
	assert(not LicenseManager.take_license("flight_school").allowed)
	assert(PlayerData.bank_savings == 43000)
	assert(LicenseManager.take_license("license_pilot").allowed)
	assert(PlayerData.bank_savings == 8000)
	assert(not LicenseManager.take_license("license_pilot").allowed)
	PlayerData.licenses = []
	PlayerData.age = 17
	assert(not LicenseManager.can_take_license("flight_school").allowed)
	assert(not LicenseManager.can_take_license("license_boating").allowed)
	PlayerData.age = 18
	PlayerData.bank_savings = 0
	assert(not LicenseManager.take_license("flight_school").allowed)
	assert(not PlayerData.has_license("flight_school"))
	print("LICENSE_PROGRESSION_TEST_PASSED")
	get_tree().quit()
