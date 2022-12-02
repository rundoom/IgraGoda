extends CharacterBody2D


const SPEED := 400


func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("move_up", "move_down")
	var direction_x := Input.get_axis("move_left", "move_right")
	
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	move_and_slide()
