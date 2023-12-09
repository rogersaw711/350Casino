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
## res://scripts/.gd files when file names start with 'Roulette' and for 'TableSquares'
## res://assets/.png files when file names start with 'Roulette'
##
## Active Use Cases while Game Runs:
## Spin Button - Spins the roulette wheel while wheel and ball aren't moving
## Space Bar - Alternative to Spin Button while following the same conditions
## Clear - Clears chips on the table
## Bet - Places chips on the table following value allocation
## Repeat Bets - Conditional switch to keep bets for proceeding spin
## 
## The proceeding use cases appear while game runs but do not execute currently. 
## Current Use Cases Pending Implementation:
## Menu - Awaiting implementation of menu options to return to main menu
##
## Author: Nathan Vincent
## Date: 12/8/2023

var _repeat_bets = false
var _have_coin_count = false
var chip_count = 0

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

# Called once node enters the scene tree for the first time
func _ready() -> void:
	if is_instance_valid("/root/CoinCount"):
		_have_coin_count = true
		chip_count = get_node("/root/CoinCount").coinCount
	else:
		chip_count = 1000
	ball.visible = false
	_hide_chip_selection()
	_set_user_chips_text()
	_show_user_chips_value()

# Called every frame while 'delta' is elapsed time since previous frame
func _process(delta: float) -> void:
	# Hides betting options while wheel is spinning and displays if not
	if wheel.is_spinning() or ball.is_moving():
		_hide_bet_options()
	else:
		_show_bet_options()

# Responds to user space bar input to trigger the wheel and ball spin
func _input(event: InputEvent) -> void:
	# Checks if the "spin_wheel" action is triggered and if neither the wheel nor the ball is currently moving
	if event.is_action_pressed("spin_wheel") and not wheel.is_spinning() and not ball.is_moving():
		# Initiates the spin for both the wheel and the ball
		_hide_number_result()
		wheel.start_spin()
		ball.start_spin(wheel.global_position)
		if not ball.visible:
			ball.visible = true

# Keeps the bets on table for instead of clearing them after wheel spin of selected
func _on_repeat_bets_toggled(button_pressed):
	if not _repeat_bets:
		_repeat_bets = true
	else:
		_repeat_bets = false

# Clears the bets on table, returning the value of chips on the table to the user
func _on_clear_pressed():
	add_to_user_chip_count(table.current_bet_cost)
	table.clear_bets()

# Grants access to selection of chip values to place bets with
func _on_bets_pressed():
	_show_chip_selection()

# Called when spin button is clicked
func _on_spin_pressed() -> void:
	if not wheel.is_spinning() and not ball.is_moving():
		_hide_number_result()
		wheel.start_spin()
		ball.start_spin(wheel.global_position)
		if not ball.visible:
			ball.visible = true

# Callback for when the ball stops moving on the roulette wheel
func _on_ball_stopped(angle_degrees: float) -> void:
	#Gets the pocket number from the wheel and displays the pocket the ball resides
	var ball_position = wheel.get_pocket_number(angle_degrees)
	_set_number_result_text(ball_position)
	_show_number_result()
	_determine_payout(ball_position)
	if _repeat_bets:
		chip_count -= table.current_bet_cost
		_set_user_chips_text()
	else:
		table.clear_bets()

# Adds to total value of user chips
func add_to_user_chip_count(chip_value):
	chip_count += chip_value
	#Integrates change into universal chip count if applicable
	if _have_coin_count:
		get_node("/root/ChipCount").setCoins(chip_count)
	_set_user_chips_text()

# Subtracts from total value of user chips
func subtract_from_user_chip_count(chip_value):
	chip_count -= chip_value
	#Integrates change into universal chip count if applicable
	if _have_coin_count:
		get_node("/root/ChipCount").setCoins(chip_count)
	_set_user_chips_text()

# Sets the respective text to be displayed for popup showing resting ball position
func _set_number_result_text(pocket_element: int) -> void:
	resulting_number_popup.text = "The ball stopped on pocket number: %s." % _pocket_to_str(pocket_element)

# Sets the respective text to be displayed for popup showing total value of user chips
func _set_user_chips_text():
	user_chips_label.text = "Value of chips: %d" % chip_count

# Displays betting options butttons for in between ball spins
func _show_bet_options() -> void:
	bet_options.visible = true

# Hides betting options to restrict access during game operations
func _hide_bet_options() -> void:
	bet_options.visible = false
	_hide_chip_selection()

# Displays buttons for respective values of individual chips to bet
func _show_chip_selection():
	chip_selection.visible = true

# Hides buttons for respective values of individual chips to bet
func _hide_chip_selection():
	chip_selection.visible = false

# Displays value of user's chips
func _show_user_chips_value():
	user_chips_label.visible = true

# Hides value of user's chips
func _hide_user_chips_value():
	user_chips_label.visible = false
	
# Displays pop up text of pocket that ball resides in
func _show_number_result() -> void:
	resulting_number_popup.visible = true

# Hides previous pop up text of pocket that ball resides in
func _hide_number_result() -> void:
	resulting_number_popup.visible = false

# Converts pocket number to string
func _pocket_to_str(pocket_element: int) -> String:
	# Checks if pocket is 00 because 00 is represented as int element 37
	if pocket_element == 37:
		return "00"
	else:
		return str(pocket_element)

# Finds payout from bets them on table and applies them if so
func _determine_payout(ball_position):
	table.apply_payout(ball_position)
