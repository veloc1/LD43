tool
extends Node2D

export var color : Color
export var y : float

func _process(delta):
	update()

func _draw():
	var rect = Rect2(-300, y, 300 * 2, 200 * 2)
	draw_rect(rect, color)