extends Node

var hand = []

var deck
var ui

func _ready():
	"""
	Gets references to UI and Deck nodes
	"""
	ui = get_node("/root/Node/UI")
	deck = get_node("/root/Node/DeckNode")
	
func add_card(card):
	"""
	Adds card to player hand
	
	:param: card - current card to add
	"""
	hand.append(card)

func get_hand_value():
	"""
	Gets the value of the players current hand,
	
	Calls card_value_to_int to convert all the values to integers,
	
	Checks if there are aces, if so adjust the value accordingly
	"""
	var value = 0
	var num_aces = 0
	
	for card in hand:
		var card_value = card_value_to_int(card["value"])
		if card_value == 11:
			num_aces += 1
		value += card_value
	
	# Handle aces
	while num_aces > 0 and value > 21:
		value -= 10
		num_aces -= 1
	
	return value

func card_value_to_int(value):
	"""
	Converts current value of card to an int
	
	:param: value - current value of card
	"""
	# Convert card value to integer using match (switch statement in python)
	match value:
		"J", "Q", "K":
			return 10
		"A":
			return 11
		_:
			return int(value)

# Add a function to handle the "Hit" button press
func hit_button_pressed():
	"""
	When the hit button is pressed deal another card to the player
	
	Uses the UI script to display the new player card and the new
	total value,
	
	Checks if player has busted, if so call the UI script enable_next_button
	"""
	# Get a card from the deck
	var card = deck.deal_card()
	
	# Add the card to the player's hand
	add_card(card)
	
	# Update UI to display the new card
	ui.display_new_card(card, 0)
	
	# Update UI to display the hand value
	ui.update_hand_value(get_hand_value(), 0)
	
	
	# Check if player busts
	if get_hand_value() > 21:
		print("BUST!")
		ui.hit_button.disabled = true
		ui.stand_button.disabled = true
		ui.enable_next_button()
		pass
	else:
		pass
		# Player's turn to play, continue
		
func player_reset():
	"""
	Clears the players hand
	"""
	hand.clear()
