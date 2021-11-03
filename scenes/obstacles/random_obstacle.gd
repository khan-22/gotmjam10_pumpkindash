extends Node2D


func _ready():
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count("default")
	pass

func _physics_process(delta):
	global_position.y -= Global.vertical_scroll_speed * delta
