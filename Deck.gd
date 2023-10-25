extends Node

var deck = []

func _ready():
	init_deck()

func init_deck():
	# Create a deck of cards (52 cards)
	var suits = ["H", "D", "C", "S"]
	var values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
	
	for suit in suits:
		for value in values:
			var card = {"suit": suit, "value": value}
			deck.append(card)
	
	# Shuffle the deck
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func deal_card():
	# Remove and return a card from the deck
	return deck.pop_back() if deck.size() > 0 else null
