extends Node2D

var iconTextures : Array
var currentIconIndices : Array

var leftColumn
var middleColumn
var rightColumn
var startButton
var coinCount
var coinDisplay

func _ready():
	leftColumn = $leftColumn
	middleColumn = $middleColumn
	rightColumn = $rightColumn
	startButton = $startButton
	coinCount = get_node("/root/CoinCount")
	coinDisplay = $coinDisplay
	coinDisplay.text = "Coin Count: " + str(coinCount.coinCount)
	iconTextures = [
		preload("res://assets/cherry.png"),
		preload("res://assets/seven.png"),
		preload("res://assets/bell.png"),
		preload("res://assets/bar.png"),
		# Add more icon textures here
	]

	currentIconIndices = [0, 0, 0]

func _startSpinning():
	"""
	Starts the spinning of the slot columns, though this removes 50 chips from the count.
	The user cannot play if they do not have 50 chips to bet.
	This selects a random number for each of the three columns.
	These random numbers are displayed as pre-determined icons, as shown in the iconTexture variable.
	The numbers are then compared to determine what the payout is, which are listed here:
		One cherry - 25 chips
		Two Cherry - 50 Chips
		Three cherry - 75 Chips
		Two Bells - 100 Chips
		Three Bells - 150 Chips
		Three Sevens - 200 Chips
		Bars are worth nothing, regardless of how many there are.
	"""
	leftSpinning = true
	middleSpinning = true
	rightSpinning = true
	if coinCount.coinCount < 50:
		return
	coinCount.addCoins(-50)
	# Start the Timer to control the animation
	# Initialize a list to store the selected icon index for each column
	var selectedIcons = []
	var cherryCount = 0
	var bellCount = 0
	var sevenCount = 0

	for i in range(3):
		# Randomly select an icon index for each column
		var iconIndex = randi() % iconTextures.size()
		selectedIcons.append(iconIndex)
		if iconIndex == 0:
			cherryCount += 1
		if iconIndex == 1:
			sevenCount += 1
		if iconIndex == 2:
			bellCount += 1
		# Initialize the column with the selected icon
		match i:
			0:
				leftColumn.texture = iconTextures[iconIndex]
			1:
				middleColumn.texture = iconTextures[iconIndex]
			2:
				rightColumn.texture = iconTextures[iconIndex]

	# Pass the selected icon indices to the Timer's `userdata` property
	if bellCount == 2: 
		coinCount.addCoins(100)
	if bellCount == 3:
		coinCount.addCoins(150)
	if sevenCount == 3:
		coinCount.addCoins(200)
	if cherryCount == 1:
		coinCount.addCoins(25)
	if cherryCount == 2:
		coinCount.addCoins(50)
	if cherryCount == 3:
		coinCount.addCoins(75)
	
	coinDisplay.text = "Coin Count: " + str(coinCount.coinCount)

func _run():
	var totalTests = 0
	var testSuccessCount = 0
	if Engine.is_editor_hint():
		
