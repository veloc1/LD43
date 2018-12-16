tool
extends StaticBody2D

const Tree = preload("res://decor/tree_decor.tscn")
const Piramid = preload("res://decor/piramid_decor.tscn")
const Column = preload("res://decor/column_decor.tscn")
const Cloud = preload("res://objects/cloud.tscn")

func _ready():
	for i in rand_range(1, 3):
		add_random_decoration()
	for i in rand_range(0, 1):
		add_cloud()

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
	
	var y = rand_range(-130, -100)
	decor.position.x += rand_range(-300, 300)
	decor.position.y += y
	
	decor.z_index = y
	decor.z_as_relative = false
	
	var s = rand_range(-0.1, 0.1)
	decor.scale.x += decor.scale.x * s
	decor.scale.y += decor.scale.y * s

func add_cloud():
	var cloud = Cloud.instance()
	
	cloud.position.y = rand_range(-600, -300)
	
	cloud.z_index = -600
	cloud.z_as_relative = false
	
	var s = rand_range(-0.1, 0.1)
	cloud.scale.x += cloud.scale.x * s
	cloud.scale.y += cloud.scale.y * s
	
	add_child(cloud)