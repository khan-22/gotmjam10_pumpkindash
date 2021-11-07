extends Sprite


var time = 0.0
var start_position

func _ready():
	start_position = position
	pass

func _process(delta):
	time += delta
	position.y = start_position.y + (sin(time) * 0.5 + 0.5) * 4.0
