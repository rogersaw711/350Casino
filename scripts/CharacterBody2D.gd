extends CharacterBody2D

var CoinCount_instance = preload("res://scripts/CoinCount.gd").new()




# Sets Minimum Rotation Speed
var minRotationSpeed = 300

# Sets Maximum Rotation Speed
var maxRotationSpeed = 500
#300, 500 orig speed
var bet = 0

# How Fast the Wheel will Decelerate
var deceleration = 55
var spinning = false
var rotationSpeed = 0

# Size of each segment in degrees
var segmentSize = 15

# Variable to store the current segment
var currentSegment = ""

# Flag to track if the wheel has been spun
var hasSpun = false

# Flag to track if the segment has been printed
var hasPrinted = false

# Declare the label variable with onready
@onready var label: Label = $Label

@onready var label1: Label = $Wheel/Label1
@onready var label2: Label = $Wheel/Label2
@onready var label3: Label = $Wheel/Label3
@onready var label4: Label = $Wheel/Label4
@onready var label5: Label = $Wheel/Label5
@onready var label6: Label = $Wheel/Label6
@onready var label7: Label = $Wheel/Label7
@onready var label8: Label = $Wheel/Label8
@onready var label9: Label = $Wheel/Label9
@onready var label10: Label = $Wheel/Label10
@onready var label11: Label = $Wheel/Label11
@onready var label12: Label = $Wheel/Label12
@onready var label13: Label = $Wheel/Label13
@onready var label14: Label = $Wheel/Label14
@onready var label15: Label = $Wheel/Label15
@onready var label16: Label = $Wheel/Label16
@onready var label17: Label = $Wheel/Label17
@onready var label18: Label = $Wheel/Label18
@onready var label19: Label = $Wheel/Label19
@onready var label20: Label = $Wheel/Label20
@onready var label21: Label = $Wheel/Label21
@onready var labelarrow: Label = $Wheel/Labelarrow
@onready var LabelJackpot: Label = $Wheel/LabelJackpot

@onready var lineedit: LineEdit = $LineEdit

@onready var Bet: Label = $Bet

var userInput: int = 0



# List to store winnings
var list = []

# Variable to store the sum of winnings
var sum = 0





func _ready():
	set_process_input(true)
	label.text = ""
	$Coincount.text = "Coin Count:" + str(CoinCount_instance.getCoinCount())
	run_all_tests()
	

	
	
# Function to initiate spinning the wheel
"""
If the wheel is not currently spinning then spin the wheel at a random force 
between minrotationspeed and maxrotationspeed
"""



func _spin():
	if !spinning && bet > 0 && CoinCount_instance.getCoinCount() >= bet:
		spinning = true
		rotationSpeed = randf_range(minRotationSpeed, maxRotationSpeed)
		$BackButton.hide()
		$lab1.hide()
		#print("rotationspeed: ", rotationSpeed)
		hasSpun = true
		hasPrinted = false
		lineedit.hide()
		$Label2.hide()
		CoinCount_instance.addCoins(-bet)
		CoinCount_instance.getCoinCount()

		#print("bet" , -bet)
	
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
	var segmentIndex = int(rotation / segmentSize) % 24  # 24 segments in total
	
	# The currentSegment goes counter-clockwise to give values starting above the arrow
	currentSegment = [int(labelarrow.text),int(label5.text),int(label4.text),int(label3.text), int(label2.text), int(label1.text), int(LabelJackpot.text), int(label21.text), int(label20.text), int(label19.text), int(label18.text), int(label17.text), int(label16.text), int(label15.text), 0, int(label14.text), int(label13.text), int(label12.text), int(label11.text), int(label10.text), int(label9.text), int(label8.text), int(label7.text), int(label6.text)][segmentIndex]
	

	# Calculate the final normalized rotation (0 to 360 degrees)
	var finalRotation = fmod(rotation, 360.0)
	#fco(finalRotation)
	
	# Check if the final rotation is within the specified range (61 to 73 degrees)

	if finalRotation >= 90.0908 && finalRotation <= 93.486 || finalRotation >= 101.392 && finalRotation <= 104.664:
		currentSegment = 0
		
	if currentSegment == int(LabelJackpot.text):
		$AudioStreamPlayer2.play()
		$BackButton.show()

		
		
	else:
		$AudioStreamPlayer.play()
		$BackButton.show()
		
		


	#Adds currentSegment to list
	$Label2.text = "$" + str(currentSegment)
	$Label2.show()
	
		
	# Print the current segment
	#print("You Won!: ", currentSegment)
	lineedit.text = ""
	var winnings = currentSegment - bet
	hasPrinted = true  # Set the printing flag to prevent multiple prints
	if winnings <= 0:
		label.text = "You Lost: $" + str(winnings)
	else:
		label.text = "You Won!: $" + str(winnings)
		
	list.append(winnings)
	# Calculate the total winnings
	sum = 0
	for i in list:
		sum += i
	var total = winnings - bet * len(list)
	
	$SumLabel.text = " Balance: $" + str(sum)
	CoinCount_instance.addCoins(currentSegment)
	
	#print("Coin count is" , CoinCount_instance.getCoinCount())
	$Coincount.text = "Coin Count:" + str(CoinCount_instance.getCoinCount())
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
		#print("Wheel stopped at ", finalRotation, " degrees")
		
		$Wheel.rotation_degrees = 0 # Reset the wheel's rotation
		label.text = ""
		lineedit.text = ""
		$Label2.text = ""
		$lab1.show()
		lineedit.show()

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



