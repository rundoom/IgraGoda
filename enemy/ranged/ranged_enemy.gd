extends Enemy


func retreat():
	velocity = -global_position.direction_to(hero.global_position) * SPEED
	move_and_slide()
	if get_real_velocity().length() < SPEED / 5:
		state = State.ATTACK
	

func attack():
	velocity = Vector2.ZERO
	move_and_slide()


func _on_danger_zone_area_entered(area: Area2D) -> void: state = State.RETREAT


func _on_danger_zone_area_exited(area: Area2D) -> void: state = State.ATTACK


func _on_ranged_zone_area_entered(area: Area2D) -> void: state = State.ATTACK


func _on_ranged_zone_area_exited(area: Area2D) -> void: state = State.STALK
