extends Area2D

onready var timer : Timer = $Timer
onready var progress : ProgressBar = $progress
onready var sprite : AnimatedSprite = $AnimatedSprite
onready var sound : AudioStreamPlayer2D = $AudioStreamPlayer

var player : Node2D = null

func _process(delta):
	if timer.is_stopped():
		progress.hide()
	else:
		progress.show()
		progress.value = 100 - timer.time_left / timer.wait_time * 100

func _on_trap_body_entered(body):
	if body.has_method("lock_movement"):
		timer.start()
		player = body
		if player != null:
			player.lock_movement()
		
			sound.play()
			sprite.play()

func _on_Timer_timeout():
	player.unlock_movement()
	queue_free()
