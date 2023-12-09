extends Sprite2D

## Roulette Table Layout and Number Organization.
##
## This script is inclusive of the roulette table's number arrangements 
## and categories. It categorizes numbers into their respective rows, thirds, 
## halves, and by parity (odd/even). Additionally, it identifies red, black, 
## and green numbers based on standard roulette rules.
## This script stores the bets on table and displays/hides their respective amounts
## It returns the value of the mayout to the main game node when prompted
##
##
## Author: Nathan Vincent
## Date: 12/8/2023

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
const INDIVIDUAL_NUMBERS_INDEX = 0
const TWO_TO_ONE_INDEX = 1
const THIRDS_INDEX = 2
const HALVES_VARIANTS_INDEX = 3
const SINGLE_ZERO_INDEX = 4
const DOUBLE_ZERO_INDEX = 5
const TOP_NUMBER_ROW = NUMBER_GRID[0]
const MIDDLE_NUMBER_ROW = NUMBER_GRID[1]
const BOTTOM_NUMBER_ROW = NUMBER_GRID[2]
var first_twelve = _get_first_twelve()
var second_twelve = _get_second_twelve()
var third_twelve = _get_third_twelve()
var first_half = _get_first_half()
var second_half = _get_second_half()
var odd_numbers = _get_odd_numbers()
var even_numbers = _get_even_numbers()
var allow_bets = false # Condition to allow/deny bets depending on current game
var individual_chip_value = 1 # Value assigned to chip use to apply bet
var bets_on_table = {} # Intended to possess nested dictionaries of current bets
var current_bet_cost = 0 # Value assingned to the total cost of the bets on table
var current_bets_string = "" # String consisting of current bets on the table

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
@onready
var chips_on_table_label_continued = get_node("ChipsOnTableContinued")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Sets the value of each chip to be placed for a bet to $1
func _on_one_dollar_pressed():
	allow_bets = true
	individual_chip_value = 1

# Sets the value of each chip to be placed for a bet to $5
func _on_five_dollar_pressed():
	allow_bets = true
	individual_chip_value = 5

# Sets the value of each chip to be placed for a bet to $10
func _on_ten_dollar_pressed():
	allow_bets = true
	individual_chip_value = 10

# Clears all the bets applied to the table
func clear_bets():
	bets_on_table = {}
	current_bet_cost = 0
	current_bet_value_label.text = ""
	chips_on_table_label.text = ""
	chips_on_table_label_continued.text = ""

# Stores each bet as a key with its value pertaining to the cost of the bet
func place_bets(category_index, assignment_key):
	_set_current_bets_cost(individual_chip_value)
	if bets_on_table.has(category_index) and bets_on_table[category_index] is Dictionary:
		if assignment_key in bets_on_table[category_index]:
			bets_on_table[category_index][assignment_key] = bets_on_table[category_index][assignment_key] + individual_chip_value
		else:
			bets_on_table[category_index][assignment_key] = individual_chip_value
	else:
		bets_on_table[category_index] = {}
		bets_on_table[category_index][assignment_key] = individual_chip_value
	_set_current_bets_string()

# Deducts the value of the individual chip to be bet with from the amount of the users chips
func deduct_individual_chip_value():
	_subtract_from_chip_count(individual_chip_value)

# Applies payout of wheel spin result depending on if ball position falls into bet placed before spin
func apply_payout(ball_position):
	for type in bets_on_table.keys():
		match type:
			INDIVIDUAL_NUMBERS_INDEX:
				_individual_numbers_payout(ball_position)
			TWO_TO_ONE_INDEX:
				_two_to_one_payout(ball_position)
			THIRDS_INDEX:
				_thirds_payout(ball_position)
			HALVES_VARIANTS_INDEX:
				_halves_variants_payout(ball_position)
			SINGLE_ZERO_INDEX:
				_single_zero_payout(ball_position)
			DOUBLE_ZERO_INDEX:
				_double_zero_payout(ball_position)

# Returns the current dollar amount of respective users total chips
func get_user_chip_count():
	return get_parent().chip_count

# Returns numbers 1 through 12
func _get_first_twelve():
	return _get_third(0)

# Returns numbers 13 through 24
func _get_second_twelve():
	return _get_third(1)

