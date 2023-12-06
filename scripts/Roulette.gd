extends Node2D

## Roulette Game Root Node.
##
## CIS 350 Casino Project
##
## This script handles the main interactions and logic of the roulette game.
## It keeps track of when the wheel and ball are spinning, manages the visibility
## of bet options, and processes user input to trigger spins. It also provides
## feedback to the player by showing the pocket number where the ball stops.
##
## File Paths for Integration with Main Menu Scene:
## res://scenes/roulette.tscn
## res://scripts/.gd files when file names start with 'Roulette'
## res://assets/.png files when file names start with 'Roulette'
##
## Active Use Cases while Game Runs:
## Spin Button - Spins the roulette wheel while wheel and ball aren't moving
## Space Bar - Alternative to Spin Button while following the same conditions
## 
## The proceeding use cases appear while game runs but do not execute currently. 
## Current Use Cases Pending Implementation:
## Clear - Awaiting implemention of clearing of chips on the table
## Bet - Awaiting implementation of placing of chips on the table
## Menu - Awaiting implementation of menu options to return to main menu
## Options - Awaiting implementation of potential game settings like bet limits 
## Repeat Bets - Conditional switch intended to keep bets for proceeding spin
##
## Author: Nathan Vincent
## Date: 10/27/2023


@onready
var wheel = get_node("RouletteWheel")
@onready
var ball = get_node("RouletteWheel/RouletteBall")
@onready
var bet_options = get_node("RouletteTable/BetOptions")
@onready
var resulting_number_popup = get_node("ResultPopup")
@onready
var table = get_node("RouletteTable")
@onready
var table_squares = get_node("RouletteTable/TableSquares")
@onready
var chip_selection = get_node("RouletteTable/ChipSelection")
@onready
var chips_on_table_label = get_node("RouletteTable/ChipsOnTable")
@onready
var user_chips_label = get_node("UserChipValue")

var allow_bets = false
var repeat_bets = false
var output_multiplier = 1
var chip_count = 1000

# Called once node enters the scene tree for the first time
func _ready() -> void:
	ball.visible = false
	allow_bets = false
	hide_chip_selection()
	_set_user_chips_text()
	show_user_chips_value()

# Called every frame while 'delta' is elapsed time since previous frame
func _process(delta: float) -> void:
	# Hides betting options while wheel is spinning and displays if not
	if wheel.is_spinning() or ball.is_moving():
		hide_bet_options()
	else:
		show_bet_options()

# Responds to user space bar input to trigger the wheel and ball spin
func _input(event: InputEvent) -> void:
	# Checks if the "spin_wheel" action is triggered and if neither the wheel nor the ball is currently moving
	if event.is_action_pressed("spin_wheel") and not wheel.is_spinning() and not ball.is_moving():
		# Initiates the spin for both the wheel and the ball
		hide_number_result()
		wheel.start_spin()
		ball.start_spin(wheel.global_position)

# Callback for when the ball stops moving on the roulette wheel
func _on_ball_stopped(angle_degrees: float) -> void:
	#Gets the pocket number from the wheel and displays the pocket the ball resides
	var ball_position = wheel.get_pocket_number(angle_degrees)
	_set_number_result_text(ball_position)
	show_number_result()
	_determine_payout(ball_position)
	if repeat_bets:
		chip_count -= table.current_bet_cost
		_set_user_chips_text()
	else:
		table.clear_bets()

# Called when spin button is clicked
func _on_spin_pressed() -> void:
	if not wheel.is_spinning() and not ball.is_moving():
		hide_number_result()
		wheel.start_spin()
		ball.start_spin(wheel.global_position)
		if not ball.visible:
			ball.visible = true

# Converts pocket number to string
func pocket_to_str(pocket_element: int) -> String:
	# Checks if pocket is 00 because 00 is represented as int element 37
	if pocket_element == 37:
		return "00"
	else:
		return str(pocket_element)

# Displays betting options
func show_bet_options() -> void:
	bet_options.visible = true

# Hides betting options to restrict access during game operations
func hide_bet_options() -> void:
	bet_options.visible = false
	hide_chip_selection()
	
func show_chip_selection():
	chip_selection.visible = true

func hide_chip_selection():
	chip_selection.visible = false
	
func show_user_chips_value():
	user_chips_label.visible = true
	
func hide_user_chips_value():
	user_chips_label.visible = false
	
# Displays pop up text of pocket that ball resides in
func show_number_result() -> void:
	resulting_number_popup.visible = true

# Hides previous pop up text of pocket that ball resides in
func hide_number_result() -> void:
	resulting_number_popup.visible = false

# Sets the respective text to be displayed for popup showing resting ball position
func _set_number_result_text(pocket_element: int) -> void:
	resulting_number_popup.text = "The ball stopped on pocket number: %s." % pocket_to_str(pocket_element)
	
func add_to_user_chip_count(payout):
	chip_count += payout
	_set_user_chips_text()
	
func subtract_from_user_chip_count(chip_value):
	chip_count -= chip_value
	_set_user_chips_text()

func _set_user_chips_text():
	user_chips_label.text = "Value of chips: %d" % chip_count
	
func _determine_payout(ball_position):
	table.apply_payout(ball_position)

func _on_bets_pressed():
	show_chip_selection()

func _on_table_squares_input_event(viewport, event, shape_idx):
	if allow_bets:
		if event is InputEventMouseButton and event.pressed:
			table.place_bets(viewport, event, shape_idx, output_multiplier, chip_count)

func _on_one_dollar_pressed():
	allow_bets = true
	output_multiplier = 1

func _on_five_dollar_pressed():
	allow_bets = true
	output_multiplier = 5

func _on_ten_dollar_pressed():
	allow_bets = true
	output_multiplier = 10

func _on_clear_pressed():
	chip_count += table.current_bet_cost
	_set_user_chips_text()
	table.clear_bets()

func _on_repeat_bets_toggled(button_pressed):
	if not repeat_bets:
		repeat_bets = true
	else:
		repeat_bets = false
