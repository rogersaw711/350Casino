extends Node

var hand = []

var deck
var ui
var dealer
var game
var cC

func _ready():
	"""
	Gets references to UI and Deck nodes
	"""
	ui = get_node("/root/Node/UI")
	deck = get_node("/root/Node/DeckNode")
	dealer = get_node("/root/Node/DealerNode")
	game = get_node("/root/Node")
	cC = preload("res://scripts/coinCount.gd")
	
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
	ui.double_button.disabled = true
	# Get a card from the deck
	var card = deck.deal_card()
	add_card(card)
	ui.display_new_card(card, 0)
	ui.update_hand_value(get_hand_value(), 0)
	
	if get_hand_value() > 21:
		print("BUST!")
		ui.info_label.text = "Bust!\nDealer Wins"
		ui.hit_button.disabled = true
		ui.stand_button.disabled = true
		ui.enable_next_button()

func double_button_pressed():
	"""
	When the double button is pressed deal another card to the player
	
	Disable the playter from making any more moves,
	
	Uses the UI script to display the new player card and the new
	total value,
	
	Checks if player has busted, if so call the UI script enable_next_button
	"""
	ui.hit_button.disabled = true
	ui.stand_button.disabled = true
	ui.double_button.disabled = true
	# Get a card from the deck
	var card = deck.deal_card()
	add_card(card)
	ui.display_new_card(card, 0)
	ui.update_hand_value(get_hand_value(), 0)
	
	game.current_bet *= 2
	cC.addCoins((-game.current_bet / 2))
	ui.balance_label.text = "Balance: " + str(cC.getCoins())
	
	if get_hand_value() > 21:
		print("BUST!")
		ui.info_label.text = "Bust!\nDealer Wins"
		ui.balance_label.text = "Balance: " + str(cC.getCoins())
		ui.enable_next_button()
		return
	
	dealer.play_turn()
	
func player_reset():
	"""
	Clears the players hand
	"""
	hand.clear()
