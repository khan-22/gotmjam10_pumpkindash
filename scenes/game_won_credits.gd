extends Node2D

signal restart_game

var ok_to_skip = false
func _input(event):
	if ok_to_skip and (event is InputEventKey and event.is_pressed() or event is InputEventJoypadButton):
		emit_signal("restart_game")

var time = 0.0
func _physics_process(delta):
	time += delta
	
	if time > 0.4:
		ok_to_skip = true
