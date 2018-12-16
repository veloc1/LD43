extends KinematicBody2D

var Gravity = 0

var is_broken = false
var velocity : Vector2 = Vector2()

func _ready():
	Gravity = Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY)

func _process(delta):
	if global_position.y > 1000:
		queue_free()

func _physics_process(delta):
	if is_broken:
		var gravity = Vector2(0, 1) * Gravity 
		velocity = velocity + gravity
		
		velocity.x = 30
		velocity.y = clamp(velocity.y, -300, 300)
		
		velocity = move_and_slide(velocity)

func broke():
	if not is_broken:
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
		is_broken = true
		
		velocity.y -= 100
		rotate(rand_range(0, 0.5))

func _on_player_detector_body_entered(body):
	broke()
	if body.has_method("slowdown_on_fence"):
		body.slowdown_on_fence()
