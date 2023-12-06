extends Node

var hand = []

var deck
var ui
var player
var cC
var game
	
func _ready():
	"""
	Gets references to UI, Deck, and Player nodes
	"""
	deck = get_node("/root/Node/DeckNode")
	ui = get_node("/root/Node/UI")
	player = get_node("/root/Node/PlayerNode")
	game = get_node("/root/Node")
	cC = preload("res://scripts/coinCount.gd")
	
func add_card(card):
	"""
	Adds a card to the dealers hand
	
	:param: card - current card to add
	"""
	hand.append(card)

func get_hand_value():
	"""
	Gets the value of the dealers current hand,
	
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
	# Convert card value to integer using match (switch statment in python)
	match value:
		"J", "Q", "K":
			return 10
		"A":
			return 11
		_:
			return int(value)

func play_turn():
	"""
	Simple AI to allow the dealer to play,
	
	Dealer draws to 17, if busts break the loop
	
	Checks win conditions and calls there respective functions
	"""
	ui.update_hand_value(get_hand_value(), 1)
	ui.back_card.visible = false
	await get_tree().create_timer(0.5).timeout
	ui.hit_button.disabled = true
	ui.stand_button.disabled = true
	ui.double_button.disabled = true
	while get_hand_value() < 17:
		var card = deck.deal_card()
		add_card(card)
		ui.display_new_card(card, 1)
		ui.update_hand_value(get_hand_value(), 1)
		if get_hand_value() > 21:
			break
		await get_tree().create_timer(0.5).timeout
		
	# Determine the winner and call appropriate function
	if get_hand_value() > 21:
		dealer_bust()
	elif get_hand_value() > player.get_hand_value():
		lose()
	elif get_hand_value() == player.get_hand_value():
		push()
	elif get_hand_value() < player.get_hand_value():
		win()
		
	ui.enable_next_button()

#(TODO handle chip removing/adding later)#
func dealer_bust():
	print("Dealer Busts, Player Wins!")
	ui.info_label.text = "Dealer Busts,\nPlayer Wins!"
	cC.addCoins(game.current_bet * 2)
	
func win():
	print("Player Wins!")
	ui.info_label.text = "Player Wins!"
	cC.addCoins(game.current_bet * 2)
	
func lose():
	print("Dealer Wins!")
	ui.info_label.text = "Dealer Wins!"
	
func push():
	print("Push!")
	ui.info_label.text = "Push!"
	cC.addCoins(game.current_bet)
	
func dealer_reset():
	hand.clear()

