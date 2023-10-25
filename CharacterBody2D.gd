extends CharacterBody2D

var minRotationSpeed = 300
var maxRotationSpeed = 550
var deceleration = 55
var spinning = false
var rotationSpeed = 0

var segmentSize = 45  # Each segment is 45 degrees wide
var currentSegment = ""
var hasSpun = false  # Flag to track if the wheel has been spun
var hasPrinted = false  # Flag to track if the segment has been printed
# Declare the label variable with onready
@onready var label: Label = $Label
var list = []
var sum = 0
var Jackpotamount = 10000

func _ready():
	set_process_input(true)
	label.text = ""

func _spin():
	if !spinning:
		spinning = true
		rotationSpeed = randf_range(minRotationSpeed, maxRotationSpeed)
		print("rotationspeed: ", rotationSpeed)
		hasSpun = true
		hasPrinted = false

func _input(event):
	if event.is_action_pressed("Spin"):
		_spin()

	# Check for the reset action
	if event.is_action_pressed("Reset") and rotationSpeed == 0:
		reset_wheel() 

func _process(delta):
	if spinning:
		rotationSpeed -= deceleration * delta
		rotationSpeed = max(rotationSpeed, 0)

		$Wheel.rotation_degrees += rotationSpeed * delta

		if rotationSpeed == 0 and hasSpun and !hasPrinted:
			update_segment()

func update_segment():
	var rotation = $Wheel.rotation_degrees
	if rotation < 0:
		rotation += 360  # Normalize to positive values
	var segmentIndex = int(rotation / segmentSize) % 8  # 8 segments in total
	# The currentSegment goes counter-clockwise to give values starting at above the arrow
	currentSegment = [200, 100, 2000, 1500, 1000, 500, 400, 300][segmentIndex]

	# Calculate the final normalized rotation (0 to 360 degrees)
	var finalRotation = fmod(rotation, 360.0)

	# Check if the final rotation is within the specified range (61 to 73 degrees)
	if finalRotation >= 61.0 && finalRotation <= 73.0:
		currentSegment += Jackpotamount

	list.append(currentSegment)

	if currentSegment != Jackpotamount:
		$AudioStreamPlayer.play()
	if currentSegment >= Jackpotamount:
		$AudioStreamPlayer2.play()

	# Print the current segment
	print("You Won!: ", currentSegment)

	hasPrinted = true  # Set the printing flag to prevent multiple prints
	label.text = "You Won!: $" + str(currentSegment)
	print(list)

	# Reset the sum before calculating it again
	sum = 0

	for i in list:
		sum += i
	print("Your Total Winnings: $", sum)
	$SumLabel.text = "Your Total Winnings: $" + str(sum)


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


func _on_spin_button_pressed():
	_spin()

func _on_reset_button_pressed():
	reset_wheel()

func _on_area_2d_body_entered(body):
	print("working")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scripts/Menu.tscn")
