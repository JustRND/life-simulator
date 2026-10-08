extends Node

# Tiny rounded synth taps: no sharp square waves, long tails, or hover noise.
const SAMPLE_RATE := 44100
const VOLUME_DB := -12.0
var _tap: AudioStreamPlayer
var _age: AudioStreamPlayer
var _last_press_ms: int = -1000

func _ready() -> void:
	pass

func _make_player(player_name: String, sound: AudioStreamWAV) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.name = player_name
	player.stream = sound
	player.volume_db = VOLUME_DB
	player.max_polyphony = 2
	add_child(player)
	return player

func _watch_tree(node: Node) -> void:
	_wire_button(node)
	for child in node.get_children():
		_watch_tree(child)

func _on_node_added(node: Node) -> void:
	_wire_button.call_deferred(node)

func _wire_button(node: Node) -> void:
	if not is_instance_valid(node) or not get_parent().is_ancestor_of(node):
		return
	if node is BaseButton:
		var callback := _on_button_down.bind(node)
		if not node.button_down.is_connected(callback):
			node.button_down.connect(callback)
	if node is OptionButton:
		var callback := _on_option_selected.bind(node)
		if not node.item_selected.is_connected(callback):
			node.item_selected.connect(callback)

func _on_button_down(button: BaseButton) -> void:
	if button.disabled or not button.is_visible_in_tree():
		return
	_play(button.name == "AgeButton")

func _on_option_selected(_index: int, button: OptionButton) -> void:
	if not button.disabled and button.is_visible_in_tree():
		_play(false)

func _play(is_age: bool) -> void:
	var now := Time.get_ticks_msec()
	if now - _last_press_ms < 35:
		return
	_last_press_ms = now
	if is_age:
		_age.play()
	else:
		_tap.play()

static func _synthesize(is_age: bool) -> AudioStreamWAV:
	var duration := 0.135 if is_age else 0.085
	var frames := int(duration * SAMPLE_RATE)
	var bytes := PackedByteArray()
	bytes.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7319 if is_age else 1049
	var noise := 0.0
	for index in range(frames):
		var t := float(index) / SAMPLE_RATE
		var attack := smoothstep(0.0, 0.004, t)
		var release := 1.0 - smoothstep(duration * 0.65, duration, t)
		var decay := exp(-t * (32.0 if is_age else 55.0))
		# A descending soft pluck with a faint, low-passed fingertip texture.
		var frequency := 520.0 if is_age else 720.0
		var phase := TAU * (frequency * t - 600.0 * t * t)
		noise = lerpf(noise, rng.randf_range(-1.0, 1.0), 0.14)
		var tone := sin(phase) * 0.70 + sin(phase * 2.0) * 0.12
		if is_age:
			tone += sin(TAU * 780.0 * t) * 0.12 * exp(-t * 18.0)
		var sample := (tone + noise * 0.13) * attack * decay * release * 0.35
		bytes.encode_s16(index * 2, int(clampf(sample, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = bytes
	return stream
