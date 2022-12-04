extends CharacterBody2D
class_name Enemy


@export var hp: int
@export var SPEED: int
var BASE_SAFE_MARGIN := safe_margin
@onready var hero = get_tree().get_first_node_in_group("hero")
@onready var hero_detector:= $HeroDetector as RayCast2D
@onready var detection_timer = $DetectionTimer as Timer
@onready var navigator = $Navigator as NavigationAgent2D

enum State {IDLE, STALK, SEEK, PANIC, RETREAT, ATTACK}


var state_map = {
	State.IDLE: idle,
	State.STALK: stalk,
	State.SEEK: seek,
	State.PANIC: panic,
	State.RETREAT: retreat,
	State.ATTACK: attack
}

var state: State = State.STALK


func _ready() -> void:
	navigator.max_speed = SPEED
	navigator.radius = $Collider.shape.radius + BASE_SAFE_MARGIN / 2


func _physics_process(delta: float) -> void:
	$State.text = State.keys()[state]
	state_map[state].call()


func idle():
	set_process(false)
	
	
func stalk():
	velocity = global_position.direction_to(hero.global_position) * SPEED
		
	move_and_slide()
	if get_real_velocity().length() < velocity.length() / 5:
		velocity = velocity.rotated(PI / 2)
		move_and_slide()
	
	
func seek():
	$Path.points = Array(navigator.get_nav_path()).map(func(it): return it - position)
	velocity = global_position.direction_to(navigator.get_next_location()) * SPEED
	navigator.set_velocity(velocity)
	
	
func panic():
	pass
	
	
func attack():
	pass
	
	
func retreat():
	pass
	

func _on_detection_timer_timeout() -> void:
	hero_detector.enabled = true
	hero_detector.global_rotation = hero_detector.global_position.angle_to_point(hero.global_position)
	hero_detector.force_raycast_update()
	var collider = hero_detector.get_collider()
	hero_detector.enabled = false
	
	if collider.owner == hero:
		if state == State.SEEK:
			state = State.STALK
		$Path.points = []
	else:
		state = State.SEEK
		navigator.target_location = hero.global_position


func _on_navigator_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

	move_and_slide()
