extends Node2D
class_name BasicRanged 


@export var Bullet : PackedScene
@onready var shoot_cooldown := $ShootCooldown as Timer
@export_range(0, PI, 0.1) var SPREAD : float
@export var BULLET_COUNT := 1
@export var BULLET_SPEED_SPREAD := 0
@export var BULLET_SPREAD := 0

@export var MAG_SIZE : int
@onready var current_mag := MAG_SIZE

@export var AUTOMATIC : bool :
	set(value):
		AUTOMATIC = value
		_decide_firemod(value)
		
var INPUT_ACTION := func() -> bool: return Input.is_action_just_pressed("mouse_left")

enum State {SHOOT, SHOOT_COOLDOWN, RELOAD, IDLE}

var state: State = State.IDLE

var state_map = {
	State.SHOOT: shoot,
	State.SHOOT_COOLDOWN: shoot_cooldown,
	State.RELOAD: reload,
	State.IDLE: idle
}


func _physics_process(delta: float) -> void:
	$State.text = State.keys()[state]
	
	var mouse_pos := get_global_mouse_position()
	global_rotation = global_position.angle_to_point(mouse_pos)
	scale.y = 1 if cos(rotation) > 0 else -1
	
	state_map[state].call()


func shoot():
	if current_mag == 0:
		state = State.RELOAD
		return
	if !shoot_cooldown.is_stopped():
		state = State.SHOOT_COOLDOWN
		return
		
	var bullet_direction := $BulletOuput.global_rotation as float
	for i in BULLET_COUNT:
		var bullet := Bullet.instantiate()
		bullet.speed = randi_range(bullet.speed - BULLET_SPEED_SPREAD, bullet.speed + BULLET_SPEED_SPREAD) 
		bullet.global_position = $BulletOuput.global_position
		bullet.global_rotation = randfn(global_rotation, BULLET_SPREAD)
		var level = get_tree().current_scene
		level.add_child(bullet)
	shoot_cooldown.start()
	current_mag -= 1


func reload():
	pass
	$ReloadTime.start()
	
	
func idle():
	if INPUT_ACTION.call(): state = State.SHOOT


func _on_reload_time_timeout() -> void:
	current_mag = MAG_SIZE


func _decide_firemod(is_automatic: bool):
		if is_automatic == true:
			INPUT_ACTION = func() -> bool: return Input.is_action_pressed("mouse_left")
		else:
			INPUT_ACTION = func() -> bool: return Input.is_action_just_pressed("mouse_left")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload") and current_mag != MAG_SIZE:
		$ReloadTime.start()

