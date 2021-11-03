extends Node2D

onready var state_machine = $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback
onready var BulletSideDash = preload("res://scenes/bullets/bullet_sidedash.tscn")

var is_firing = false

func _ready():
	pass

#func _physics_process(delta):
	


func _on_FireTimer_timeout():
	if not is_firing:
		fire_dual_side_attack()
	
	pass # Replace with function body.


func fire_dual_side_attack():
	is_firing = true
	state_machine.travel("DualSideAttack")
	yield($w_body/w_clawL, "side_bullet_spawn")
	var left_bullet = BulletSideDash.instance()
	var right_bullet = BulletSideDash.instance()
	
#	left_bullet.global_position = $w_body/w_clawL/BulletSpawnPosition.global_position
#	right_bullet.global_position = $w_body/clawR_pivot/w_clawR/BulletSpawnPosition.global_position
	
	$BulletManager/LeftSide.add_child(left_bullet)
	$BulletManager/RightSide.add_child(right_bullet)
	left_bullet.set_owner(get_owner())
	right_bullet.set_owner(get_owner())
	
	left_bullet.initialize($w_body/w_clawL/BulletSpawnPosition.global_position)
	right_bullet.initialize($w_body/clawR_pivot/w_clawR/BulletSpawnPosition.global_position)
	
	is_firing = false