# Returns numbers 25 through 36
func _get_third_twelve():
	return _get_third(2)

# Returns numbers 1 through 18
func _get_first_half():
	return _get_half(0)

# Returns numbers 19 through 36
func _get_second_half():
	return _get_half(1)

# Returns every odd number from 1 through 36
func _get_odd_numbers():
	return _get_parity(1)

# Returns every even number from 1 through 36
func _get_even_numbers():
	return _get_parity(0)

# Returns third numbers 1 through 36 numerically depending on variable intake
func _get_third(variable):
	var row = []
	var range_number = variable * 12
	var lower_range = 1 + range_number
	var upper_range = 13 + range_number
	for number in TABLE_NUMBERS:
		if (number in range(lower_range, upper_range)) and not number in GREEN_NUMBERS:
			row.append(number)
	return row

# Returns half of ordered numbers 1 through 36 numerically depending on variable intake
func _get_half(variable):
	var row = []
	var range_number = variable * 18
	var lower_range = 1 + range_number
	var upper_range = 19 + range_number
	for number in TABLE_NUMBERS:
		if (number in range(lower_range, upper_range)) and not number in GREEN_NUMBERS:
			row.append(number)
	return row

# Returns parity of numbers 1 through 36 depending on variable intake
func _get_parity(variable):
	var row = []
	for number in TABLE_NUMBERS:
		if (number % 2 == variable) and not number in GREEN_NUMBERS:
			row.append(number)
	return row

# Sets the text for popup displaying current cost of bets on table while displaying it if hidden
func _set_current_bets_cost(chip_value):
	if not current_bet_value_label.visible:
		current_bet_value_label.visible = true
	current_bet_cost += chip_value
	current_bet_value_label.text = "Bets cost: $%d" % current_bet_cost

# Sets the text for popup displaying current cost of bets on table while displaying it if hidden
func _set_chips_on_table_label():
	# Conditional for determining if two labels should be used
	if len(current_bets_string) > 110:
		for i in range(10):
			if current_bets_string[i + 100] == " ":
				# Splits the string consisting of bets on table into two labels as two lines for readibility purposes
				chips_on_table_label.text = "Current bets: " + current_bets_string.substr(0, i + 100)
				chips_on_table_label_continued.text = current_bets_string.substr(i + 100, current_bets_string.length() - (i + 100))
		if not chips_on_table_label.visible:
			chips_on_table_label.visible = true
			chips_on_table_label_continued.visible = true
	else:
		chips_on_table_label.text = "Current bets: " + current_bets_string
		if not chips_on_table_label.visible:
			chips_on_table_label.visible = true
			if chips_on_table_label_continued.visible:
				chips_on_table_label_continued.visible = false

# Assigns the current bets on table to a string intended for the popup label consisting of the bets on the table
func _set_current_bets_string():
	current_bets_string = ""
	var string_snippets = []
	for bet_type in bets_on_table.keys():
		var index_map = {}
		var string_snippet = ""
		for number in bets_on_table[bet_type].keys():
			if not index_map.has(bets_on_table[bet_type][number]):
				index_map[bets_on_table[bet_type][number]] = [number]
			else:
				index_map[bets_on_table[bet_type][number]].append(number)
		for cost in index_map.keys():
			string_snippet += "$" + str(cost) + " on "
			match bet_type:
				INDIVIDUAL_NUMBERS_INDEX, SINGLE_ZERO_INDEX, DOUBLE_ZERO_INDEX:
					for index in index_map[cost]:
						string_snippet += str(index) + ", "
					string_snippet += "for X%d payout. " % 35
				TWO_TO_ONE_INDEX:
					string_snippet += "Row "
					for index in index_map[cost]:
						string_snippet += str(index + 1) + ", "
					string_snippet += "for X%d payout. " % 3
				THIRDS_INDEX:
					for index in index_map[cost]:
						string_snippet += _match_thirds(index) + ", "
					string_snippet += "for X%d payout. " % 3
				HALVES_VARIANTS_INDEX:
					for index in index_map[cost]:
						string_snippet += _match_halves(index) + ", "
					string_snippet += "for X%d payout. " % 2
		string_snippets.append(string_snippet)
	for string in string_snippets:
		current_bets_string += string
	_set_chips_on_table_label()

