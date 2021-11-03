extends AnimatedSprite

signal side_bullet_spawn

func trigger_side_bullet_spawn():
	emit_signal("side_bullet_spawn")

func _ready():
	pass
