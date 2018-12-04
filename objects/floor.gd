tool
extends StaticBody2D

const Tree = preload("res://decor/tree_decor.tscn")
const Piramid = preload("res://decor/piramid_decor.tscn")
const Column = preload("res://decor/column_decor.tscn")

func _ready():
	for i in rand_range(3, 5):
		add_random_decoration()

func add_random_decoration():
	var d = rand_range(0, 3)
	var decor : Node2D = null
	if d < 2:
		decor = Tree.instance()
	#elif d < 2:
	#	decor = Piramid.instance()
	elif d < 3:
		decor = Column.instance()
	
	add_child(decor)
	decor.position.x += rand_range(-300, 300)
	decor.position.y += rand_range(-140, -100)
	
	decor.z_index = -1
	decor.z_as_relative = false
	
	#var s = rand_range(-0.2, 0.2)
	#decor.scale.x += s
	#decor.scale.y += s