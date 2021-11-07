extends Node2D

export(Curve) var target_ease: Curve

onready var player = get_tree().get_nodes_in_group("player")[0] as KinematicBody2D
onready var MIDPOINT = to_field_local(Vector2(0,72))

const INITIAL_SPEED = 150
const MAX_ALIVE_TIME = 5.0
const PLAYER_TARGET_Y_OFFSET = -8.0

var previous_position
var start_position
var target_position
var velocity = Vector2(-INITIAL_SPEED, randf() * -60.0)
var time = 0
var randomness = randf()

func initialize(spawn_position):
	position = get_parent().to_local(spawn_position)
	
	start_position = position
	target_position = to_field_local(player.global_position)
	
func _physics_process(delta):
	time += delta

	previous_position = position
	position = interpolate_position(time / 2.0)
	var direction = (position - previous_position).normalized()
	$AnimationRoot.rotation = atan2(direction.y, direction.x)

	if time >= MAX_ALIVE_TIME:
		queue_free()
	
func interpolate_position(t: float):
	var v1 = lerp(start_position, MIDPOINT, t)
	var v2 = lerp(MIDPOINT, target_position, t)
	var v3 = lerp(v1, v2, t)
	return v3

func to_field_local(coord: Vector2):
	return get_parent().get_parent().to_local(coord)
	

func _on_DamageArea_area_entered(area):
	self.queue_free()
