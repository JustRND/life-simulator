extends SceneTree

func _init() -> void:
	var icons = {
		"health": '<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 64 64"><path d="M32 54 C30 52 10 36 10 22 C10 14 16 8 24 8 C28.5 8 31 10.5 32 12 C33 10.5 35.5 8 40 8 C48 8 54 14 54 22 C54 36 34 52 32 54 Z" fill="#10b981"/></svg>',
		"happiness": '<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 64 64"><circle cx="32" cy="32" r="26" fill="#f59e0b"/><path d="M20 36 Q32 52 44 36" fill="none" stroke="#1c1917" stroke-width="5" stroke-linecap="round"/><circle cx="23" cy="24" r="3.5" fill="#1c1917"/><circle cx="41" cy="24" r="3.5" fill="#1c1917"/></svg>',
		"smarts": '<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 64 64"><path d="M32 6 A18 18 0 0 0 17 27 C17 33 21 37 23 41 L41 41 C43 37 47 33 47 27 A18 18 0 0 0 32 6 Z" fill="#0284c7"/><path d="M24 47 H40 M26 53 H38" fill="none" stroke="#0284c7" stroke-width="4.5" stroke-linecap="round"/><path d="M32 18 V28 M27 23 H37" fill="none" stroke="white" stroke-width="3" stroke-linecap="round"/></svg>',
		"looks": '<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 64 64"><path d="M32 4 Q32 32 60 32 Q32 32 32 60 Q32 32 4 32 Q32 32 32 4 Z" fill="#db2777"/><circle cx="50" cy="14" r="4.5" fill="#db2777"/><circle cx="14" cy="50" r="3.5" fill="#db2777"/></svg>'
	}
	
	var canvas := Image.create(400, 200, false, Image.FORMAT_RGBA8)
	# Top half: light mode
	for y in range(100):
		for x in range(400):
			canvas.set_pixel(x, y, Color("#edf3fa"))
	# Bottom half: dark mode
	for y in range(100, 200):
		for x in range(400):
			canvas.set_pixel(x, y, Color("#080e1c"))
	
	var idx = 0
	for k in ["health", "happiness", "smarts", "looks"]:
		var img := Image.new()
		img.load_svg_from_string(icons[k])
		img.resize(64, 64)
		# Light mode blit
		canvas.blit_rect_mask(img, img, Rect2i(0, 0, 64, 64), Vector2i(20 + idx * 95, 18))
		# Dark mode blit
		canvas.blit_rect_mask(img, img, Rect2i(0, 0, 64, 64), Vector2i(20 + idx * 95, 118))
		idx += 1
		
	canvas.save_png("res://work/preview_modern_stats_both.png")
	print("Saved work/preview_modern_stats_both.png")
	quit()
