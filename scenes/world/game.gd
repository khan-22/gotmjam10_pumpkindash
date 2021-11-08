extends Node

const level_scene = preload("res://scenes/world/level.tscn")
const credits_scene = preload("res://scenes/game_won_credits.tscn")
var level

var reset_count = 0

func _ready():
	setup_level()
	pass

func setup_level():
	var new_level = level_scene.instance()
	add_child(new_level)
	new_level.set_owner(get_owner())
	new_level.connect("restart_game", self, "on_restart")
	new_level.connect("go_to_credits", self, "on_credits")
	
	if reset_count > 0:
		new_level.do_quick_intro = true
	
	level = new_level

func on_restart():
	reset_count += 1
	
	level.queue_free()
	setup_level()
	
func on_credits():
	level.queue_free()
	var scene = credits_scene.instance()
	add_child(scene)
	scene.set_owner(get_owner())
	
