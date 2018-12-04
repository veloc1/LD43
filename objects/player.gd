extends KinematicBody2D

signal jump
signal speedup
signal game_over

var Gravity = 0

const Vjump = 500
const Acceleration : float = 1.0
const SpeedUp : float = 2.0
const ExtraSpeedUp : float = 5.0

const MousePositionToSlowDown : float = 60.0
const SpeedFromMousePositionCoef : float = 3.0

var velocity = Vector2()
var base_max_velocity = 200
var max_velocity = 200

var is_jumping = false
var is_on_floor = true
var is_movement_locked = false
var is_idle = true

var close_calls = 3

var camera_offset : Vector2 = Vector2()

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : AnimatedSprite = $Sprite
onready var camera : Camera2D = $Camera2D
onready var dust : Particles2D = $dust_particles
onready var jump_timer : Timer = $jump_timer
onready var speedup_timer : Timer = $speedup_timer
onready var extra_speedup_timer : Timer = $extra_speedup_timer

onready var preloader : Node2D = $preloader

onready var baa : AudioStreamPlayer = $baa
onready var baa2 : AudioStreamPlayer = $baa2
onready var jump_sound : AudioStreamPlayer = $jump_sound

func _ready():
	camera_offset = camera.offset
	Gravity = Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY)

func _process(delta):
	var gravity = Vector2(0, 1) * Gravity

	var emit_dust = false

	if is_movement_locked:
		velocity.x = 0
		velocity.y = 0
		dust.emitting = emit_dust
		velocity += gravity
		if is_idle and Input.is_action_just_pressed("jump"):
			emit_signal("jump")
		return

	if is_on_floor:
		if is_jumping:
			sprite.play("run")

		velocity.y = 0
		is_jumping = false
		emit_dust = true

	dust.emitting = emit_dust

	if Input.is_action_just_pressed("jump") and jump_timer.time_left == 0:
		jump_timer.start()
	if not Input.is_action_pressed("jump") and jump_timer.time_left > 0 and not is_jumping:
		jump()
	elif ((Input.is_action_pressed("jump") and jump_timer.time_left == 0) \
			or Input.is_action_pressed("speedup")) \
			and speedup_timer.time_left == 0:
		speedup_timer.start()
		emit_signal("speedup")

	velocity += gravity

	if get_local_mouse_position().x > MousePositionToSlowDown:
		max_velocity = base_max_velocity + (get_local_mouse_position().x - MousePositionToSlowDown) / SpeedFromMousePositionCoef
	else:
		max_velocity = base_max_velocity - (MousePositionToSlowDown - get_local_mouse_position().x) / SpeedFromMousePositionCoef

	if velocity.x < max_velocity:
		velocity.x += Acceleration
	else:
		velocity.x -= Acceleration

		if velocity.x - max_velocity > 10:
			var shake_amount = 1

			var offset = Vector2( \
				rand_range(-1.0, 1.0) * shake_amount, \
				rand_range(-1.0, 1.0) * shake_amount \
			)
			var s = camera_offset + offset
			camera.set_offset(s)

	if speedup_timer.time_left > 0:
		velocity.x += SpeedUp

	if extra_speedup_timer.time_left > 0:
		velocity.x += ExtraSpeedUp

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP, false, true)

	is_on_floor = is_on_floor()

func jump():
	velocity += Vector2(0, -1) * Vjump
	is_jumping = true
	sprite.play("jump")
	emit_signal("jump")

	jump_sound.play()

func extra_speedup():
	baa.play()
	if extra_speedup_timer.time_left == 0 and close_calls > 0:
		extra_speedup_timer.start()
		close_calls = close_calls - 1

func lock_movement():
	is_movement_locked = true

func unlock_movement():
	is_movement_locked = false

func game_over():
	baa2.play()
	emit_signal("game_over")

func _on_alerter_body_entered(body):
	body.on_alert()

func idle():
	sprite.play("idle")
	is_idle = true
	is_movement_locked = true

func run():
	sprite.play("run")
	is_idle = false
	is_movement_locked = false