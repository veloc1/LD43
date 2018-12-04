extends KinematicBody2D

var Gravity = 0
var Vflap = 50

export var is_flying : bool = false
export var flying_height : int = 300

var velocity : Vector2 = Vector2()

onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

func _ready():
	Gravity = Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY)

func _process(delta):
	if is_flying:
		if global_position.y > -flying_height and rand_range(0, 1) > 0.3:
			flap()
		var gravity = Vector2(0, 1) * Gravity 
		velocity = velocity + gravity
		
		velocity.y = clamp(velocity.y, -300, 300)
		
		velocity = move_and_slide(velocity)
	else:
		if rand_range(0, 1) > 0.8:
			peck()

func flap():
	animation.play("fly")
	velocity += Vector2(0, -1) * Vflap

func peck():
	animation.play("idle")

func on_alert():
	is_flying = true
	
	var vel = 200
	
	velocity.x = rand_range(-vel, vel)
	if velocity.x < 0:
		sprite.flip_h = true
	if abs(velocity.x) < vel / 2:
		velocity.x = velocity.x * 2
