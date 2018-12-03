extends Node

const TutJump = preload("res://generators/tutorial/tutorial_jump.tscn")
const TutSpeedup = preload("res://generators/tutorial/tutorial_speedup.tscn")

var player_know_jump = false
var player_know_speedup = false

func make_part():
	var part = null
	if not player_know_jump:
		part = TutJump.instance()
	else:
		part = TutSpeedup.instance()
	return part

func is_complete():
	return player_know_jump and player_know_speedup

func on_player_jump():
	player_know_jump = true

func on_player_speedup():
	player_know_speedup = true