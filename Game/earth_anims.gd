extends Node2D

@onready var earth_animation = $AnimatedSprite2D
@onready var transitions = $CanvasLayer/Transitions

func _ready():
	if GlobalScript.lives <= 0:
		earth_animation.play("Explode")
	else:
		earth_animation.play("Ok")
		
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	AudioController.get_child(3).stop()


func _on_animated_sprite_2d_animation_finished():
	pass


func _on_confirm_button_pressed():
	transitions.play("fade_in")


func _on_transitions_animation_finished(anim_name):
	if anim_name == 'fade_in':
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	pass


func _on_timer_timeout():
	$CanvasLayer/ConfirmButton.show()
	if GlobalScript.lives <= 0:
		$Explode.play()
	else:
		$CanvasLayer/Label.show()
