extends Node2D

export var rect : Rect2 
export var color : Color 

func _process(delta):
	update()

func _draw():
	draw_rect(rect, color, false)
	var rect2 = Rect2(rect.position + Vector2(1, 1), rect.size - Vector2(2, 2))
	draw_rect(rect2, color, false)
