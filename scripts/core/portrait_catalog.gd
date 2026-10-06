extends RefCounted

# Game presentation ranges: Infant / Toddler, Child, Teenager, Adult, Elder
const STAGES = ["Infant / Toddler", "Child", "Teenager", "Adult", "Elder"]
static var textures: Dictionary = {}
# Two coordinated appearance tracks. Coordinates are [column, row].
# Baby is shared; teen portraits are assigned to separate game gender pools.
const BABIES = [Vector2i(0, 0), Vector2i(2, 0)]
const MALE = [
	[Vector2i(0, 2), Vector2i(2, 3)],
	[Vector2i(9, 6), Vector2i(9, 7)],
	[Vector2i(0, 8), Vector2i(2, 9)],
	[Vector2i(0, 14), Vector2i(7, 15)]
]
const FEMALE = [
	[Vector2i(0, 4), Vector2i(7, 4)],
	[Vector2i(10, 7), Vector2i(11, 7)],
	[Vector2i(0, 10), Vector2i(3, 10)],
	[Vector2i(0, 12), Vector2i(1, 12)]
]

static func stage_index(age: int) -> int:
	if age < 5:
		return 0 # Infant & Toddler (Ages 0-4)
	if age < 13:
		return 1 # Child (Ages 5-12)
	if age < 20:
		return 2 # Teenager (Ages 13-19)
	if age < 65:
		return 3 # Adult (Ages 20-64)
	return 4     # Elder (Ages 65+)

static func cell(age: int, gender: String, variant: int) -> Vector2i:
	var track := posmod(variant, BABIES.size())
	var stage := stage_index(age)
	if stage == 0:
		return BABIES[track]
	return (FEMALE if gender == "FEMALE" else MALE)[stage - 1][track]

static func texture(age: int, gender: String, variant: int) -> Texture2D:
	var sheet: Texture2D = load("res://assets/sheets/characters.jpg")
	var tile := cell(age, gender, variant)
	if textures.has(tile):
		return textures[tile]
	var factor := float(sheet.get_width()) / 1600.0
	var region := Rect2i(int((60.0 + tile.x * 93.6) * factor), int((2.0 + tile.y * 100.0) * factor), int(90.0 * factor), int(94.0 * factor))
	var pixels := sheet.get_image().get_region(region)
	pixels.convert(Image.FORMAT_RGBA8)
	var width := pixels.get_width()
	var height := pixels.get_height()
	var removed := PackedByteArray()
	removed.resize(width * height)
	var queue: Array[Vector2i] = []
	for x in range(width):
		queue.append(Vector2i(x, 0))
		queue.append(Vector2i(x, height - 1))
	for y in range(height):
		queue.append(Vector2i(0, y))
		queue.append(Vector2i(width - 1, y))
	var cursor := 0
	# Only remove backing connected to the edge: gray hair inside the silhouette stays.
	while cursor < queue.size():
		var point := queue[cursor]
		cursor += 1
		if point.x < 0 or point.y < 0 or point.x >= width or point.y >= height:
			continue
		var index := point.y * width + point.x
		if removed[index]:
			continue
		var color := pixels.get_pixelv(point)
		var high := maxf(color.r, maxf(color.g, color.b))
		var low := minf(color.r, minf(color.g, color.b))
		var backing := (color.b > color.r * 1.015 and color.b > 0.055 and color.b < 0.42 and color.g >= color.r * 0.97) or (high - low < 0.025 and high > 0.08 and high < 0.32)
		if not backing:
			continue
		removed[index] = 1
		for step in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			queue.append(point + step)
	# Keep the largest remaining connected silhouette; discard isolated JPEG speckles.
	var visited := PackedByteArray()
	visited.resize(width * height)
	var largest: Array[int] = []
	for start in range(width * height):
		if removed[start] or visited[start]:
			continue
		var component: Array[int] = [start]
		visited[start] = 1
		cursor = 0
		while cursor < component.size():
			var index := component[cursor]
			cursor += 1
			var point := Vector2i(index % width, floori(float(index) / width))
			for step in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
				var neighbor: Vector2i = point + step
				if neighbor.x < 0 or neighbor.y < 0 or neighbor.x >= width or neighbor.y >= height:
					continue
				var next := neighbor.y * width + neighbor.x
				if not removed[next] and not visited[next]:
					visited[next] = 1
					component.append(next)
		if component.size() > largest.size():
			largest = component
	var keep := PackedByteArray()
	keep.resize(width * height)
	for index in largest:
		keep[index] = 1
	for index in range(width * height):
		if not keep[index]:
			pixels.set_pixel(index % width, floori(float(index) / width), Color.TRANSPARENT)
	var result := ImageTexture.create_from_image(pixels)
	textures[tile] = result
	return result

static func cutout_material() -> ShaderMaterial:
	var shader := Shader.new()
	# Mask charcoal sheet backing while retaining the portrait's dark outlines.
	shader.code = "shader_type canvas_item; void fragment(){COLOR=texture(TEXTURE,UV);}"
	var result := ShaderMaterial.new()
	result.shader = shader
	return result
