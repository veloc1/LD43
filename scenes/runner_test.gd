extends Node2D

const MenuGenerator = preload("res://generators/menu.gd")
const TutorialGenerator = preload("res://generators/tutorial.gd")
const EmptyGenerator = preload("res://generators/empty.gd")
const Level1Generator = preload("res://generators/level1.gd")

const PeasantPointer = preload("res://objects/pointers/peasant.tscn")

var generator = null
var last_part_position = 0

var is_win = false

onready var player = $player
onready var fader = $fader

onready var music = $music
onready var music_menu : AudioStreamPlayer = $music_menu

func _ready():
	change_generator(MenuGenerator.new())
	#change_generator(Level1Generator.new())
	create_part()
	
	player.connect("game_over", self, "on_game_over")
	player.connect("jump", self, "on_player_jump")
	
	fader.connect("on_fade_out", self, "on_fade_out")
	fader.fade_in()
	
	player.idle()

func _process(delta):
	$ui/speed.text = "Speed: " + str($player.velocity.x)
	$ui/close_call.text = "Close calls: " + str($player.close_calls)
	
	if player.preloader.global_position.x > last_part_position:
		change_generator_to_next_if_needed()
		create_part()
	
	update_pointers()

func change_generator_to_next_if_needed():
	if generator.is_complete():
		var new_gen = null
		if generator.get_script() == MenuGenerator:
			if not game_state.is_tutorial_showed:
				new_gen = TutorialGenerator
			else:
				new_gen = Level1Generator
		if generator.get_script() == TutorialGenerator:
			game_state.is_tutorial_showed = true
			new_gen = Level1Generator
		if generator.get_script() == Level1Generator:
			is_win = true
			fader.fade_out()
			new_gen = Level1Generator
		change_generator(new_gen.new())

func change_generator(new_generator):
	if has_node("generator"):
		var g = get_node("generator")
		g.free()
	generator = new_generator
	generator.name = "generator"
	add_child(generator)
	
	player.connect("jump", generator, "on_player_jump")
	player.connect("speedup", generator, "on_player_speedup")

func create_part():
	var part = generator.make_part()
	add_child(part)
	part.position.x = last_part_position
	
	var part_end = part.get_node("end") as Node2D
	last_part_position = part_end.global_position.x
	
	for i in range(3, get_child_count()):
		var n = get_child(i)
		if n is Node2D:
			if n.global_position.x < player.global_position.x - 3000:
				n.queue_free()

func update_pointers():
	var pointers_container = $ui/pointers_left
	
	var peasants = get_tree().get_nodes_in_group("peasants")
	for p in peasants:
		var pointer = get_pointer(p)
		if pointer == null:
			pointer = PeasantPointer.instance()
			pointer.name = "p" + str(p.get_instance_id())
			pointers_container.add_child(pointer)
		
		var d = p.distance_to(player)
		
		var low = 400
		var screen_end = 480
		
		var dist_to_show = 300
		
		if d < 0:
			pointer.position.y = screen_end
		else:
			pointer.position.y = low - d
			
			if d < dist_to_show:
				var a = dist_to_show
				var b = d
				pointer.modulate.a = b / a
				
				pointer.scale.x = 1
				pointer.scale.y = 1
			else:
				pointer.modulate.a = 1
				
				var max_dist = 300
				var s = (max_dist - (d - dist_to_show)) / max_dist
				pointer.scale.x = s
				pointer.scale.y = s

func get_pointer(peasant):
	var pointers_container = $ui/pointers_left
	for i in range(pointers_container.get_child_count()):
		var p = pointers_container.get_child(i)
		if p.name == "p" + str(peasant.get_instance_id()):
			return p
	return null

func on_game_over():
	$ui/game_over.show()
	fader.fade_out()

func on_fade_out():
	if is_win:
		get_tree().change_scene("res://scenes/win.tscn")
	else:
		get_tree().change_scene("res://scenes/game_over.tscn")

func on_player_jump():
	if music_menu.playing and generator.is_intro_done():
		music_menu.stop()
		music.play()
		player.run()