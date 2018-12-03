extends Node2D

onready var fader = $fader

func _ready():
	fader.connect("on_fade_out", self, "on_fade_out")
	fader.fade_in()

func _process(delta):
	if Input.is_action_just_pressed("jump") and not fader.is_in_process():
		fader.fade_out()

func on_fade_out():
	get_tree().change_scene("res://runner_test.tscn")
