extends TextureRect


func _ready():
	pass

func process():
	material.set_shader_param("scroll_speed", Global.vertical_scroll_speed)
