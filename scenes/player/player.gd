extends KinematicBody2D

const ui_playerhealthicon = preload("res://scenes/ui/ui_playerhealthicon.tscn")
onready var player_reset_point = get_tree().get_nodes_in_group("player_reset_point")[0].global_position

const SPEED = 90
const MAX_HEALTH: int = 3
const BLINK_PERIOD: float = 0.1
const INVINCIBILITY_TIME: float = 3.0

var health: int = MAX_HEALTH setget set_health
var invincible: bool = false
var blink_time: float = 0.0
var blink_on: bool = true

# Beg obstacle spawner for health
var beg_timer = 0.0

func _ready():
	for i in range(MAX_HEALTH):
		var icon = ui_playerhealthicon.instance()
		$CanvasLayer/PlayerUI/HealthIconContainer.add_child(icon)
		icon.set_owner($CanvasLayer/PlayerUI/HealthIconContainer.get_owner())
		icon.set_on(true)
		

func _physics_process(delta):
	var vel = Vector2(0,0)
	
	if Input.is_action_pressed("left"):
		vel.x -= SPEED
	if Input.is_action_pressed("right"):
		vel.x += SPEED
	if Input.is_action_pressed("up"):
		vel.y -= SPEED
	if Input.is_action_pressed("down"):
		vel.y += SPEED
	
	if health < MAX_HEALTH:
		beg_timer += delta
		if health == 1:
			if beg_timer >= 5:
				Events.emit_signal("spawn_health")
				beg_timer -= 5
		else:
			if beg_timer >= 10:
				Events.emit_signal("spawn_health")
				beg_timer -= 10
	else:
		beg_timer = 0
	
	move_and_slide(vel)
	
	if is_being_crushed():
		do_take_damage()
		global_position = player_reset_point
	
	if invincible:
		blink_time += delta
		if blink_time >= BLINK_PERIOD:
			blink_time -= BLINK_PERIOD
			blink_on = !blink_on
		
		$Sprite.modulate.a = 1.0 if blink_on else 0.5
	else:
		$Sprite.modulate.a = 1.0
	
	$Sprite.animation = "run"
	$Sprite.speed_scale = 1.0 + (vel.y / SPEED * 0.5) 

func set_health(value: int):
	health = value
	
	if health <= 0:
		Events.emit_signal("game_over")
	
	for i in range(MAX_HEALTH):
		$CanvasLayer/PlayerUI/HealthIconContainer.get_child(i).set_on(i < health)

func is_being_crushed():
	return $Crushcast1.is_colliding() and $Crushcast2.is_colliding()

func _on_DamageArea_area_entered(area):
	do_take_damage()
	
func _on_PickupArea_area_entered(area):
	match area.get_type():
		"health":
			self.health = clamp(self.health + 1, 0, MAX_HEALTH)
			area.consume()
			

func do_take_damage():
	if invincible:
		return
	
	$DamageSound.play()
	trigger_invincibility()
	self.health -= 1
	

func trigger_invincibility():
	if invincible:
		return
	
	
	self.invincible = true
	blink_time = 0
	blink_on = true
	$DamageArea.monitoring = false
	$DamageArea.monitorable = false
	yield(get_tree().create_timer(INVINCIBILITY_TIME), "timeout")
	$DamageArea.monitoring = true
	$DamageArea.monitorable = true
	
	self.invincible = false
	