# Returns set of numbers as string dependent on respective column for thirds category
func _match_thirds(column):
	if column == 0:
		return "1 - 12"
	if column == 1:
		return "13 - 24"
	if column == 2:
		return "25 - 36"

# Returns set of numbers as string dependent on respective column for halves category
func _match_halves(column):
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

# Adds value of payout for individual numbers bet to user chip count if applicable
func _individual_numbers_payout(ball_position):
	for bet in bets_on_table[INDIVIDUAL_NUMBERS_INDEX].keys():
		if bet == ball_position:
			_add_to_user_chip_count(bets_on_table[INDIVIDUAL_NUMBERS_INDEX][bet] * 35)
			break

# Adds value of payout for two to one bet to user chip count if applicable
func _two_to_one_payout(ball_position):
	if ball_position in TOP_NUMBER_ROW:
		for bet_group in bets_on_table[TWO_TO_ONE_INDEX].keys():
			if bet_group == 0:
				_add_to_user_chip_count(bets_on_table[TWO_TO_ONE_INDEX][bet_group] * 3)
				break
	elif ball_position in MIDDLE_NUMBER_ROW:
		for bet_group in bets_on_table[TWO_TO_ONE_INDEX].keys():
			if bet_group == 1:
				_add_to_user_chip_count(bets_on_table[TWO_TO_ONE_INDEX][bet_group] * 3)
				break
	elif ball_position in BOTTOM_NUMBER_ROW:
		for bet_group in bets_on_table[TWO_TO_ONE_INDEX].keys():
			if bet_group == 2:
				_add_to_user_chip_count(bets_on_table[TWO_TO_ONE_INDEX][bet_group] * 3)
				break

# Adds value of payout for bet on either 1-12, 13-24, or 25-36 to user chip count if applicable
func _thirds_payout(ball_position):
	if ball_position in first_twelve:
		for bet_group in bets_on_table[THIRDS_INDEX].keys():
			if bet_group == 0:
				_add_to_user_chip_count(bets_on_table[THIRDS_INDEX][bet_group] * 3)
				break
	elif ball_position in second_twelve:
		for bet_group in bets_on_table[THIRDS_INDEX].keys():
			if bet_group == 1:
				_add_to_user_chip_count(bets_on_table[THIRDS_INDEX][bet_group] * 3)
				break
	elif ball_position in third_twelve:
		for bet_group in bets_on_table[THIRDS_INDEX].keys():
			if bet_group == 2:
				_add_to_user_chip_count(bets_on_table[THIRDS_INDEX][bet_group] * 3)
				break

# Adds value of payout for bet on halves variant to user chip count if applicable
func _halves_variants_payout(ball_position):
	if ball_position in first_half:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 0:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break
	elif ball_position in second_half:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 5:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break
	if ball_position in even_numbers:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 1:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break
	elif ball_position in odd_numbers:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 4:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break
	if ball_position in RED_NUMBERS:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 2:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break
	elif ball_position in BLACK_NUMBERS:
		for bet_group in bets_on_table[HALVES_VARIANTS_INDEX].keys():
			if bet_group == 3:
				_add_to_user_chip_count(bets_on_table[HALVES_VARIANTS_INDEX][bet_group] * 2)
				break

# Adds value of payout for bet on single zero to user chip count if applicable
func _single_zero_payout(ball_position):
	if SINGLE_ZERO_INDEX in bets_on_table.keys():
		_add_to_user_chip_count(bets_on_table[SINGLE_ZERO_INDEX][ball_position] * 35)

# Adds value of payout for bet on double zero to user chip count if applicable
func _double_zero_payout(ball_position):
	if DOUBLE_ZERO_INDEX in bets_on_table.keys():
		_add_to_user_chip_count(bets_on_table[DOUBLE_ZERO_INDEX][ball_position] * 35)

# Adds dollar value in chips to user chip value
func _add_to_user_chip_count(chip_value):
	get_parent().add_to_user_chip_count(chip_value)

# Subtracts dollar value in chips to user chip value
func _subtract_from_chip_count(chip_value):
	get_parent().subtract_from_user_chip_count(chip_value)
