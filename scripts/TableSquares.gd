extends Area2D

## Roulette Table Squares and Interaction Depiction.
##
## This script manages interactions of clicks on the table sprite. Without the
## use of buttons, it determines portions of the sprite interacted with for the
## game operations they are associated with respectively.
##
## Author: Nathan Vincent
## Date: 12/8/2023

@onready
var individual_numbers = get_node("IndividualNumbers")
@onready
var two_to_one = get_node("TwoToOne")
@onready
var ordered_thirds = get_node("Thirds")
@onready
var halves_variants = get_node("HalvesVariants")
@onready
var table = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called when user interacts with table sprite and determines section clicked
func _input_event(viewport, event, shape_idx):
	if table.allow_bets and event is InputEventMouseButton and event.pressed:
		if table.get_user_chip_count() >= table.individual_chip_value:
			table.deduct_individual_chip_value()
			var assignment_key
			# Matches section on table with specific functions to find what was clicked
			match shape_idx:
				table.INDIVIDUAL_NUMBERS_INDEX:
					var area = _individual_number_clicked(viewport, event)
					assignment_key = table.NUMBER_GRID[area.row][area.column]
				table.TWO_TO_ONE_INDEX:
					var row = _two_to_one_clicked(viewport, event)
					assignment_key = row
				table.THIRDS_INDEX:
					var column = _thirds_clicked(viewport, event)
					assignment_key = column
				table.HALVES_VARIANTS_INDEX:
					var column = _halves_variants_clicked(viewport, event)
					assignment_key = column
				table.SINGLE_ZERO_INDEX:
					assignment_key = 0
				table.DOUBLE_ZERO_INDEX:
					assignment_key = 37
			table.place_bets(shape_idx, assignment_key)

# Finds individual number square clicked, not inclusive of green numbers
func _individual_number_clicked(viewport, event):
	var local_click_position = individual_numbers.to_local(event.position)
	if _is_in_range(local_click_position, individual_numbers):
		return _determine_individual_number(local_click_position, individual_numbers.shape.extents)
			
# Finds which of the three two to one sections were selected
func _two_to_one_clicked(viewport, event):
	var local_click_position = two_to_one.to_local(event.position)
	if _is_in_range(local_click_position, two_to_one):
		return _determine_row_set(local_click_position, two_to_one.shape.extents)

# Finds which of the three sections for number ranges were selected
func _thirds_clicked(viewport, event):
	var local_click_position = ordered_thirds.to_local(event.position)
	if _is_in_range(local_click_position, ordered_thirds):
		return _determine_thirds(local_click_position, ordered_thirds.shape.extents)

# Finds which of the six sections for 50% odds were selected
func _halves_variants_clicked(viewport, event):
	var local_click_position = halves_variants.to_local(event.position)
	if _is_in_range(local_click_position, halves_variants):
		return _determine_halves_variants(local_click_position, halves_variants.shape.extents)

# Confirms if clicked positions is within bounds for category of bets
func _is_in_range(click_position, portion):
	if portion.shape is RectangleShape2D:
		var extents = portion.shape.extents
		# Check if the click is within the bounds of the rectangle
		if click_position.x > -extents.x && click_position.x < extents.x && click_position.y > -extents.y && click_position.y < extents.y:
			return true

# Finds what individual number by row and column
func _determine_individual_number(click_position, extents):
	return {"row": _get_row_set(click_position, extents), "column": _get_column_set(click_position, extents, 12)}

# Determines the makeup of rows for all bet types that apply
func _determine_row_set(click_position, extents):
	return _get_row_set(click_position, extents)

# Determines the makeup of columns for the three bets among the second to last row of betting types
func _determine_thirds(click_position, extents):
	return _get_column_set(click_position, extents, 3)

# Determines the makeup of columns for the six bets among the last row of betting types
func _determine_halves_variants(click_position, extents):
	return _get_column_set(click_position, extents, 6)

# Provides the dimensions of rows
func _get_row_set(click_position, extents):
	var cell_height = extents.y * 2 / 3
	return floor((click_position.y + extents.y) / cell_height)

# Provides the dimensions of columns
func _get_column_set(click_position, extents, column_count):
	var cell_width = extents.x * 2 / column_count
	return floor((click_position.x + extents.x) / cell_width)
				
