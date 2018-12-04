extends Sprite

var player = null
var is_found_player : bool = false
var is_spawned_peasant : bool = false

onready var peasant : Node2D = $peasant
onready var animation : AnimationPlayer = $AnimationPlayer

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] as Node2D
	peasant.global_scale.x = 1
	peasant.global_scale.y = 1

func _process(delta):
	if not is_found_player:
		seek_player()
	elif not is_spawned_peasant:
		is_spawned_peasant = true
		fade_in_peasant()

func seek_player():
	if player.global_position.x > global_position.x:
		is_found_player = true

func fade_in_peasant():
	animation.play("fade_in")