extends Sprite

var on = true
func _on_Timer_timeout():
	on = !on
	modulate.a = 1.0 if on else 0.0
