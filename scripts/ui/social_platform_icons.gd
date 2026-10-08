extends RefCounted
static var cache: Dictionary = {}
const MARKS = {
	"youtube": '<rect x="3" y="12" width="58" height="40" rx="12" fill="#ff0033"/><path d="m26 22 18 10-18 10Z" fill="white"/>',
	"instagram": '<defs><linearGradient id="i" x2="1" y2="1"><stop stop-color="#8134af"/><stop offset=".5" stop-color="#dd2a7b"/><stop offset="1" stop-color="#feda77"/></linearGradient></defs><rect x="3" y="3" width="58" height="58" rx="16" fill="url(#i)"/><g fill="none" stroke="white" stroke-width="4"><rect x="15" y="15" width="34" height="34" rx="10"/><circle cx="32" cy="32" r="8"/></g><circle cx="43" cy="21" r="2.5" fill="white"/>',
	"twitch": '<rect x="3" y="3" width="58" height="58" rx="14" fill="#9146ff"/><path d="M15 13h37v27L41 51H30l-8 7v-7h-7Zm6 5v26h10l-5 5 10-5h5l6-7V18Z" fill="white"/><path d="M31 25v12m10-12v12" stroke="white" stroke-width="4"/>',
	"x": '<rect x="3" y="3" width="58" height="58" rx="14" fill="#101010"/><path d="M16 15h9l24 34h-9ZM46 15 18 49" fill="none" stroke="white" stroke-width="3"/>',
	"tiktok": '<rect x="3" y="3" width="58" height="58" rx="14" fill="#101010"/><path d="M37 14v29a9 9 0 1 1-8-9m8-20q0 12 13 12" fill="none" stroke="#25f4ee" stroke-width="7"/><path d="M39 12v29a9 9 0 1 1-8-9m8-20q0 12 13 12" fill="none" stroke="#fe2c55" stroke-width="5"/><path d="M38 13v29a9 9 0 1 1-8-9m8-20q0 12 13 12" fill="none" stroke="white" stroke-width="4"/>',
}

static func icon(platform: String) -> Texture2D:
	if not cache.has(platform):
		var image := Image.new()
		image.load_svg_from_string('<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 64 64">' + str(MARKS.get(platform, "")) + '</svg>')
		cache[platform] = ImageTexture.create_from_image(image)
	return cache[platform]
