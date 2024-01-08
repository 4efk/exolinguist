extends Node2D

@onready var transitions = $CanvasLayer/Transitions

func _ready():
	#$CanvasLayer/TransitionRect.hide()
	pass

func _on_button_pressed():
	GlobalScript.lives = 3
	GlobalScript.current_level = 0
	transitions.play("fade_in")

func _on_transitions_animation_finished(anim_name):
	if anim_name == 'fade_in':
		get_tree().change_scene_to_file("res://Game/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
