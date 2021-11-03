extends YSort

onready var random_obstacle = preload("res://scenes/obstacles/random_obstacle.tscn")

const MAX_NUM_OBSTACLES = 9
var scroll_distance = 0

func _ready():
	pass
	
func _physics_process(delta):
	scroll_distance += delta * Global.vertical_scroll_speed
	
	if scroll_distance >= 16:
		spawn_obstacle_row()
		scroll_distance -= 16
	
func spawn_obstacle_row():
	var num = max(randi() % MAX_NUM_OBSTACLES - 5, 0)
	
	var array = []
	for i in range(MAX_NUM_OBSTACLES):
		array.append(true if i < num else false)
		
	array.shuffle()
	print(array)
	var obstacle_position = $SpawnOrigin.global_position
	for should_spawn in array:
		if should_spawn:
			var new_obstacle = random_obstacle.instance()
			add_child(new_obstacle)
			new_obstacle.set_owner(get_owner())
			new_obstacle.global_position = obstacle_position
		
		obstacle_position.x += 16 #Obstacle size
	
	
