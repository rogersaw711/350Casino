extends Control

var p_position_x
var p_position_y
var d_position_x
var d_position_y

var player
var dealer

var hit_button: Button
var stand_button: Button
var deal_button: Button
var next_button: Button
var quit_button: Button

var info_label: Label

var back_card

var card_textures = {
	"H_2": load("res://cards/H_2_card.png"),
	"H_3": load("res://cards/H_3_card.png"),
	"H_4": load("res://cards/H_4_card.png"),
	"H_5": load("res://cards/H_5_card.png"),
	"H_6": load("res://cards/H_6_card.png"),
	"H_7": load("res://cards/H_7_card.png"),
	"H_8": load("res://cards/H_8_card.png"),
	"H_9": load("res://cards/H_9_card.png"),
	"H_10": load("res://cards/H_10_card.png"),
	"H_A": load("res://cards/H_A_card.png"),
	"H_J": load("res://cards/H_J_card.png"),
	"H_K": load("res://cards/H_K_card.png"),
	"H_Q": load("res://cards/H_Q_card.png"),
	"C_2": load("res://cards/C_2_card.png"),
	"C_3": load("res://cards/C_3_card.png"),
	"C_4": load("res://cards/C_4_card.png"),
	"C_5": load("res://cards/C_5_card.png"),
	"C_6": load("res://cards/C_6_card.png"),
	"C_7": load("res://cards/C_7_card.png"),
	"C_8": load("res://cards/C_8_card.png"),
	"C_9": load("res://cards/C_9_card.png"),
	"C_10": load("res://cards/C_10_card.png"),
	"C_A": load("res://cards/C_A_card.png"),
	"C_J": load("res://cards/C_J_card.png"),
	"C_K": load("res://cards/C_K_card.png"),
	"C_Q": load("res://cards/C_Q_card.png"),
	"S_2": load("res://cards/S_2_card.png"),
	"S_3": load("res://cards/S_3_card.png"),
	"S_4": load("res://cards/S_4_card.png"),
	"S_5": load("res://cards/S_5_card.png"),
	"S_6": load("res://cards/S_6_card.png"),
	"S_7": load("res://cards/S_7_card.png"),
	"S_8": load("res://cards/S_8_card.png"),
	"S_9": load("res://cards/S_9_card.png"),
	"S_10": load("res://cards/S_10_card.png"),
	"S_A": load("res://cards/S_A_card.png"),
	"S_J": load("res://cards/S_J_card.png"),
	"S_K": load("res://cards/S_K_card.png"),
	"S_Q": load("res://cards/S_Q_card.png"),
	"D_2": load("res://cards/D_2_card.png"),
	"D_3": load("res://cards/D_3_card.png"),
	"D_4": load("res://cards/D_4_card.png"),
	"D_5": load("res://cards/D_5_card.png"),
	"D_6": load("res://cards/D_6_card.png"),
	"D_7": load("res://cards/D_7_card.png"),
	"D_8": load("res://cards/D_8_card.png"),
	"D_9": load("res://cards/D_9_card.png"),
	"D_10": load("res://cards/D_10_card.png"),
	"D_A": load("res://cards/D_A_card.png"),
	"D_J": load("res://cards/D_J_card.png"),
	"D_K": load("res://cards/D_K_card.png"),
	"D_Q": load("res://cards/D_Q_card.png"),
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	Sets default positions for the cards to be displayed,
	
	Gets references to the required Button nodes, as well as the 
	Player and Dealer nodes,
	
	Enables/diables required buttons
	"""
	p_position_x = 500
	p_position_y = 400
	d_position_x = 500
	d_position_y = 200
	hit_button = $HitButton
	stand_button = $StandButton
	deal_button = $DealButton
	next_button = $NextButton
	quit_button = $QuitButton
	info_label = $InfoLabel
	
	player = get_node("/root/Node/PlayerNode")
	dealer = get_node("/root/Node/DealerNode")
	
	back_card = get_node("/root/Node/back_card")
	
	hit_button.disabled = true
	stand_button.disabled = true
	next_button.disabled = true
	

# This function displays a card on the screen.
func display_new_card(card, actor: int):
	"""
	Creates new sprite for card, assignes the sprite the correct texture in
	card_textures,
	
	Adds the card as a child to the UI node,
	
	Positions the cards where they belong depending on if they are player (actor = 0)
	or dealer (actor = 1) cards
	
	:param: card - current card being passed in
	:param: actor - current actor (player(0) or dealer(1))
	"""
	var card_sprite = Sprite2D.new()  # Create a new Sprite node
	var card_texture = load_card_texture(card)  # Load the card's texture
	
	card_sprite.texture = card_texture  # Set the texture of the sprite
	add_child(card_sprite)  # Add the sprite as a child of the UI node
	
	# Position the card sprite (you might want to adjust these coordinates)
	if actor == 0:
		card_sprite.position.x = p_position_x
		card_sprite.position.y = p_position_y
		p_position_x += 20
	elif actor == 1:
		card_sprite.position.x = d_position_x
		card_sprite.position.y = d_position_y
		d_position_x += 20
	
# This function updates the displayed hand value on the screen.
func update_hand_value(value, actor: int):
	"""
	Updates the hand value depending on the passed in value and actor
	
	:param: value - current hand value
	:param: actor - current actor (player(0) or dealer(1))
	"""
	if actor == 0:
		var p_label = get_node("PlayerLabel")
		p_label.text = "Hand Value: " + str(value)
	elif actor == 1:
		var d_label = get_node("DealerLabel")
		d_label.text = "Dealer Value: " + str(value)
	
func load_card_texture(card_name):
	"""
	Responsible for giving the correct texture to the card
	
	:param: card_name - card passed in to get its texture applied
	"""
	card_name = card_name["suit"] + "_" + card_name["value"]
	return card_textures[card_name]
	
func _on_next_button_pressed():
	"""
	Calls the reset function to reset the game
	"""
	reset()
	
func enable_next_button():
	"""
	Allows external script to enable the next_button
	"""
	next_button.disabled = false
	
func reset():
	"""
	Resets all the values necessary to reset the game to base state, allowing
	the player to continue to play hands
	
	Calls player_reset in the player script, dealer_reset in the dealer script,
	
	Removes all 2DSprite children from UI node, in turn removing all cards from
	the screen
	"""
	p_position_x = 500
	p_position_y = 400
	d_position_x = 500
	d_position_y = 200
	deal_button.disabled = false
	quit_button.disabled = false
	hit_button.disabled = true
	stand_button.disabled = true
	next_button.disabled = true
	back_card.visible = false
	info_label.text = ""
	player.player_reset()
	dealer.dealer_reset()
	update_hand_value(player.get_hand_value(), 0)
	update_hand_value(dealer.get_hand_value(), 1)
	for child in get_children():
		if child is Sprite2D:
			print("Deleted Child!")
			child.queue_free()
	
