# Supplied artwork

- characters.jpg: profile portraits now use two persistent appearance tracks across baby (0–2), child (3–12), teen (13–19), adult (20–64), and elder (65+) stages. Babies share a pool; later stages have separate Male/Female pools. The original sheet remains unchanged. Runtime edge-connected background removal and silhouette filtering remove its backing without a rectangular frame.
- ui_icons.png: original UI sheet. Only its Age artwork is currently connected.
- flags.jpg: original flag sheet. CreationOptions maps 25 recognizable country flags to measured, border-free atlas regions; duplicates and ambiguous designs are excluded.
- emojis.jpg: supplied emoji sheet. Health uses its heart, Happiness its smiling face, Smarts its sparkles, and Looks its sunglasses face. A material masks the blue-gray sheet background while preserving black outlines.

The three original navigation badges in assets/ui are editable pixel-grid SVGs.
Country-specific random names are defined in scripts/core/name_catalog.gd.

Original source images are preserved. No artwork was generated through Google Flow.
The Age button uses a nearest-filtered atlas region with a circular mask. Other UI
and character icons remain unused assets until their gameplay is implemented.

The temporary background pattern is drawn by scripts/core/pixel_background.gd.
The full UI redesign awaits the next mockup.
