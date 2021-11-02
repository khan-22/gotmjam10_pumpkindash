extends KinematicBody2D

const SPEED = 70

func _ready():
	pass

func _physics_process(delta):
	var vel = Vector2(0,0)
	
	if Input.is_key_pressed(KEY_LEFT):
		vel.x -= SPEED
	if Input.is_key_pressed(KEY_RIGHT):
		vel.x += SPEED
	if Input.is_key_pressed(KEY_UP):
		vel.y -= SPEED
	if Input.is_key_pressed(KEY_DOWN):
		vel.y += SPEED
	
	move_and_slide(vel)
