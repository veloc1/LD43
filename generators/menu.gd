extends Node

const MenuScene = preload("res://generators/menu/menu.tscn")

var player_pressed_jump = false
var menu

func make_part():
	menu = MenuScene.instance()
	return menu

func is_complete():
	return player_pressed_jump

func is_intro_done():
	return menu.is_intro_done()

func on_player_jump():
	player_pressed_jump = true

func on_player_speedup():
	false