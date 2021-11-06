extends Node2D

#onready var state_machine = $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback
onready var BulletSideDash = preload("res://scenes/bullets/bullet_sidedash.tscn")
onready var left_claw = $w_body/w_clawL
onready var right_claw = $w_body/clawR_pivot/w_clawR
onready var front_bullet_origin = get_tree().get_nodes_in_group("front_bullet_origin")[0]

var is_firing = false

var current_idle = "Idle"

func _ready():
#	$BodyAnimationPlayer.connect("animation_finished", self, "return_to_idle")
	pass

#func return_to_idle():
#	print("what?")
#	$BodyAnimationPlayer.play(current_idle)

var i: int = 0
func _on_FireTimer_timeout():
	if not is_firing:
		match i % 3:
			0: 
				fire_dual_side_attack()
			1: 
				fire_left_front_attack()
			2: 
				fire_right_front_attack()
				
		i += 1
	pass # Replace with function body.

func fire_left_front_attack():
	is_firing = true
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	left_claw.do_front_attack(BulletSideDash, $BulletManager/LeftSide, -(randi() % 9) * 8)
#	right_claw.do_side_attack(BulletSideDash, $BulletManager/RightSide)
	yield(left_claw, "attack_finished")
	is_firing = false

func fire_right_front_attack():
	is_firing = true
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	right_claw.do_front_attack(BulletSideDash, $BulletManager/RightSide, -(randi() % 9) * 8)
#	right_claw.do_side_attack(BulletSideDash, $BulletManager/RightSide)
	yield(right_claw, "attack_finished")
	is_firing = false

func fire_dual_side_attack():
	is_firing = true
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	left_claw.do_side_attack(BulletSideDash, $BulletManager/LeftSide)
	right_claw.do_side_attack(BulletSideDash, $BulletManager/RightSide)
	yield(left_claw, "attack_finished")
	is_firing = false
