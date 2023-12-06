extends Area2D

const NUMBER_GRID = [
	[3, 6, 9, 12, 15, 18, 21, 24, 24, 27, 30, 33, 36],
	[2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35],
	[1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
]

@onready
var individual_numbers = get_node("IndividualNumbers")
@onready
var two_to_one = get_node("TwoToOne")
@onready
var ordered_thirds = get_node("Thirds")
@onready
var halves_variants = get_node("HalvesVariants")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func individual_number_clicked(viewport, event):
	var local_click_pos = individual_numbers.to_local(event.position)
	if is_in_range(local_click_pos, individual_numbers):
		return determine_individual_number(local_click_pos, individual_numbers.shape.extents)
			
func two_to_one_clicked(viewport, event):
	var local_click_pos = two_to_one.to_local(event.position)
	if is_in_range(local_click_pos, two_to_one):
		return determine_row_set(local_click_pos, two_to_one.shape.extents)

func thirds_clicked(viewport, event):
	var local_click_pos = ordered_thirds.to_local(event.position)
	if is_in_range(local_click_pos, ordered_thirds):
		return determine_thirds(local_click_pos, ordered_thirds.shape.extents)

func halves_variants_clicked(viewport, event):
	var local_click_pos = halves_variants.to_local(event.position)
	if is_in_range(local_click_pos, halves_variants):
		return determine_halves_variants(local_click_pos, halves_variants.shape.extents)

func is_in_range(click_position, portion):
	if portion.shape is RectangleShape2D:
		var extents = portion.shape.extents
		# Check if the click is within the bounds of the rectangle
		if click_position.x > -extents.x && click_position.x < extents.x && click_position.y > -extents.y && click_position.y < extents.y:
			return true

func determine_individual_number(click_pos, extents):
	var column_count = 12
	return {"row": get_row_set(click_pos, extents), "column": get_column_set(click_pos, extents, column_count)}
	
func determine_row_set(click_pos, extents):
	return get_row_set(click_pos, extents)

func determine_thirds(click_pos, extents):
	var column_count = 3
	return get_column_set(click_pos, extents, column_count)
	
func determine_halves_variants(click_pos, extents):
	var column_count = 6
	return get_column_set(click_pos, extents, column_count)
	
func get_row_set(click_pos, extents):
	var num_rows = 3
	var cell_height = extents.y * 2 / num_rows
	return floor((click_pos.y + extents.y) / cell_height)
	
func get_column_set(click_pos, extents, num_columns):
	var cell_width = extents.x * 2 / num_columns
	return floor((click_pos.x + extents.x) / cell_width)
				
