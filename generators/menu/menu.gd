extends Node2D

var is_intro_done: bool = false

func _ready():
	if game_state.is_intro_done:
		is_intro_done = true
		$Camera2D.current = false
	else:
		$AnimationPlayer.play("intro")

func is_intro_done():
	return is_intro_done

func _on_AnimationPlayer_animation_finished(anim_name):
	is_intro_done = true
	game_state.is_intro_done = true
	$Camera2D.current = false
