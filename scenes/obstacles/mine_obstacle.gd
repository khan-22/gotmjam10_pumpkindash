extends Area2D

const KILL_Y = -64

func _physics_process(delta):
	global_position.y -= Global.vertical_scroll_speed * delta
	
	if global_position.y <= KILL_Y:
		self.queue_free()


func _on_mine_obstacle_area_entered(area):
	$AnimationPlayer.play("Trigger")
	pass # Replace with function body.
