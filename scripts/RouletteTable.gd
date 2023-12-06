extends Sprite2D

## Roulette Table Layout and Number Organization.
##
## This script lays the foundation for the roulette table's number arrangements 
## and categories. It categorizes numbers into their respective rows, thirds, 
## halves, and by parity (odd/even). Additionally, it identifies red, black, 
## and green numbers based on standard roulette rules.
##
## As this script is unfinished, future improvements might include integrating
## betting functionalities, providing visual indications for the user, and
## handling game events related to the table's layout.
##
## No functions in this script have been tested and are lacking implementation 
## of comments as they aren't intended for the current release.
##
## Author: Nathan Vincent
## Date: 10/27/2023

const TABLE_NUMBERS = [
	0,
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
	13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
	25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
	37
	]

const NUMBER_GRID = [
	[3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36],
	[2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35],
	[1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
]

const RED_NUMBERS = [
	1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
]

const BLACK_NUMBERS = [
	2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
]
const GREEN_NUMBERS = [0, 37]

var bets_on_table = {}

@onready
var table_squares = get_node("TableSquares")
@onready
var individual_number_squares = get_node("TableSquares/IndividualNumbers")
@onready
var two_to_one_squares = get_node("TableSquares/IndividualNumbers")
@onready
var thirds_squares = get_node("TableSquares/Thirds")
@onready
var halves_variants_squares = get_node("TableSquares/HalvesVariants")
@onready
var single_zero_square = get_node("TableSquares/SingleZero")
@onready
var double_zero_square = get_node("TableSquares/DoubleZero")
@onready
var current_bet_value_label = get_node("TotalBetValue")
@onready
var chips_on_table_label = get_node("ChipsOnTable")

var current_bet_cost = 0
var current_bets_string = ""

var top_number_row = NUMBER_GRID[0]
var middle_number_row = NUMBER_GRID[1]
var bottom_number_row = NUMBER_GRID[2]
var first_twelve = get_first_twelve()
var second_twelve = get_second_twelve()
var third_twelve = get_third_twelve()
var first_half = get_first_half()
var second_half = get_second_half()
var odd_numbers = get_odd_numbers()
var even_numbers = get_even_numbers()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func place_bets(viewport, event, shape_idx, chip_value, chipcount):
	if chipcount >= chip_value:
		_subtract_from_chip_count(chip_value)
		var assignment_key
		match shape_idx:
			0:
				var area = table_squares.individual_number_clicked(viewport, event)
				assignment_key = NUMBER_GRID[area.row][area.column]
				
			1:
				var row = table_squares.two_to_one_clicked(viewport, event)
				assignment_key = row
				
			2:
				var column = table_squares.thirds_clicked(viewport, event)
				assignment_key = column
			3:
				var column = table_squares.halves_variants_clicked(viewport, event)
				assignment_key = column
			4:
				assignment_key = 0
			5:
				assignment_key = 37
				
		set_current_bets_cost(chip_value)
		if bets_on_table.has(shape_idx) and bets_on_table[shape_idx] is Dictionary:
			if assignment_key in bets_on_table[shape_idx]:
				bets_on_table[shape_idx][assignment_key] = bets_on_table[shape_idx][assignment_key] + chip_value
			else:
				bets_on_table[shape_idx][assignment_key] = chip_value
		else:
			bets_on_table[shape_idx] = {}
			bets_on_table[shape_idx][assignment_key] = chip_value
		set_current_bets_string()

func set_current_bets_string():
	current_bets_string = ""
	var string_snippets = []
	for bet_type in bets_on_table.keys():
		match bet_type:
			0:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[0].keys():
					if not index_map.has(bets_on_table[0][number]):
						index_map[bets_on_table[0][number]] = [number]
					else:
						index_map[bets_on_table[0][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on "
					for index in index_map[cost]:
						string_snippet += str(index) + ", "
				string_snippet += "each with X%d payout." % 35
				string_snippets.append(string_snippet)
			1:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[1].keys():
					if not index_map.has(bets_on_table[1][number]):
						index_map[bets_on_table[1][number]] = [number]
					else:
						index_map[bets_on_table[1][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on Row "
					for index in index_map[cost]:
						string_snippet += str(index + 1) + ", "
				string_snippet += "each with X%d payout. " % 12
				string_snippets.append(string_snippet)
			2:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[2].keys():
					if not index_map.has(bets_on_table[2][number]):
						index_map[bets_on_table[2][number]] = [number]
					else:
						index_map[bets_on_table[2][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on "
					for index in index_map[cost]:
						string_snippet += match_thirds(index) + ", "
				string_snippet += "each with X%d payout. " % 3
				string_snippets.append(string_snippet)
			3:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[3].keys():
					if not index_map.has(bets_on_table[3][number]):
						index_map[bets_on_table[3][number]] = [number]
					else:
						index_map[bets_on_table[3][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on "
					for index in index_map[cost]:
						string_snippet += match_halves(index) + ", "
				string_snippet += "each with X%d payout. " % 2
				string_snippets.append(string_snippet)
			4:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[4].keys():
					if not index_map.has(bets_on_table[4][number]):
						index_map[bets_on_table[4][number]] = [number]
					else:
						index_map[bets_on_table[4][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on "
					for index in index_map[cost]:
						string_snippet += str(index) + ", "
				string_snippet += "each with X%d payout. " % 35
				string_snippets.append(string_snippet)
			5:
				var index_map = {}
				var string_snippet = ""
				for number in bets_on_table[5].keys():
					if not index_map.has(bets_on_table[5][number]):
						index_map[bets_on_table[5][number]] = [number]
					else:
						index_map[bets_on_table[5][number]].append(number)
				for cost in index_map.keys():
					string_snippet += "$" + str(cost) + " on "
					for index in index_map[cost]:
						string_snippet += str(index) + ", "
				string_snippet += "each with X%d payout. " % 35
				string_snippets.append(string_snippet)
				
	for string in string_snippets:
		current_bets_string += string
	set_chips_on_table_label()

func set_current_bets_cost(chip_value):
	if not current_bet_value_label.visible:
		current_bet_value_label.visible = true
	current_bet_cost += chip_value
	current_bet_value_label.text = "Bets cost: $%d" % current_bet_cost
	
func set_chips_on_table_label():
	if not chips_on_table_label.visible:
		chips_on_table_label.visible = true
	chips_on_table_label.text = "Current bets: %s" % current_bets_string

func match_thirds(column):
	if column == 0:
		return "1 - 12"
	if column == 1:
		return "13 - 24"
	if column == 2:
		return "25 - 36"
			
func match_halves(column):
	if column == 0:
		return "1 - 18"
	if column == 1:
		return "Even Numbers"
	if column == 2:
		return "Red Numbers"
	if column == 3:
		return "Black Numbers"
	if column == 4:
		return "Odd Numbers"
	if column == 5:
		return "19 - 36"
	
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
	for number in TABLE_NUMBERS:
		if number % 3 == (0 + i) and (not is_green_number(number)):
			row.append(number)
	return row

func find_third(i):
	var row = []
	var range_number = i * 12
	var lower_range = 1 + range_number
	var upper_range = 13 + range_number
	for number in TABLE_NUMBERS:
		if (number in range(lower_range, upper_range)) and (not is_green_number(number)):
			row.append(number)
	return row

func find_half(i):
	var row = []
	var range_number = i * 18
	var lower_range = 1 + range_number
	var upper_range = 19 + range_number
	for number in TABLE_NUMBERS:
		if (number in range(lower_range, upper_range)) and (not is_green_number(number)):
			row.append(number)
	return row
	
func find_parity(i):
	var row = []
	for number in TABLE_NUMBERS:
		if (number % 2 == i) and (not is_green_number(number)):
			row.append(number)
	return row

func apply_payout(ball_position):
	for type in bets_on_table.keys():
		match type:
			0:
				_individual_numbers_payout(ball_position)
			1:
				_two_to_one_payout(ball_position)
			2:
				_thirds_payout(ball_position)
			3:
				_halves_variants_payout(ball_position)
			4:
				_single_zero_payout(ball_position)
			5:
				_double_zero_payout(ball_position)
				
#	var bets = []
#	for bet in bets_on_table.keys():
#		bets.append(bet)

func _individual_numbers_payout(ball_position):
	var reward = 0
	for bet in bets_on_table[0].keys():
		if bet == ball_position:
			reward += (bets_on_table[0][bet] * 35)
			break
	_add_to_user_chip_count(reward)

func _two_to_one_payout(ball_position):
	var reward = 0
	if ball_position in top_number_row:
		for bet_group in bets_on_table[1].keys():
			if bet_group == 0:
				reward += (bets_on_table[1][bet_group] * 12)
				break
	elif ball_position in middle_number_row:
		for bet_group in bets_on_table[1].keys():
			if bet_group == 1:
				reward += (bets_on_table[1][bet_group] * 12)
				break
	elif ball_position in bottom_number_row:
		for bet_group in bets_on_table[1].keys():
			if bet_group == 2:
				reward += (bets_on_table[1][bet_group] * 12)
				break
	_add_to_user_chip_count(reward)
	
func _thirds_payout(ball_position):
	var reward = 0
	if ball_position in first_twelve:
		for bet_group in bets_on_table[2].keys():
			if bet_group == 0:
				reward += (bets_on_table[2][bet_group] * 12)
				break
	elif ball_position in middle_number_row:
		for bet_group in bets_on_table[2].keys():
			if bet_group == 1:
				reward += (bets_on_table[2][bet_group] * 12)
				break
	elif ball_position in bottom_number_row:
		for bet_group in bets_on_table[2].keys():
			if bet_group == 2:
				reward += (bets_on_table[2][bet_group] * 12)
				break
	_add_to_user_chip_count(reward)
	
	
func _halves_variants_payout(ball_position):
	var reward = 0
	if ball_position in first_half:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 0:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	elif ball_position in even_numbers:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 1:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	elif ball_position in RED_NUMBERS:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 2:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	elif ball_position in BLACK_NUMBERS:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 3:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	elif ball_position in odd_numbers:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 4:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	elif ball_position in second_half:
		for bet_group in bets_on_table[3].keys():
			if bet_group == 5:
				reward += (bets_on_table[3][bet_group] * 12)
				break
	_add_to_user_chip_count(reward)

func _single_zero_payout(ball_position):
	var reward = 0
	if not bets_on_table[4].size() == 0:
		reward += (bets_on_table[4][ball_position] * 35)
	_add_to_user_chip_count(reward)
		
func _double_zero_payout(ball_position):
	var reward = 0
	if not bets_on_table[5].size() == 0:
		reward += (bets_on_table[5][ball_position] * 35)
	_add_to_user_chip_count(reward)

func _add_to_user_chip_count(payout):
	get_parent().add_to_user_chip_count(payout)
func _subtract_from_chip_count(chip_value):
	get_parent().subtract_from_user_chip_count(chip_value)
	
func clear_bets():
	bets_on_table = {}
	current_bet_cost = 0
	current_bet_value_label.text = ""
	chips_on_table_label.text = ""
