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
var Jackpotamount = 2000



func _ready():
	set_process_input(true)
	label.text = ""
# Function to initiate spinning the wheel
"""
If the wheel is not currently spinning then spin the wheel at a random force 
between minrotationspeed and maxrotationspeed
"""
func _spin():
	if !spinning:
		spinning = true
		rotationSpeed = randf_range(minRotationSpeed, maxRotationSpeed)
		$BackButton.hide()
		print("rotationspeed: ", rotationSpeed)
		hasSpun = true
		hasPrinted = false

# Function to handle user input
"""
If the spacebar is pressed then spin or if the r key is hit then reset wheel
"""
func _input(event):
	if event.is_action_pressed("Spin"):
		_spin()

	# Check for the reset action
	if event.is_action_pressed("Reset") and rotationSpeed == 0:
		reset_wheel()

# Function to update the wheel's rotation
"""
If spinning slow down the wheels spin by the deceleration value * the delta
rotationSpeed = max(rotationSpeed, 0) makes sure the wheel does not
spin backwards when wheel stops

"""
func _process(delta):
	if spinning:
		rotationSpeed -= deceleration * delta
		rotationSpeed = max(rotationSpeed, 0)
		$Wheel.rotation_degrees += rotationSpeed * delta

		if rotationSpeed == 0 and hasSpun and !hasPrinted:
			update_segment()

# Function to determine the current winning segment
"""
Cuts the wheel up into segemnts using 8 45 degree segments
currentSegment is determined by value in a list Jackpot is determined if the 
arror is pointing at 61 and 73 degrees relative to the wheel.
Also plays sound when the current segement is updated or if the jackpot is hit
and it adds up all you winnings

"""
func update_segment():
	var rotation = $Wheel.rotation_degrees
	if rotation < 0:
		rotation += 360  # Normalize to positive values
	var segmentIndex = int(rotation / segmentSize) % 8  # 8 segments in total
	# The currentSegment goes counter-clockwise to give values starting above the arrow
	currentSegment = [-20, -500, 300, 75, -150, -25, 70, -70][segmentIndex]

	# Calculate the final normalized rotation (0 to 360 degrees)
	var finalRotation = fmod(rotation, 360.0)

	# Check if the final rotation is within the specified range (61 to 73 degrees)
	if finalRotation >= 61.04404 && finalRotation <= 73.2678:
		currentSegment = Jackpotamount
		
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

"""
If the rotation speed is 0 and the wheel is not spinning set the rotation speed
to zero and set the finalroation to the degress that the wheel is at 
"""
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



