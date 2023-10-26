extends Sprite2D

const table_numbers = [
	0,
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
	13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
	25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
	37
	]

const red_numbers = [
	1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
]

const black_numbers = [
	2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
]
const green_numbers = [0, 37]
	
var top_number_row = get_top_row()
var middle_number_row = get_top_row()
var lower_number_row = get_top_row()
var first_twelve = get_first_twelve()
var second_twelve = get_second_twelve()
var third_twelve = get_third_twelve()
var first_half = get_first_half()
var second_half = get_second_half()
var odd_numbers = get_odd_numbers()
var even_numbers = get_even_numbers()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_top_row():
	return find_row(0)
	
func get_middle_row():
	return find_row(2)

func get_bottom_row():
	return find_row(1)
	
func get_first_twelve():
	return find_third(0)
	
func get_second_twelve():
	return find_third(1)
	
func get_third_twelve():
	return find_third(2)

func get_first_half():
	return find_half(0)

func get_second_half():
	return find_half(1)
	
func get_odd_numbers():
	return find_parity(1)

func get_even_numbers():
	return find_parity(0)

func is_green_number(number):
	if (number == 0) or (number == 37):
		return true

func find_row(i):
	var row = []
	for number in table_numbers:
		if number % 3 == (0 + i) and not is_green_number(number):
			row.append(number)
	return row

func find_third(i):
	var row = []
	var range_number = i * 12
	var lower_range = 1 + range_number
	var upper_range = 13 + range_number
	for number in table_numbers:
		if number in range(lower_range, upper_range):
			row.append(number)
	return row

func find_half(i):
	var row = []
	var range_number = i * 18
	var lower_range = 1 + range_number
	var upper_range = 19 + range_number
	for number in table_numbers:
		if number in range(lower_range, upper_range):
			row.append(number)
	return row
	
func find_parity(i):
	var row = []
	for number in table_numbers:
		if number % 2 == i:
			row.append(number)
	return row
