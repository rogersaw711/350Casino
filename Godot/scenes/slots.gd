extends Node2D

var iconTextures : Array
var currentIconIndices : Array
var leftSpinning : bool = false
var middleSpinning: bool = false
var rightSpinning: bool = false
var spinDuration : float = 1.0

var leftColumn
var middleColumn
var rightColumn
var leftButton
var middleButton
var rightButton
var startButton

func _ready():
	leftColumn = $leftColumn
	middleColumn = $middleColumn
	rightColumn = $rightColumn
	leftButton = $leftButton
	middleButton = $middleButton
	rightButton = $rightButton
	startButton = $startButton

	iconTextures = [
		preload("res://assets/seven.png"),
		preload("res://assets/bell.jpg"),
		preload("res://assets/cherry.png"),
		# Add more icon textures here
	]

	currentIconIndices = [0, 0, 0]

func _stopColumn(column_index):
	var column = column_index
	var index = column_index

	if column_index == 0:
		if leftSpinning:
			leftColumn.texture = iconTextures[currentIconIndices[index]]
			currentIconIndices[index] += 1

		if currentIconIndices[index] >= iconTextures.size():
			currentIconIndices[index] = 0
	if column_index == 1:
		if leftSpinning:
			middleColumn.texture = iconTextures[currentIconIndices[index]]
			currentIconIndices[index] += 1

		if currentIconIndices[index] >= iconTextures.size():
			currentIconIndices[index] = 0
	if column_index == 2:
		if leftSpinning:
			rightColumn.texture = iconTextures[currentIconIndices[index]]
			currentIconIndices[index] += 1

		if currentIconIndices[index] >= iconTextures.size():
			currentIconIndices[index] = 0
	

func _startSpinning():
	leftSpinning = true
	middleSpinning = true
	rightSpinning = true

	# Start the Timer to control the animation
	$SpinningTimer.start()
	# Initialize a list to store the selected icon index for each column
	var selectedIcons = []

	for i in range(3):
		# Randomly select an icon index for each column
		var iconIndex = randi() % iconTextures.size()
		selectedIcons.append(iconIndex)

		# Initialize the column with the selected icon
		match i:
			0:
				leftColumn.texture = iconTextures[iconIndex]
			1:
				middleColumn.texture = iconTextures[iconIndex]
			2:
				rightColumn.texture = iconTextures[iconIndex]

	# Pass the selected icon indices to the Timer's `userdata` property
	$SpinningTimer.set("userdata", selectedIcons)

func _stopSpinning():
	$SpinningTimer.stop()
	#spinning = false

func _on_Timer_timeout():
	for i in range(3):
		var column
		var index

		match i:
			0:
				column = leftColumn
				index = 0
			1:
				column = middleColumn
				index = 1
			2:
				column = rightColumn
				index = 2

		column.texture = iconTextures[currentIconIndices[index]]
		currentIconIndices[index] += 1

		if currentIconIndices[index] >= iconTextures.size():
			currentIconIndices[index] = 0



func _on_left_button_pressed():
	_stopColumn(0)


func _on_middle_button_pressed():
	_stopColumn(1)


func _on_right_button_pressed():
	_stopColumn(2)
