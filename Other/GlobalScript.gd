extends Node

var settings 

const texts_info = [
	['bananas are yellow', preload("res://Game/TextTT/text_to_translate_1.tscn"), [preload("res://Game/Samples/samlple_1_1.tscn")], 1, false],
	['one can not eat clouds', preload("res://Game/TextTT/text_to_translate_2.tscn"), [preload("res://Game/Samples/samlple_2_1.tscn"), preload("res://Game/Samples/samlple_2_2.tscn")], 1, false], 
	['2', preload("res://Game/TextTT/text_to_translate_3.tscn"), [preload("res://Game/Samples/samlple_3_1.tscn"), preload("res://Game/Samples/samlple_3_2.tscn")], 2, true],
	['1', preload("res://Game/TextTT/text_to_translate_4.tscn"), [preload("res://Game/Samples/samlple_4_1.tscn"), preload("res://Game/Samples/samlple_4_2.tscn")], 2, true]
]

const guess_options = [[], [],
	["a) let's destroy\n Earth", "b) don't eat cotton"],
	["a) soup is good", "b) snakes in water", "c) spaghetti sauce"]
]

var current_level = 0
var lives = 3

func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		DisplayServer.window_set_mode(4 * int(!DisplayServer.window_get_mode()))
		
	if !AudioController.get_child(3).is_playing():
		AudioController.get_child(3).play()
