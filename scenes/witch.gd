extends Node2D

export(bool) var enabled = false setget set_enabled

#onready var state_machine = $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback
onready var BulletSideDash = preload("res://scenes/bullets/bullet_sidedash.tscn")
onready var BulletSideCurve = preload("res://scenes/bullets/bullet_sidecurve.tscn")
onready var BulletFrontFire = preload("res://scenes/bullets/bullet_frontfire.tscn")
onready var left_claw = $w_body/w_clawL
onready var right_claw = $w_body/clawR_pivot/w_clawR

var current_idle = "Idle"

enum State {
	CALM,
	AGGITATED,
	RAGE
}

const PATTTERN1_SPEED = 1.0
const PATTTERN2_SPEED = 1.5
const PATTTERN3_SPEED = 2.0

#var pattern1 = [
#	"side_curve_dual"
#]

var pattern1 = [
	"side_skull_dual",
	"front_fire_left",
	"front_fire_right",
	0.5,
	"side_skull_dual",
	"side_curve_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",	
	0.5,
	# Repeat
	"side_skull_dual",
	"front_fire_left",
	"front_fire_right",
	0.5,
	"side_skull_dual",
	"side_curve_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",	
	"side_curve_dual",	
	0.5,
	"side_curve_dual",	
	"init_phase2"
]

var pattern2 = [
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_curve_dual",	
	"side_skull_dual",
	"side_curve_dual",	
	"side_skull_dual",
	"side_curve_dual",
	1.0,
	"side_curve_dual",	
	"side_curve_dual",	
	"side_curve_dual",	
	"front_fire_dual",
	1.0,
	"side_skull_dual",
	"side_skull_dual",
	"side_curve_dual",	
	"side_curve_dual",
	"front_fire_dual",
	"front_fire_dual",
	2.0,
	#Repeat
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_curve_dual",	
	"side_skull_dual",
	"side_curve_dual",	
	"side_skull_dual",
	"side_curve_dual",
	1.0,
	"side_curve_dual",	
	"side_curve_dual",	
	"side_curve_dual",	
	"front_fire_dual",
	1.0,
	"side_skull_dual",
	"side_skull_dual",
	"side_curve_dual",	
	"side_curve_dual",
	"front_fire_dual",
	"front_fire_dual",
	2.0,
	"init_phase3"
]

var pattern3 = [
	"front_fire_dual",
	"front_fire_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"side_skull_dual",
	"side_curve_dual",	
	"side_curve_dual",	
	2.0,
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"side_curve_dual",
	1.0,
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"side_curve_dual",
	#REPEAT
	"front_fire_dual",
	"side_skull_dual",
	"side_skull_dual",
	"side_curve_dual",	
	"side_curve_dual",	
	2.0,
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"side_curve_dual",
	1.0,
	"front_fire_dual",
	"side_skull_dual",
	"front_fire_dual",
	"front_fire_dual",
	"side_skull_dual",
	"side_curve_dual",
	5.0,
	"end_game"
]


onready var current_pattern = pattern1
var pattern_head = 0

func _ready():
#	$BodyAnimationPlayer.connect("animation_finished", self, "return_to_idle")
	init_phase1()
	pass

#func return_to_idle():
#	print("what?")
#	$BodyAnimationPlayer.play(current_idle)

func init_phase1():
	current_pattern = pattern1
	pattern_head = 0
	$BodyAnimationPlayer.playback_speed = PATTTERN1_SPEED
	left_claw.animation_speed = PATTTERN1_SPEED
	right_claw.animation_speed = PATTTERN1_SPEED
	$w_body/w_face.frame = 0
	$w_body/w_face/w_hat.frame = 0

func init_phase2():
	current_pattern = pattern2
	pattern_head = 0
	$BodyAnimationPlayer.play("Angry1")
	$BodyAnimationPlayer.queue(current_idle)
	var fn1 = left_claw.do_angry_fist()
	var fn2 = right_claw.do_angry_fist()
	yield(fn1, "completed")
	yield(fn2, "completed")
	
	$BodyAnimationPlayer.playback_speed = PATTTERN2_SPEED
	left_claw.animation_speed = PATTTERN2_SPEED
	right_claw.animation_speed = PATTTERN2_SPEED
	Events.emit_signal("start_phase2")
	
func init_phase3():
	current_pattern = pattern3
	pattern_head = 0
	$BodyAnimationPlayer.play("Angry2")
	$BodyAnimationPlayer.queue(current_idle)
	var fn1 = left_claw.do_angry_fist2()
	var fn2 = right_claw.do_angry_fist2()
	yield(fn1, "completed")
	yield(fn2, "completed")
	
	$BodyAnimationPlayer.playback_speed = PATTTERN3_SPEED
	left_claw.animation_speed = PATTTERN3_SPEED
	right_claw.animation_speed = PATTTERN3_SPEED
	
	Events.emit_signal("start_phase3")

func end_game():
	$BodyAnimationPlayer.playback_speed = PATTTERN1_SPEED
	left_claw.animation_speed = PATTTERN1_SPEED
	right_claw.animation_speed = PATTTERN1_SPEED
	
	# Remove all bullets
	for child in $BulletManager/LeftSide.get_children():
		child.queue_free()
	for child in $BulletManager/RightSide.get_children():
		child.queue_free()
	
	Events.emit_signal("game_win")
	enabled = false
	yield(get_tree().create_timer(0.1), "timeout")

func set_enabled(value: bool):
	if enabled == value:
		return
	
	enabled = value
	
	if enabled:
		main_loop()
	


func main_loop():
	while enabled:
		var head = current_pattern[pattern_head]
		if typeof(head) == TYPE_REAL:
			yield(wait(head), "completed")
		else:
			yield(call(head), "completed")
		pattern_head = (pattern_head + 1) % current_pattern.size()

##########################


func wait(amount: float):
	yield(get_tree().create_timer(amount), "timeout")

func front_fire_left():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	var fn = left_claw.do_front_attack(BulletFrontFire, $BulletManager/LeftSide, -(randi() % 9) * 8)
	yield(fn, "completed")

func front_fire_right():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	var fn = right_claw.do_front_attack(BulletFrontFire, $BulletManager/RightSide, -(randi() % 9) * 8)
	yield(fn, "completed")
	
func front_fire_dual():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	var fn1 = left_claw.do_front_attack(BulletFrontFire, $BulletManager/LeftSide, -(randi() % 9) * 8)
	var fn2 = right_claw.do_front_attack(BulletFrontFire, $BulletManager/RightSide, -(randi() % 9) * 8)
	yield(fn1, "completed")
	yield(fn2, "completed")
	
func side_skull_dual():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	var fn1 = left_claw.do_side_attack(BulletSideDash, $BulletManager/LeftSide)
	var fn2 = right_claw.do_side_attack(BulletSideDash, $BulletManager/RightSide)
	yield(fn1, "completed")
	yield(fn2, "completed")

func side_curve_dual():
	$BodyAnimationPlayer.play("DualSideAttack")
	$BodyAnimationPlayer.queue(current_idle)
	var fn1 = left_claw.do_side_attack(BulletSideCurve, $BulletManager/LeftSide)
	var fn2 = right_claw.do_side_attack(BulletSideCurve, $BulletManager/RightSide)
	yield(fn1, "completed")
	yield(fn2, "completed")

##########################
