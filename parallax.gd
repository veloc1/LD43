extends ParallaxLayer

export var color : Color = Color(0.3, 1, 0.3)

func _process(delta):
	$Node2D.color = color
	#var p = get_parent() as ParallaxBackground
	#p.scroll_offset