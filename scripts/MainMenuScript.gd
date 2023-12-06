'''
To work as intended all scenes must be in a "scenes" folder child of "res://"

Attach script to the 'MainMenu' node in 'Menu' Scene
'''

extends Control

# initiate all important nodes onready (on pressing 'run')
@onready
var mainmenu = get_node("/root/Menu/MainMenu")
@onready
var optionsmenu = get_node("/root/Menu/Options")
@onready
var gameselect = get_node("/root/Menu/GameSelection")

func _ready():
	# Initialize buttons
	optionsmenu.visible = false
	gameselect.visible = false

func _on_start_button_pressed():
	# Hide
	mainmenu.visible = false
	optionsmenu.visible = false
	#Show
	gameselect.visible = true
	
func _on_options_button_pressed():
	# Hide
	mainmenu.visible = false
	# Show
	optionsmenu.visible = true

func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_back_button_pressed():
	# Hide
	optionsmenu.visible = false
	gameselect.visible = false
	# Show
	mainmenu.visible = true

# takes in index of selected option in dropdown (0, 1, 2, ...)
func _on_option_button_item_selected(index):
	# simular to python 'switch'
	match index:
		0:
			# get_tree().change_scene_to_file("res://scenes/name_of_your_game_scene")
			get_tree().change_scene_to_file("res://scenes/wheel.tscn")
		1:
			# get_tree().change_scene_to_file("res://scenes/name_of_your_game_scene")
			pass
		2:
			get_tree().change_scene_to_file("res://scenes/Test.tscn")
