extends Node

const MainScreenScene = preload("res://scenes/main/main_screen.tscn")
const ReferenceRowScript = preload("res://scripts/ui/reference_row.gd")

func _ready() -> void:
	print("========================================")
	print("--- LIFE SIMULATOR PERFORMANCE BENCHMARK ---")
	print("========================================")
	
	# Wait for engine initialization
	await get_tree().process_frame
	await get_tree().process_frame

	var screen = MainScreenScene.instantiate()
	add_child(screen)
	await get_tree().process_frame

	# 1. Measure Total Active Node Count
	var initial_nodes := _count_nodes(screen)
	print("1. Active Scene Node Count: %d nodes" % initial_nodes)

	# 2. Benchmark Stat Bar Gradient & update_ui() cost
	# Measure 500 calls to update_ui()
	var t0 := Time.get_ticks_usec()
	for i in range(500):
		screen.update_ui()
	var update_ui_total_us := Time.get_ticks_usec() - t0
	var update_ui_avg_us := float(update_ui_total_us) / 500.0
	print("2. update_ui() Cost (500 iterations):")
	print("   Total Time: %.2f ms (Avg: %.3f ms / call)" % [update_ui_total_us / 1000.0, update_ui_avg_us / 1000.0])

	# 3. Benchmark History Panel Rendering with 100 events
	PlayerData.life_log.clear()
	for i in range(100):
		PlayerData.life_log.append({
			"age": int(i / 2),
			"text": "Event #%d: Participated in significant life experience and progressed career." % i,
			"kind": "milestone" if i % 4 == 0 else "event"
		})
	
	t0 = Time.get_ticks_usec()
	screen.overview_history_filter = "all"
	screen.update_history_panel()
	var history_render_us := Time.get_ticks_usec() - t0
	var history_node_count := _count_nodes(screen.history_list)
	print("3. History Panel Rendering (100 events):")
	print("   Render Time: %.2f ms" % [history_render_us / 1000.0])
	print("   History Nodes Created: %d nodes" % history_node_count)

	# 4. Benchmark SaveManager.save_game() cost
	t0 = Time.get_ticks_usec()
	for i in range(20):
		SaveManager.save_game("user://benchmark_save.json")
	var save_total_us := Time.get_ticks_usec() - t0
	var save_avg_ms := (float(save_total_us) / 20.0) / 1000.0
	print("4. SaveManager.save_game() Cost (20 synchronous writes):")
	print("   Total Time: %.2f ms (Avg: %.2f ms / save)" % [save_total_us / 1000.0, save_avg_ms])

	# Clean up benchmark file
	DirAccess.remove_absolute("user://benchmark_save.json")
	DirAccess.remove_absolute("user://benchmark_save.json.tmp")

	# 5. Measure ReferenceRow _process cost across 50 buttons
	var dummy_buttons: Array[Button] = []
	var dummy_container := VBoxContainer.new()
	add_child(dummy_container)
	for i in range(50):
		var btn := Button.new()
		btn.text = "Sample Button #%d" % i
		dummy_container.add_child(btn)
		var ref_row = ReferenceRowScript.new()
		btn.add_child(ref_row)
		ref_row.setup(btn)
		dummy_buttons.append(btn)

	await get_tree().process_frame
	await get_tree().process_frame

	t0 = Time.get_ticks_usec()
	# Simulate 120 frames of _process across 50 buttons (1 second at 120fps)
	for frame in range(120):
		for btn in dummy_buttons:
			for child in btn.get_children():
				if child.has_method("_process"):
					child._process(0.016)
	var ref_row_process_us := Time.get_ticks_usec() - t0
	print("5. ReferenceRow _process() Cost (50 buttons across 120 frames):")
	print("   Total Time: %.2f ms (Avg: %.3f ms / frame)" % [ref_row_process_us / 1000.0, (ref_row_process_us / 120.0) / 1000.0])

	# 6. Memory Usage
	var mem_static_mb := float(OS.get_static_memory_usage()) / (1024.0 * 1024.0)
	print("6. Memory Usage:")
	print("   Static Memory: %.2f MB" % mem_static_mb)

	print("========================================")
	print("--- BENCHMARK COMPLETE ---")
	print("========================================")
	
	screen.queue_free()
	dummy_container.queue_free()
	get_tree().quit(0)

func _count_nodes(node: Node) -> int:
	if node == null:
		return 0
	var count := 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count
