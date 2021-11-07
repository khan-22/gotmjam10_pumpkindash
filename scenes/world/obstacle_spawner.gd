extends YSort

export(bool) var enabled = false

onready var random_obstacle = preload("res://scenes/obstacles/random_obstacle.tscn")

const SLOTS_PER_ROW = 9
const MAX_NUM_OBSTACLES = 4
var scroll_distance = 0
var row_i = 0

onready var random_number_generator = RandomNumberGenerator.new()

func _ready():
	random_number_generator.randomize()
	pass
	
func _physics_process(delta):
	scroll_distance += delta * Global.vertical_scroll_speed
#	print(get_child_count())
	if scroll_distance >= 16:
		# Don't spawn anything every third row to avoid blocking the player in
		if enabled and row_i % 3 != 0:
			spawn_obstacle_row()
		row_i += 1
		scroll_distance -= 16
	
func spawn_obstacle_row():
	var num = max(random_number_generator.randi() % SLOTS_PER_ROW - (SLOTS_PER_ROW - MAX_NUM_OBSTACLES), 0)
	
	var array = []
	for i in range(SLOTS_PER_ROW):
		array.append(true if i < num else false)
		
	array.shuffle()
#	print(array)
	var obstacle_position = $SpawnOrigin.global_position
	for should_spawn in array:
		if should_spawn:
			var new_obstacle = random_obstacle.instance()
			add_child(new_obstacle)
			new_obstacle.set_owner(get_owner())
			new_obstacle.global_position = obstacle_position
		
		obstacle_position.x += 16 #Obstacle size
	
	


func _on_ObstacleKillArea_body_entered(body):
	body.queue_free()
	print("kill")
	pass # Replace with function body.
