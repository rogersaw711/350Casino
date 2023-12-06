extends Node

var player
var dealer
var deck
var ui

# TODO make bet price be able to be chosen by the player [50, 100, 250, 500, 1000, 2500]
var current_bet

var cC

func _ready():
	"""
	Gets references to Player, Dealer, Deck, and UI nodes
	"""
	# Get references to Player, Dealer, and Deck nodes
	player = get_node("PlayerNode")
	dealer = get_node("DealerNode")
	deck = get_node("DeckNode")
	ui = get_node("UI")
	cC = preload("res://scripts/coinCount.gd")
	ui.back_card.visible = false
	current_bet = 0
	
func _placeing_bets(bet):
	ui.bet_amount_label.modulate = Color(1, 1, 1)
	match bet:
		50:
			current_bet = 50
		100:
			current_bet = 100
		250:
			current_bet = 250
		500:
			current_bet = 500
		1000:
			current_bet = 1000
		2500:
			current_bet = 2500
	
	ui.bet_amount_label.text = "Bet Amount: " + str(current_bet)
	ui.deal_button.disabled = false
	
func _on_deal_button_pressed():
	"""
	Initializes a new deck and shuffles it,
	
	Draws 2 cards (2 for player, and 2 for dealer),
	
	Uses the UI script to display the new player and dealer cards and there 
	total value,
	
	Checks if player has a BlackJack, if so award the player accourdingly, 
	otherwise enable/disable the required buttons and continue with the game
	"""
	# Initialize a new deck and shuffle it
	if cC.coinCount < current_bet:
		ui.bet_amount_label.text = "Don't have that many chips!"
		ui.bet_amount_label.modulate = Color(1, 0, 0)
		return
		
	deck.init_deck()
	
	cC.addCoins(-current_bet)
	ui.balance_label.text = "Balance: " + str(cC.getCoins())
	
	ui.deal_button.disabled = true
	
	var card
	ui.bet_box.visible = false
	ui.quit_button.disabled = true
	# Deal initial cards and update UI
	for i in range(2):
		card = deck.deal_card()
		player.add_card(card)
		ui.display_new_card(card, 0)
		ui.update_hand_value(player.get_hand_value(), 0)
		await get_tree().create_timer(0.5).timeout
		
	for i in range(2):
		card = deck.deal_card()
		dealer.add_card(card)
		ui.display_new_card(card, 1)
		if i == 1:
			ui.back_card.visible = true
		if i == 0:
			ui.update_hand_value(dealer.get_hand_value(), 1)
		await get_tree().create_timer(0.5).timeout
		
	ui.back_card.visible = true
	
	# Check for player Blackjack
	if player.get_hand_value() == 21:
		print("BlackJack!!")
		ui.info_label.text = "BlackJack!\nPlayer Wins"
		cC.addCoins(current_bet * 2.5)
		ui.enable_next_button()
	else:
		# Enable Hit and Stand buttons in the UI
		ui.hit_button.disabled = false
		ui.stand_button.disabled = false
		ui.double_button.disabled = false
