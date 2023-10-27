extends CharacterBody2D

# Sets Minimum Rotation Speed
var minRotationSpeed = 300

# Sets Maximum Rotation Speed
var maxRotationSpeed = 550

# How Fast the Wheel will Decelerate
var deceleration = 55
var spinning = false
var rotationSpeed = 0

# Size of each segment in degrees
var segmentSize = 45

# Variable to store the current segment
var currentSegment = ""

# Flag to track if the wheel has been spun
var hasSpun = false

# Flag to track if the segment has been printed
var hasPrinted = false

# Declare the label variable with onready
@onready var label: Label = $Label

# List to store winnings
var list = []

# Variable to store the sum of winnings
var sum = 0

# Jackpot amount
var Jackpotamount = 1000

func _ready():
	set_process_input(true)
	label.text = ""


# Function to initiate spinning the wheel
func _spin():
	if !spinning:
		spinning = true
		rotationSpeed = randf_range(minRotationSpeed, maxRotationSpeed)
		$BackButton.hide()
		print("rotationspeed: ", rotationSpeed)
		hasSpun = true
		hasPrinted = false

# Function to handle user input
func _input(event):
	if event.is_action_pressed("Spin"):
		_spin()

	# Check for the reset action
	if event.is_action_pressed("Reset") and rotationSpeed == 0:
		reset_wheel()

# Function to update the wheel's rotation
func _process(delta):
	if spinning:
		rotationSpeed -= deceleration * delta
		rotationSpeed = max(rotationSpeed, 0)
		$Wheel.rotation_degrees += rotationSpeed * delta

		if rotationSpeed == 0 and hasSpun and !hasPrinted:
			update_segment()

# Function to determine the current winning segment
func update_segment():
	var rotation = $Wheel.rotation_degrees
	if rotation < 0:
		rotation += 360  # Normalize to positive values
	var segmentIndex = int(rotation / segmentSize) % 8  # 8 segments in total
	# The currentSegment goes counter-clockwise to give values starting above the arrow
	currentSegment = [200, -250, 300, 75, -150, -25, 100, -50][segmentIndex]

	# Calculate the final normalized rotation (0 to 360 degrees)
	var finalRotation = fmod(rotation, 360.0)

	# Check if the final rotation is within the specified range (61 to 73 degrees)
	if finalRotation >= 61.0 && finalRotation <= 73.0:
		currentSegment += Jackpotamount
		
	#Adds currentSegment to list
	list.append(currentSegment)
	
	#Plays Sound when the Wheel stops spinning
	if currentSegment != Jackpotamount:
		$AudioStreamPlayer.play()
		$BackButton.show()
	if currentSegment >= Jackpotamount:
		$AudioStreamPlayer2.play()
		$BackButton.show()
	# Print the current segment
	print("You Won!: ", currentSegment)

	hasPrinted = true  # Set the printing flag to prevent multiple prints
	label.text = "You Won!: $" + str(currentSegment)

	# Calculate the total winnings
	sum = 0
	for i in list:
		sum += i
	print("Your Total Winnings: $", sum)
	$SumLabel.text = "Your Total Winnings: $" + str(sum)

# Function to reset the wheel
func reset_wheel():
	if rotationSpeed == 0:
		spinning = false
		rotationSpeed = 0
		hasSpun = false  # Reset the spin flag
		hasPrinted = false  # Reset the printing flag
		
		var finalRotation = $Wheel.rotation_degrees
		print("Wheel stopped at ", finalRotation, " degrees")
		
		$Wheel.rotation_degrees = 0  # Reset the wheel's rotation
		label.text = ""

# Function to spin the wheel on button press
func _on_spin_button_pressed():
	_spin()

# Function to reset the wheel on button press
func _on_reset_button_pressed():
	reset_wheel()

# Function to return to the menu on button press
func _on_back_button_pressed():
	if rotationSpeed == 0:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")



