@tool
extends EditorScript

func _run():
	var deck = test_init_deck()
	var hand = []
	var total_tests = 9
	var test_success_count = 0
	if Engine.is_editor_hint():
		# Make sure that a deck of length 52 was made
		if len(deck) == 52:
			print("Finished...")
			test_success_count += 1
		# If the first element is different, indicating that the deck was shuffled
		if deck[0] != test_shuffle_deck(deck)[0]:
			print("Finished...")
			test_success_count += 1
		# Check if card is removed from deck when deal_card is called
		test_deal_card(deck)
		if len(deck) == 51:
			print("Finished...")
			test_success_count += 1
			# If a bet of 500 isa placed, it is properly assigned to current_bet
		if test_placeing_bets(500) == 500:
			print("Finished...")
			test_success_count += 1
		
		test_add_card(hand, {"suit": "K", "value": 10})
		if hand[0] == {"suit": "K", "value": 10}:
			print("Finished...")
			test_success_count += 1
		if test_get_hand_value(hand) == 10:
			print("Finished...")
			test_success_count += 1
		if test_card_value_to_int("A") == 11:
			print("Finished...")
			test_success_count += 1
		if len(test_player_reset(hand)) == 0:
			print("Finished...")
			test_success_count += 1
		
		if len(test_dealer_reset(hand)) == 0:
			print("Finished...")
			test_success_count += 1
		
		if test_success_count == total_tests:
			print("\nAll Tests Passed!!!")
# -----------------------------------------DECK--------------------------------------
func test_init_deck():
# Create a deck of cards (52 cards)
	var deck = []
	var suits = ["H", "D", "C", "S"]
	var values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
	
	for suit in suits:
		for value in values:
			var card = {"suit": suit, "value": value}
			deck.append(card)
	return deck

func test_shuffle_deck(deck):
	deck.shuffle()
	return deck

func test_deal_card(deck):
	return deck.pop_back() if deck.size() > 0 else null

# -----------------------------------------GAME--------------------------------------

func test_placeing_bets(bet):
	var current_bet = 0
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
	return current_bet

# -----------------------------------------PLAYER/DEALER--------------------------------------
# Adding card to hand, works the same in both player and dealer
func test_add_card(hand, card):
	hand.append(card)
	return hand

# Finds the total value of all cards in current hand, works the same in both player and dealer
func test_get_hand_value(hand):
	"""
	Gets the value of the players current hand,
	
	Calls card_value_to_int to convert all the values to integers,
	
	Checks if there are aces, if so adjust the value accordingly
	"""
	var value = 0
	var num_aces = 0
	
	for card in hand:
		var card_value = test_card_value_to_int(card["value"])
		if card_value == 11:
			num_aces += 1
		value += card_value
	
	# Handle aces
	while num_aces > 0 and value > 21:
		value -= 10
		num_aces -= 1
	
	return value

# Convert a value on a card to be an integer (e.g. "K" == 10), works the same in both player and dealer
func test_card_value_to_int(value):
	"""
	Converts current value of card to an int
	
	:param: value - current value of card
	"""
	# Convert card value to integer using match ('switch statement')
	match value:
		"J", "Q", "K":
			return 10
		"A":
			return 11
		_:
			return int(value)

# Resets the players hand
func test_player_reset(hand):
	hand.clear()
	return hand

# Resets the dealers hand
func test_dealer_reset(hand):
	hand.clear()
	return hand
