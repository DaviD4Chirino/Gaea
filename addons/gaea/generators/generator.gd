@tool
@icon("generator.svg")
class_name GaeaGenerator
extends Node
## Base class for the Gaea addon's procedural generator.
## @tutorial(Generators): https://benjatk.github.io/Gaea/#/generators/


## Emitted when any changes to the [param grid] are made.
signal grid_updated
## Emitted when [method generate] successfully starts.
signal generation_started
## Emitted when [method generate] successfully finished.
signal generation_finished


## If [code]true[/code], allows for generating a preview of the generation
## in the editor. Useful for debugging.
@export var editor_preview: bool = false :
	set(value):
		editor_preview = value
		if value == false:
			erase()
## If [code]true[/code] regenerates on [code]_ready()[/code].
## If [code]false[/code] and a world was generated in the editor,
## it will be kept.
@export var generate_on_ready: bool = true

var grid : GaeaGrid : get = get_grid


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# Wait for a process frame, so the Renderer can connect the signals.
	await get_tree().process_frame

	if generate_on_ready:
		generate()


func generate(starting_grid: GaeaGrid = null) -> void:
	push_warning("generate method at %s not overriden" % name)


func erase() -> void:
	if grid != null:
		grid.clear()
		grid_updated.emit()


func get_grid() -> GaeaGrid:
	return grid

### Modifiers ###


func _apply_modifiers(modifiers) -> void:
	for modifier in modifiers:
		if not (modifier is Modifier):
			continue

		modifier.apply(grid, self)
