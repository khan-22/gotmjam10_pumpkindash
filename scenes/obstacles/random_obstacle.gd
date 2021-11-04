extends StaticBody2D

const KILL_Y = -64

func _ready():
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count("default")
	pass

func _physics_process(delta):
	global_position.y -= Global.vertical_scroll_speed * delta
	constant_linear_velocity.y = Global.vertical_scroll_speed
	
	if global_position.y <= KILL_Y:
		self.queue_free()
