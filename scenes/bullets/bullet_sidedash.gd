extends KinematicBody2D

export(Curve) var target_ease: Curve

onready var bullet_line = get_tree().get_nodes_in_group("bullet_lines")[0] as Line2D
onready var player = get_tree().get_nodes_in_group("player")[0] as KinematicBody2D

enum State {
	INITIAL,
	CHARGEDASH
}

const INITIAL_SPEED = 400

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
			velocity.y += 50 * delta
			simulated_position += velocity * delta

			# Calculate the position on the line to follow
			var pos1 = bullet_line.global_position + bullet_line.points[0]
			var pos2 = bullet_line.global_position + bullet_line.points[1]

			var global_target_position = lerp(pos1, pos2, sin(time*1.7 + 3.0*randomness) * 0.5 + 0.5)
			global_target_position.x += cos(time * 2.2) * 4.0

			# Convert the position to coordinates relative to the bullet's space
			# Which is to say, pretend that we're on the left side.
			# Right sided bullets are simulated as if left-sided and ultimately mirrored.
			var target_position = get_parent().get_parent().to_local(global_target_position)

			position = lerp(simulated_position, target_position, target_ease.interpolate(clamp((time*0.5 - 0.2), 0.0, 1.0)))
			
#		State.CHARGEDASH:
			
#func calc_projected_player_position():
	
	
	
	
	
	
	
	
	
	
	
	
	
	
