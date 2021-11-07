extends Node2D

export(bool) var enabled = false setget set_enabled

#onready var state_machine = $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback
onready var BulletSideDash = preload("res://scenes/bullets/bullet_sidedash.tscn")
onready var BulletFrontFire = preload("res://scenes/bullets/bullet_frontfire.tscn")
onready var left_claw = $w_body/w_clawL
onready var right_claw = $w_body/clawR_pivot/w_clawR

var current_idle = "Idle"

enum State {
	CALM,
	AGGITATED,
	RAGE
}

var pattern1 = [
	"side_skull_dual",
	"front_fire_left",
	"front_fire_right",
	0.5,
	"side_skill_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",	
	0.5
]

onready var current_pattern = pattern1
var pattern_head = 0

func _ready():
#	$BodyAnimationPlayer.connect("animation_finished", self, "return_to_idle")
	pass

#func return_to_idle():
#	print("what?")
#	$BodyAnimationPlayer.play(current_idle)

#func init_phase2():
	

func set_enabled(value: bool):
	if enabled == value:
		return
	
	enabled = value
	
	if enabled:
		main_loop()
	


func main_loop():
	while enabled:
		var head = pattern1[pattern_head]
		if typeof(head) == TYPE_REAL:
			yield(wait(head), "completed")
		else:
			yield(call(head), "completed")
		pattern_head = (pattern_head + 1) % current_pattern.size()


#var i: int = 0
#func _on_FireTimer_timeout():
#	if not enabled:
#		return
#
#	if not is_firing:
#		match i % 3:
#			0: 
#				fire_dual_side_attack()
#			1: 
#				fire_left_front_attack()
#			2: 
#				fire_right_front_attack()
#
#		i += 1
#	pass # Replace with function body.

func wait(amount: float):
	yield(get_tree().create_timer(amount), "timeout")

func front_fire_left():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	left_claw.do_front_attack(BulletFrontFire, $BulletManager/LeftSide, -(randi() % 9) * 8)
	yield(left_claw, "attack_finished")

func front_fire_right():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	right_claw.do_front_attack(BulletFrontFire, $BulletManager/RightSide, -(randi() % 9) * 8)
	yield(right_claw, "attack_finished")
	
func front_fire_dual():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	left_claw.do_front_attack(BulletFrontFire, $BulletManager/LeftSide, -(randi() % 9) * 8)
	right_claw.do_front_attack(BulletFrontFire, $BulletManager/RightSide, -(randi() % 9) * 8)
	yield(left_claw, "attack_finished")
	
func side_skull_dual():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	left_claw.do_side_attack(BulletSideDash, $BulletManager/LeftSide)
	right_claw.do_side_attack(BulletSideDash, $BulletManager/RightSide)
	yield(left_claw, "attack_finished")


##########################
