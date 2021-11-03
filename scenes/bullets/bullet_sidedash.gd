extends Node2D

export(Curve) var target_ease: Curve

onready var bullet_line = get_tree().get_nodes_in_group("bullet_lines")[0] as Line2D
onready var player = get_tree().get_nodes_in_group("player")[0] as KinematicBody2D

enum State {
	INITIAL,
	CHARGEDASH
}

const INITIAL_SPEED = 150
const MAX_CHARGE_TIME = 3.0

var simulated_position
var velocity = Vector2(-INITIAL_SPEED, randf() * -60.0)
var time = 0
var randomness = randf()
var current_state = State.INITIAL

func initialize(spawn_position):
	simulated_position = get_parent().to_local(spawn_position)
	position = simulated_position

func _physics_process(delta):
	time += delta

	match current_state:
		State.INITIAL:
			# Simulate a physical position, so that we get a smooth transition out of the hand (claw)
			velocity.x *= 0.98
			velocity.y += 100 * delta
			simulated_position += velocity * delta

			var follow_position = calc_projected_player_position()
			follow_position.y = lerp(position.y, follow_position.y, 0.1)
			position = lerp(simulated_position, follow_position, target_ease.interpolate(clamp((time*0.5 - 0.14), 0.0, 1.0)))
			
			#position = lerp(position, target_position, 0.01)
			if time >= MAX_CHARGE_TIME:
				current_state = State.CHARGEDASH
			
		State.CHARGEDASH:
			$AnimationRoot/AnimationPlayer.play("Dash")
			self.set_physics_process(false)
			pass

func calc_projected_player_position():
	# Calculate the position on the line to follow
	var pos1 = bullet_line.global_position + bullet_line.points[0]
	var pos2 = bullet_line.global_position + bullet_line.points[1]

	var player_t = (clamp(player.get_global_position().y, pos1.y, pos2.y) - pos1.y) / abs(pos2.y - pos1.y)

#	var global_target_position = lerp(pos1, pos2, sin(time*1.7 + 3.0*randomness) * 0.5 + 0.5)
	var global_target_position = lerp(pos1, pos2, player_t)
	global_target_position.x += cos(time * 2.2) * 8.0
	global_target_position.y += sin(time * 4.6 + randomness * 2.5) * 16.0

	# Convert the position to coordinates relative to the bullet's space
	# Which is to say, pretend that we're on the left side.
	# Right sided bullets are simulated as if left-sided and ultimately mirrored.
	var target_position = to_field_local(global_target_position)
	
	return target_position
	
func to_field_local(coord: Vector2):
	return get_parent().get_parent().to_local(coord)
	
	
	
	
	
	
	
	
	
