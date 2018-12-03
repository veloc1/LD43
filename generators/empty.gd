extends Node

const EmptyScene = preload("res://generators/empty/empty.tscn")

func make_part():
	var part = EmptyScene.instance()
	return part

func is_complete():
	return false

func on_player_jump():
	pass

func on_player_speedup():
	pass