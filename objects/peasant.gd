extends KinematicBody2D

var Gravity = 0

const Vjump = 500
const Acceleration : float = 1.0
 
var velocity = Vector2()
var max_velocity = 250

var is_jumping = false
var is_on_floor = true
var is_movement_locked = false

var is_found_player : bool = false
var player = null
var can_interact_with_player : bool = false

onready var dust : Particles2D = $dust_particles
onready var alert : Sprite = $alert
onready var alert_timer : Timer = $alert_timer

onready var hey : AudioStreamPlayer = $hey
onready var hey2 : AudioStreamPlayer = $hey2

onready var sprite : AnimatedSprite = $AnimatedSprite

func _ready():
	Gravity = Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY)
	add_to_group("peasants")

func _process(delta):
	var gravity = Vector2(0, 1) * Gravity
	
	var emit_dust = false
	
	if is_movement_locked:
		velocity.x = 0
		velocity.y = 0
		dust.emitting = emit_dust
		velocity += gravity
		return
	
	if is_on_floor:
		velocity.y = 0
		is_jumping = false
		if velocity.x > 10:
			emit_dust = true
		else:
			emit_dust = false
	
	dust.emitting = emit_dust
	
	if is_found_player:
		if player.global_position.x > global_position.x:
			if velocity.x < max_velocity:
				velocity.x += Acceleration
	else:
		seek_player()
	
	velocity += gravity

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP, false, true)
	
	is_on_floor = is_on_floor()

func seek_player():
	player = get_tree().get_nodes_in_group("player")[0] as Node2D
	if player.global_position.x > global_position.x:
		if rand_range(0, 1) > 0.5:
			hey.play()
		else:
			hey2.play()
		
		is_found_player = true
		
		alert.show()
		alert_timer.start()
		
		sprite.play("run")

func jump():
	velocity += Vector2(0, -1) * Vjump
	is_jumping = true

func lock_movement():
	is_movement_locked = true

func unlock_movement():
	is_movement_locked = false

func _on_alert_timer_timeout():
	alert.hide()
	can_interact_with_player = true

func _on_jump_detector_body_entered(body):
	jump()

func distance_to(object):
	return object.global_position.x - global_position.x

func _on_close_call_body_entered(body):
	if can_interact_with_player:
		# this is player
		body.extra_speedup()

func _on_player_collider_body_entered(body):
	if can_interact_with_player:
		body.game_over()
