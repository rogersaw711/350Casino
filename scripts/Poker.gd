extends Node

# Declaring some global variables for setting up the deck, hands, pot, buttons
var ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
var suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
var deck = []
var user_hand = []
var dealer_hand = []
var ai_hand = []
var player_chips = 500
var player_buy_in = 10
var ai_buy_in = 5
var bet_amount = 0
var pot_value = 0
var total_pot = 0
var count = 0
var not_in_hand = 0


@onready
var pokerbuttons = get_node("/root/Poker_table/Pre_deal")
@onready
var pokeroptions = get_node("/root/Poker_table/Poker_Options")
@onready
var postdeal = get_node("/root/Poker_table/Post_Deal")
@onready
var cards_ui = get_node("/root/Poker_table/Cards")
@onready
var winner_screen = get_node("/root/Poker_table/Winner_Screen")


# Called when the node enters the scene tree for the first time.
func _ready():
	pokeroptions.visible = false
	postdeal.visible = false
	winner_screen.visible = false
	generate_deck()
	shuffle_deck()

# Generates the deck of cards for the game(only done one time when the game is started up)
func generate_deck():
	for suit in suits:
		for rank in ranks:
			deck.append([suit] + [rank])

# Shuffles the deck using godots built in shuffle function
func shuffle_deck():
	deck.shuffle()

# Draws the initial cards to start the game, also logs the cards into the correct hands, has 10 chip buy in from player
func draw_card():
	if deck.size() > 0:
		if player_chips >= 10:
			if count == 0:
				$User_Card_1.texture = get_texture(deck[0])
				$User_Card_2.texture = get_texture(deck[2])
				user_hand.append(deck[0])
				user_hand.append(deck[2])
				ai_hand.append(deck[1])
				ai_hand.append(deck[3])
				dealer_hand.append(deck[4])
				dealer_hand.append(deck[5])
				dealer_hand.append(deck[6])
				
				player_chips = player_chips - player_buy_in
				total_pot = total_pot + player_buy_in + ai_buy_in
				
				bet_amount = 0
				count = count + 1
				get_node("Player_chips_value").set_text(str(player_chips))
				get_node("Pot_value").set_text(str(total_pot))
				get_node("Current_bet_value").set_text(str(bet_amount))
		
# Gets the image for the correct card when called 
func get_texture(card):
	if card[0] == "Hearts":
		var card_texture = load("res://cards/H_%s_card.png" % [card[1]])
		return card_texture
	elif card[0] == "Clubs":
		var card_texture = load("res://Cards/C_%s_card.png" % [card[1]])
		return card_texture
	elif card[0] == "Spades":
		var card_texture = load("res://Cards/S_%s_card.png" % [card[1]])
		return card_texture
	elif card[0] == "Diamonds":
		var card_texture = load("res://Cards/D_%s_card.png" % [card[1]])
		return card_texture

# Resets the game while keeping player chips the same but resetting all other values and changing visuals
func reset_game():
	$User_Card_1.texture = load("res://card back black.png")
	$AI_Card_1.texture = load("res://card back black.png")
	$User_Card_2.texture = load("res://card back black.png")
	$AI_Card_2.texture = load("res://card back black.png")
	$Dealer_Card_1.texture = load("res://card back black.png")
	$Dealer_Card_2.texture = load("res://card back black.png")
	$Dealer_Card_3.texture = load("res://card back black.png")
	$Dealer_Card_4.texture = load("res://card back black.png")
	$Dealer_Card_5.texture = load("res://card back black.png")
	postdeal.visible = false
	user_hand = []
	ai_hand = []
	dealer_hand = []
	pot_value = 0
	total_pot = 0
	if bet_amount > 0:
		player_chips = player_chips + bet_amount
	bet_amount = 10
	count = 0
	get_node("Pot_value").set_text(str(pot_value))
	get_node("Current_bet_value").set_text(str(bet_amount))
	get_node("Player_chips_value").set_text(str(player_chips))
	shuffle_deck()
	

