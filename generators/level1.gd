extends Node

const Block1 = preload("res://generators/level1/block1.tscn")
const Block2 = preload("res://generators/level1/block2.tscn")
const Block3 = preload("res://generators/level1/block3.tscn")

var timer : Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.one_shot = true
	timer.start()

func make_part():
	var part = null
	var d = rand_range(0, 3)
	if d < 1:
		part = Block1.instance()
	elif d < 2:
		part = Block2.instance()
	elif d < 3:
		part = Block3.instance()
	return part

func is_complete():
	return timer.time_left == 0

func on_player_jump():
	pass

func on_player_speedup():
	pass

func on_player_slowdown():
	pass

func is_intro_done():
	return true