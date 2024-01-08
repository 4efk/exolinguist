extends Node2D

const surplus_characters = [".", "?", "!", "'", '"', ",", "\n"]

@onready var answer_field = $CanvasLayer/TextEdit
@onready var lives_container = $CanvasLayer/TopUIElements/LivesContainer
@onready var level_label = $CanvasLayer/TopUIElements/LevelLabel
@onready var table_elements = $CanvasLayer/TableElements
@onready var options_container = $CanvasLayer/OptionsContainer
@onready var option_button_1 = $CanvasLayer/OptionsContainer/OptionButton1
@onready var option_button_2 = $CanvasLayer/OptionsContainer/OptionButton2
@onready var option_button_3 = $CanvasLayer/OptionsContainer/OptionButton3
@onready var papers = $CanvasLayer/TableElements/Papers
@onready var heart_break_sound = $HeartBreakSound
@onready var correct_sounds = $CorrectSounds
@onready var transitions = $CanvasLayer/Transitions

var button_to_menu = false

func _ready():
	#$CanvasLayer/TransitionRect.hide()
	if GlobalScript.current_level == 0:
		transitions.play("fade_out")
		AudioController.get_child(0).play()
	
	level_label.text = 'text ' + str(GlobalScript.current_level+1) + ', alien race ' + str(GlobalScript.texts_info[GlobalScript.current_level][3])
	papers.add_child(GlobalScript.texts_info[GlobalScript.current_level][1].instantiate())
	for sample in GlobalScript.texts_info[GlobalScript.current_level][2]:
		papers.add_child(sample.instantiate())
	
	if GlobalScript.texts_info[GlobalScript.current_level][4]:
		answer_field.hide()
		options_container.show()
		for options in GlobalScript.guess_options[GlobalScript.current_level]:
			options_container.get_child(GlobalScript.guess_options[GlobalScript.current_level].find(options)).text = GlobalScript.guess_options[GlobalScript.current_level][GlobalScript.guess_options[GlobalScript.current_level].find(options)]
	answer_field.grab_focus()
	
	for i in range(3 - GlobalScript.lives):
		lives_container.get_child(2-i+3).hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_confirm_button_pressed()

func confirm_choice(guess=null):
	if GlobalScript.lives <= 0:
		return
	var guessed_text = answer_field.text.to_lower()
	if guess:
		guessed_text = guess
	for char in surplus_characters:
		guessed_text = guessed_text.replace(char, '')

	if guessed_text == GlobalScript.texts_info[GlobalScript.current_level][0]:
		GlobalScript.current_level += 1
		AudioController.get_child(0).play()
		AudioController.get_child(2).play()
		if GlobalScript.current_level == len(GlobalScript.texts_info):
			#get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
			transitions.play("fade_in")
			return
		get_tree().change_scene_to_file("res://Game/game.tscn")
	else:
		GlobalScript.lives -= 1
		if GlobalScript.lives >=  0:
			lives_container.get_child(GlobalScript.lives).play('break_heart')
			heart_break_sound.play()

func _on_confirm_button_pressed():
	confirm_choice()

func _on_texture_button_pressed():
	#get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	transitions.play("fade_in")
	button_to_menu = true

func _on_option_button_1_pressed():
	answer_field.text = '1'
	option_button_2.button_pressed = false
	option_button_3.button_pressed = false

func _on_option_button_2_pressed():
	answer_field.text = '2'
	option_button_1.button_pressed = false
	option_button_3.button_pressed = false

func _on_option_button_3_pressed():
	answer_field.text = '3'
	option_button_1.button_pressed = false
	option_button_2.button_pressed = false

func _on_animation_player_3_animation_finished(anim_name):
	#print(GlobalScript.lives)
	if anim_name == 'break_heart':
		transitions.play("fade_in")

func _on_text_edit_text_changed():
	#print(answer_field.get_line_wrapped_text(0))
	#if answer_field.get_line_wrap_count(0) > 5:
		#answer_field.text = answer_field.text.erase(len(answer_field.text) - 1)
	var caret_pos = [answer_field.get_caret_column(), answer_field.get_caret_wrap_index()]
	answer_field.text = answer_field.text.replace("\n", "")
	
	var text = ''
	for line in range(len(answer_field.get_line_wrapped_text(0))):
		if line < 6:
			text += answer_field.get_line_wrapped_text(0)[line]
	
	if answer_field.get_line_wrap_count(0) > 5:
		answer_field.text = text
	answer_field.set_caret_column(caret_pos[0])
	#answer_field.set_caret_line(caret_pos[1])
	
func _on_transitions_animation_finished(anim_name):
	if anim_name == 'fade_in' and !button_to_menu:
		get_tree().change_scene_to_file("res://Game/earth_anims.tscn")
	elif button_to_menu:
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
