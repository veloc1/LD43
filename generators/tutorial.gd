extends Node

const TutJump = preload("res://generators/tutorial/tutorial_jump.tscn")
const TutSpeedup = preload("res://generators/tutorial/tutorial_speedup.tscn")
const TutSlowdown = preload("res://generators/tutorial/tutorial_slowdown.tscn")

var player_know_jump = false
var player_know_speedup = false
var player_know_slowdown = false

var helper = null

func make_part():
	var part = null
	if not player_know_jump:
		part = TutJump.instance()
	elif not player_know_speedup:
		part = TutSpeedup.instance()
		if helper != null:
			helper.hide()
		helper = part.get_node("CanvasLayer/root")
	else:
		part = TutSlowdown.instance()
		if helper != null:
			helper.hide()
		helper = part.get_node("CanvasLayer/root")
	return part

func is_complete():
	return player_know_jump and player_know_speedup and player_know_slowdown

func on_player_jump():
	player_know_jump = true

func on_player_speedup():
	if helper != null and not player_know_speedup:
		helper.hide()
	player_know_speedup = true

func on_player_slowdown():
	if helper != null and player_know_speedup and not player_know_slowdown:
		helper.hide()
	player_know_slowdown = true