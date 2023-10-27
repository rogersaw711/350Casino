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

# Called once node enters the scene tree
func _ready() -> void:
	pass

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
	_set_number_result_text(wheel.get_pocket_number(angle_degrees))
	show_number_result()

# Called when spin button is clicked
func _on_spin_pressed() -> void:
	if not wheel.is_spinning() and not ball.is_moving():
		hide_number_result()
		wheel.start_spin()
		ball.start_spin(wheel.global_position)

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

# Displays pop up text of pocket that ball resides in
func show_number_result() -> void:
	resulting_number_popup.visible = true

# Hides previous pop up text of pocket that ball resides in
func hide_number_result() -> void:
	resulting_number_popup.visible = false

# Sets the respective text to be displayed for popup showing resting ball position
func _set_number_result_text(pocket_element: int) -> void:
	resulting_number_popup.text = "The ball stopped on pocket number: %s." % pocket_to_str(pocket_element)
