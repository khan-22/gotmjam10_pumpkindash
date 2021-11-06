extends Node2D


const SPEED = 40

func _ready():
	pass

func initialize(spawn_position: Vector2):
	position = get_parent().to_local(spawn_position)

func _physics_process(delta):
	position.y += SPEED * delta
	
	


func _on_DamageArea_area_entered(area):
	self.queue_free()
