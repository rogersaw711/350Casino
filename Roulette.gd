extends Node2D

@onready
var wheel = get_node("RouletteWheel")
@onready
var ball = get_node("RouletteWheel/RouletteBall")
@onready
var bet_options = get_node("RouletteTable/BetOptions")

func _ready():
	pass

func _process(delta):
	if wheel.is_spinning() or ball.is_moving():
		bet_options.visible = false
	else:
		bet_options.visible = true

# Responds to user input for triggering the wheel and ball spin
func _input(event: InputEvent) -> void:
	# Checks if the "spin_wheel" action is triggered and if neither the wheel nor the ball is currently moving
	if event.is_action_pressed("spin_wheel") and not wheel.is_spinning() and not ball.is_moving():
		# Initiates the spin for both the wheel and the ball
		wheel.start_spin()
		ball.start_spin(wheel.global_position)

# Callback for when the ball stops moving on the roulette wheel
# Calculates and prints the pocket number based on the angle at which the ball stopped
func _on_ball_stopped(angle_degrees: float) -> void:
	print("The ball stopped on pocket number: ", wheel.get_pocket_number(angle_degrees))
	var result_message
	var result_popup = get_node("ResultPopup")
	if wheel.get_pocket_number(angle_degrees) == 37:
		result_message = "00"
	else:
		result_message = str(wheel.get_pocket_number(angle_degrees))
	result_popup.text = "The ball stopped on pocket number: %s." % result_message
	result_popup.visible = true

func _on_spin_pressed():
	if not wheel.is_spinning() and not ball.is_moving():
		var result_popup = get_node("ResultPopup")
		result_popup.visible = false
		wheel.start_spin()
		ball.start_spin(wheel.global_position)
