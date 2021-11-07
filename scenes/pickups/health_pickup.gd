extends Area2D

const KILL_Y = -64

func get_type():
	return "health"

func _physics_process(delta):
	global_position.y -= Global.vertical_scroll_speed * delta
	
	if global_position.y <= KILL_Y:
		self.queue_free()

func consume():
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("Pickup")