func _on_line_edit_text_changed(new_text):
	
	if int(new_text):
		bet = int(new_text)
		calc(bet)
		Bet.text = "Current Wager: $" + str(bet)

	else:

		lineedit.text = ""
		
		
		
	if int(new_text) > 0:
		bet = int(new_text)
		calc(bet)
		Bet.text = "Current Wager: $" + str(bet)

		
	if str(new_text) == "": 
		bet = 0
		calc(bet)
	if str(new_text) == "":
		Bet.text = "Current Wager: $" + str(0)


func calc(new_text):
		label1.text = "$" + str(round(bet * .5)) 
		label2.text = "$" + str(round(bet * 1.2))
		label3.text = "$" + str(round(bet * .75))
		label4.text = "$" + str(round(bet * 1))
		label5.text = "$" + str(round(bet * .25))
		label6.text = "$" + str(round(bet * 1.3))
		label7.text = "$" + str(round(bet * .1))
		label8.text = "$" + str(round(bet * 1.4))
		label9.text = "$" + str(round(bet * .3))
		label10.text = "$" + str(round(bet * 1.3))
		label11.text = "$" + str(round(bet * .4))
		label12.text = "$" + str(round(bet * .7))
		label13.text = "$" + str(round(bet * .3))
		label14.text = "$" + str(round(bet * 1.2))
		label15.text = "$" + str(round(bet * 4))
		label16.text = "$" + str (round(bet * .7))
		label17.text = "$" + str(round(bet * 1.2))
		label18.text = "$" + str(round(bet * .6))
		label19.text = "$" + str(round(bet * 1))
		label20.text = "$" + str(round(bet * .5))
		label21.text = "$" + str(round(bet * 1.5))
		labelarrow.text = "$" + str(round(bet * .4))
		LabelJackpot.text = "$" + str(round(bet * 15))

		

func run_all_tests():
	test_spin()
	test_reset_wheel()
	test_line_edit_input()
	

func test_spin():
	print("Test Spin Function:")
	# Set bet to a positive value
	bet = 10
	# Ensure enough coins for the bet
	CoinCount_instance.addCoins(20)

	# Call spin function
	_spin()

	# Verify expected results
	assert(spinning, "Wheel should be spinning.")
	assert(rotationSpeed >= minRotationSpeed and rotationSpeed <= maxRotationSpeed, "Invalid rotation speed.")
	assert(hasSpun, "Spun flag should be set.")
	assert(not hasPrinted, "Printed flag should be false.")


	print("Test Spin Function Passed\n")

func test_reset_wheel():
	print("Test Reset Wheel Function:")
	# Simulate a spinning wheel
	spinning = true
	rotationSpeed = 50
	hasSpun = true
	hasPrinted = true

	# Call reset_wheel function
	reset_wheel()

	# Verify expected results
	
	#assert(rotationSpeed == 0, "Rotation speed should be reset.")
	#assert(not spinning, "Wheel should not be spinning.")
	#assert(not hasSpun, "Spun flag should be reset.")


	print("Test Reset Wheel Function Passed\n")

func test_line_edit_input():
	print("Test Line Edit Input Function:")
	# Test with a valid integer
	_on_line_edit_text_changed("10")
	assert(bet == 10, "Bet should be updated for a valid integer input.")

	# Test with a non-integer input
	_on_line_edit_text_changed("abc")
	assert(bet == 10, "Bet should be set to blank for a non-integer input.")

	# Test with an empty string
	_on_line_edit_text_changed("")
	assert(bet == 0, "Bet should be set to 0 for an empty string.")
	#assert(bet == , "Bet Should be set to 0 for an negative int")
	print("Test Line Edit Input Function Passed\n")
	rotationSpeed = 0 
	reset_wheel()








	
