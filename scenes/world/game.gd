extends Node

const level_scene = preload("res://scenes/world/level.tscn")
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
	
	if reset_count > 0:
		new_level.do_quick_intro = true
	
	level = new_level

func on_restart():
	reset_count += 1
	
	level.queue_free()
	setup_level()
