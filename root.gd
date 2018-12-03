extends Node2D

var is_intro_started : bool = false
var is_intro_showed : bool = false

onready var player : Node2D = $player
onready var camera : Camera2D = $intro_camera
onready var animation : AnimationPlayer = $AnimationPlayer

func _ready():
	camera.transform.origin = player.transform.origin
	
	player.lock_movement()

func _process(delta):
	if not (is_intro_showed or is_intro_started)and  Input.is_action_pressed("ui_select"):
		start_intro()

func start_intro():
	animation.play("intro")
	is_intro_started = true

func _on_intro_animation_finished(anim_name):
	if anim_name == "intro":
		is_intro_showed = true
		camera.current = false
		player.unlock_movement()
