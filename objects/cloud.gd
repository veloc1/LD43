extends Node2D

func _ready():
	if rand_range(0, 1) > 0.5:
		$Sprite.show()
		$Sprite2.hide()
	else:
		$Sprite2.show()
		$Sprite.hide()

func _process(delta):
	translate(Vector2(-10 * delta, 0))
