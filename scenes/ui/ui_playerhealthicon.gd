extends Control

export(bool) var is_on = true setget set_on

func set_on(value):
	is_on = value
	$AnimatedSprite.frame = 0 if is_on else 1

func _ready():
	pass
