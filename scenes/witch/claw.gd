extends AnimatedSprite

signal bullet_spawn
signal attack_finished

export(float) var animation_speed = 1.0 setget set_animation_speed

var current_idle = "Idle"

func _ready():
	$ClawAnimationPlayer.playback_speed = animation_speed
	$ClawAnimationPlayer.connect("animation_finished", self, "return_to_idle")
	pass

func set_animation_speed(value: float):
	animation_speed = value
	$ClawAnimationPlayer.playback_speed = animation_speed

func do_angry_fist():
	$ClawAnimationPlayer.play("Angry1")
	$ClawAnimationPlayer.queue(current_idle)
	yield($ClawAnimationPlayer, "animation_changed")
	emit_signal("attack_finished")
	
func do_angry_fist2():
	$ClawAnimationPlayer.play("Angry2")
	$ClawAnimationPlayer.queue(current_idle)
	yield($ClawAnimationPlayer, "animation_changed")
	emit_signal("attack_finished")
	
func do_side_attack(bullet_type: PackedScene, bullet_field: Node2D):
	$ClawAnimationPlayer.play("SideAttack")
	$ClawAnimationPlayer.queue(current_idle)
	yield(self, "bullet_spawn")
	var new_bullet = bullet_type.instance()
	bullet_field.add_child(new_bullet)
	new_bullet.set_owner(bullet_field.get_owner())
	new_bullet.initialize($BulletSpawnPosition.global_position)
	yield($ClawAnimationPlayer, "animation_changed")
	emit_signal("attack_finished")

func do_front_attack(bullet_type: PackedScene, bullet_field: Node2D, x_offset: float):
	var front_anim = $ClawAnimationPlayer.get_animation("FrontAttack")
	var idx = front_anim.find_track(".:position")
	var claw_position = front_anim.track_get_key_value(idx, 10) as Vector2
	claw_position.x = x_offset
	front_anim.track_set_key_value(idx, 10, claw_position)
	
	$ClawAnimationPlayer.play("FrontAttack")
	$ClawAnimationPlayer.queue(current_idle)
	yield(self, "bullet_spawn")
	var new_bullet = bullet_type.instance()
	bullet_field.add_child(new_bullet)
	new_bullet.set_owner(bullet_field.get_owner())
	new_bullet.initialize($BulletSpawnPosition.global_position)
	yield($ClawAnimationPlayer, "animation_changed")
	emit_signal("attack_finished")

#func return_to_idle():
#	print("hello????")
#	$ClawAnimationPlayer.play(current_idle)
#	emit_signal("attack_finished")