# Royal Flush, best hand, includes a 10, Jack, Queen, King, and Ace of the same suit in order, finds whether or not a hand contains it
func _royal_flush(hand):
	var rank_values = {"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14}
	var num_hand = []
	
	for card in hand:
		var rank = card[1]
		num_hand.append(rank_values[rank])
	
	num_hand.sort()
	
	var is_straight = _straight(hand)
	var is_flush = _flush(hand)
	
	if is_straight and is_flush and num_hand[-1] == 14 and num_hand[-2] == 13 and num_hand[-3] == 12 and num_hand[-4] == 11 and num_hand[-5] == 10:
		return true
	
	return false
	
# Straight Flush, 5 Consecutive cards of the same suit, finds whether or not a hand contains it
func _straight_flush(hand):
	if _flush(hand) and _straight(hand):
		return true
	else:
		return false

# Four of a kind, 4 cards of the same rank in a hand, finds whether or not the hand contains it
func _four_kind(hand):
	
	var rank_count = []
	
	for card in hand:
		var rank = card[1]
		if rank_count.has(rank):
			rank_count[rank] += 1
		else:
			rank_count[rank] = 1
			
	for rank in rank_count:
		if rank_count[rank] == 4:
			return true
	
	return false
	
# Full House, 3 cards with same rank and 2 cards with different same rank(pair and three of a kind)
# Finds whether or not a hand contains it
func _full_house(hand):
	
	var rank_count = []
	var three_of_kind = false
	var two_kind = false
	
	for card in hand:
		var rank = card[1]
		if rank_count.has(rank):
			rank_count[rank] += 1
		else:
			rank_count[rank] = 1
	
	for rank in rank_count:
		if rank_count[rank] == 3:
			three_of_kind = true
		elif rank_count[rank] == 2:
			two_kind = true
			
	if three_of_kind and two_kind:
		return true
	
	return false
	
# Flush, Contains any 5 cards of the same suit, finds whether or not a hand contains it
func _flush(hand):
	
	var suit_count = {}
	
	for card in hand:
		var suit = card[0]
		if suit in suit_count:
			suit_count[suit] += 1
		else:
			suit_count[suit] = 1
	
	for suit in suit_count:
		if suit_count[suit] >= 5:
			return true
			
	return false
	
# Straight, Contains 5 consecutive cards of more than 1 suit, finds whether or not a hand contains it
func _straight(hand):
	var rank_values = {"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14}
	var num_hand = []
	
	for card in hand:
		var rank = card[1]
		num_hand.append(rank_values[rank])
	
	num_hand.sort()
	
	var straight_count = 1
	var prev_rank = num_hand[0]
	
	for i in range(1, num_hand.size()):
		var curr_rank = num_hand[i]
		if curr_rank == prev_rank + 1:
			straight_count += 1
			if straight_count >= 5:
				return true
		else:
			straight_count = 1
		prev_rank = curr_rank
		
	return false
	
# Three of a kind, Contains 3 cards of the same rank, finds whether or not a hand contains it
func _three_kind(hand):
	var rank_count = []
	
	for card in hand:
		var rank = card[1]
		if rank_count.has(rank):
			rank_count[rank] += 1
		else:
			rank_count[rank] = 1
			
	for rank in rank_count:
		if rank_count[rank] == 3:
			return true
	
	return false
	
# Two Pair, Contains 2 cards of one rank and 2 cards of another, finds whether or not a hand contains it
func _two_pair(hand):
	
	var rank_count = []
	
	for card in hand:
		var rank = card[1]
		if rank_count.has(rank):
			rank_count[rank] += 1
		else:
			rank_count[rank] = 1
	
	var pair_count = 0
	
	for rank in rank_count:
		if rank_count == 2:
			pair_count += 1
	
	if pair_count >= 2:
		return true
	else:
		return false
		
# One Pair, Contains 2 cards of one rank, finds whether or not a hand contains it
func _one_pair(hand):
	var rank_count = []
	
	for card in hand:
		var rank = card[1]
		if rank_count.has(rank):
			rank_count[rank] += 1
		else:
			rank_count[rank] = 1
	
	for rank in rank_count:
		if rank_count[rank] == 2:
			return true
	
	return false
			
# High Card, used to find the highest card in a given hand, returns the value of the card
func _high_card(hand):
	var rank_values = {"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14}
	
	var high_card = null
	var highest_rank = -1
	for card in hand:
		var rank = card[1]
		var rank_value = rank_values[rank]
		
		if rank_value > highest_rank:
			highest_rank = rank_value
			high_card = card
	
	return highest_rank

# Checks a hand to find the best possible cards that can be played in order to try and win the round, returns a value based on what hand is contained
func check_hand(hand, dealers_hand):
	var total_hand = hand + dealers_hand
	if _royal_flush(total_hand):
		return 10
	elif _straight_flush(total_hand):
		return 9
	elif _four_kind(total_hand):
		return 8
	elif _full_house(total_hand):
		return 7
	elif _flush(total_hand):
		return 6
	elif _straight(total_hand):
		return 5
	elif _three_kind(total_hand):
		return 4
	elif _two_pair(total_hand):
		return 3
	elif _one_pair(total_hand):
		return 2
	else:
		return 1

# Finds the winner of the game by comparing the hands of the computer and the player
func get_winner():
	var player_hand_value = check_hand(user_hand, dealer_hand)
	var ai_hand_value = check_hand(ai_hand, dealer_hand)
	pass

# Deal Cards Button, On press deal the cards and show the game actions
func _on_button_pressed():
	if player_chips >= 10:
		draw_card()
		postdeal.visible = true

# Rules Button, On press shows the rules of the game
func _on_options_menu_pressed():
	pokerbuttons.visible = false
	cards_ui.visible = false
	pokeroptions.visible = true
	if postdeal.visible == true:
		postdeal.visible = false
	
# Back Button inside the Rules Button, pressing brings back to game
func _on_back_button_pressed():
	cards_ui.visible = true
	pokerbuttons.visible = true
	pokeroptions.visible = false
	if user_hand.size() > 0:
		postdeal.visible = true
	
# Quit Button, brings player back to the main menu
func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")

# Used to minus the bet amount by 10 and update the values on screen
func _on_minus_10_button_pressed():
	if player_chips >= 0:
		if bet_amount >= 10:
			bet_amount = bet_amount - 10
			player_chips = player_chips + 10
	get_node("Player_chips_value").set_text(str(player_chips))
	get_node("Current_bet_value").set_text(str(bet_amount))

# Used to add 10 to the bet amount and update values on screen
func _on_plus_10_button_pressed():
	if player_chips >= 10:
		bet_amount = bet_amount + 10
		player_chips = player_chips - 10
	get_node("Player_chips_value").set_text(str(player_chips))
	get_node("Current_bet_value").set_text(str(bet_amount))

# Used to add 100 to the bet amount and update values on screen
func _on_plus_100_button_pressed():
	if player_chips >= 100:
		bet_amount = bet_amount + 100
		player_chips = player_chips - 100
	get_node("Player_chips_value").set_text(str(player_chips))
	get_node("Current_bet_value").set_text(str(bet_amount))

# Used to minus 100 from the bet amount and change values on screen
func _on_minus_100_button_pressed():
	if player_chips >= 0:
		if bet_amount >= 100:
			bet_amount = bet_amount - 100
			player_chips = player_chips + 100
	get_node("Player_chips_value").set_text(str(player_chips))
	get_node("Current_bet_value").set_text(str(bet_amount))

# Fold Button, will end round and reset game when pressed
func _on_fold_pressed():
	reset_game()
	
# Add 500 chips button, used for testing only until universal chip count added
func _on_add_chips_pressed():
	if user_hand.size() == 0:
		player_chips = player_chips + 500
		get_node("Player_chips_value").set_text(str(player_chips))

# Check Button, will reveal the dealers next card and not raise the pot unless all cards are revealed
# If all the cards are revealed will check the winner, display it, and distribute the pot
func _on_check_button_pressed():
	
	if count == 1:
		if bet_amount > 0:
			player_chips = player_chips + bet_amount
			bet_amount = 0
		else:
			bet_amount = 0
		$Dealer_Card_1.texture = get_texture(deck[4])
		$Dealer_Card_2.texture = get_texture(deck[5])
		$Dealer_Card_3.texture = get_texture(deck[6])
		get_node("Pot_value").set_text(str(total_pot))
		get_node("Current_bet_value").set_text(str(bet_amount))
		get_node("Player_chips_value").set_text(str(player_chips))
		count = count + 1
	elif count == 2:
		if bet_amount > 0:
			player_chips = player_chips + bet_amount
			bet_amount = 0
		else:
			bet_amount = 0
		get_node("Pot_value").set_text(str(total_pot))
		get_node("Current_bet_value").set_text(str(bet_amount))
		get_node("Player_chips_value").set_text(str(player_chips))
		$Dealer_Card_4.texture = get_texture(deck[7])
		dealer_hand.append(deck[7])
		count = count + 1
	elif count == 3:
		if bet_amount > 0:
			player_chips = player_chips + bet_amount
			bet_amount = 0
		else:
			bet_amount = 0
		get_node("Pot_value").set_text(str(total_pot))
		get_node("Current_bet_value").set_text(str(bet_amount))
		get_node("Player_chips_value").set_text(str(player_chips))
		$Dealer_Card_5.texture = get_texture(deck[8])
		dealer_hand.append(deck[7])
		count = count + 1

# Raise Button, will reveal the dealers next card and raise based on the amount you input unless all cards are revealed
# If all cards are revealed you can still do one last bet, but after it will check the winner, display it, and distribute the pot
func _on_raise_button_pressed():
	
	if count == 1:
		if bet_amount > 0:
			$Dealer_Card_1.texture = get_texture(deck[4])
			$Dealer_Card_2.texture = get_texture(deck[5])
			$Dealer_Card_3.texture = get_texture(deck[6])
			pot_value = (bet_amount * 2)
			total_pot = total_pot + pot_value
			get_node("Pot_value").set_text(str(total_pot))
			bet_amount = 0
			get_node("Current_bet_value").set_text(str(bet_amount))
			count = count + 1
	elif count == 2:
		if bet_amount > 0:
			pot_value = (bet_amount * 2)
			total_pot = total_pot + pot_value
			get_node("Pot_value").set_text(str(total_pot))
			bet_amount = 0
			get_node("Current_bet_value").set_text(str(bet_amount))
			$Dealer_Card_4.texture = get_texture(deck[7])
			dealer_hand.append(deck[7])
			count = count + 1
	elif count == 3:
		if bet_amount > 0:
			pot_value = (bet_amount * 2)
			total_pot = total_pot + pot_value
			get_node("Pot_value").set_text(str(total_pot))
			bet_amount = 0
			get_node("Current_bet_value").set_text(str(bet_amount))
			$Dealer_Card_5.texture = get_texture(deck[8])
			dealer_hand.append(deck[7])
			count = count + 1
	elif count == 4:
		if bet_amount > 0:
			pot_value = (bet_amount * 2)
			total_pot = total_pot + pot_value
			get_node("Pot_value").set_text(str(total_pot))
			bet_amount = 0
			get_node("Current_bet_value").set_text(str(bet_amount))
			count = count + 1
		
			#var winner = get_winner()
		
			#if winner == "player":
				#get_node("winner_text").set_text("YOU WIN")
			#elif winner == "computer":
				#get_node("winner_text").set_text("Computer Wins, You Lose, Better Luck Next Hand")
			
		
	
