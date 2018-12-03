extends CanvasLayer

signal on_fade_in
signal on_fade_out

export var is_black : bool

var is_in_process

onready var animation : AnimationPlayer = $AnimationPlayer
onready var color_rect : ColorRect = $ColorRect

func _enter_tree():
	if is_black:
		get_node("ColorRect").color = Color.black

func fade_out():
	if not animation.is_playing():
		is_in_process = true
		animation.play("fade_out")

func fade_in():
	if not animation.is_playing():
		is_in_process = true
		animation.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		emit_signal("on_fade_out")
		is_in_process = false
	if anim_name == "fade_in":
		emit_signal("on_fade_in")
		is_in_process = false

func is_in_process():
	return is_in_process
