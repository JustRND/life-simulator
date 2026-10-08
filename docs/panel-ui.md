# Shared panel presentation

Panels use the same layout in dark and light mode: a black centered header with a circular close control, gray category strips, full-width rows, large leading icons, bold titles, secondary descriptions and trailing chevrons. Text wraps instead of shrinking; long lists remain scrollable.

`scripts/ui/reference_theme.gd` is applied by ThemeController to panel descendants, including dynamically created activity pages. `scripts/ui/reference_row.gd` presents existing vertical-list buttons without replacing their signals, text, disabled state or toggle state. Existing image icons take precedence over symbol fallbacks. Compact horizontal controls, forms, charts and gameplay data retain their interaction structure.

The palette uses separate primary, secondary and disabled text colors for each background. The row renderer keeps the original button text available to localization and updates when prices, labels or selection change. New descriptions and category labels include English, Indonesian and Russian translations.

Run `res://tests/reference_ui_test.tscn` to exercise both themes, main menus, nested activity screens, wrapping, disabled rows, modal close behavior, Russian labels and a minimum 4.5:1 text contrast ratio for the shared row palette. Screenshots are written to the ignored `work/` directory. The test uses a separate local profile and does not save life progression.
