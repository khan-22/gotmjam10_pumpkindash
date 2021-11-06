extends AnimatedSprite

signal bullet_spawn

func trigger_bullet_spawn():
	emit_signal("bullet_spawn")

func _ready():
	pass
