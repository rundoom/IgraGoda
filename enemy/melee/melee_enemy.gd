extends Enemy


var safe_margin_tween : Tween


func _on_charge_distance_area_entered(area: Area2D) -> void:
	state = State.ATTACK
	if safe_margin_tween: safe_margin_tween.kill()
	safe_margin_tween = create_tween()
	safe_margin_tween.tween_property(self, "safe_margin", 0, 0.5)


func _on_charge_distance_area_exited(area: Area2D) -> void:
	state = State.STALK
	if safe_margin_tween: safe_margin_tween.kill()
	safe_margin_tween = create_tween()
	safe_margin_tween.tween_property(self, "safe_margin", BASE_SAFE_MARGIN, 0.5)


func attack():
	velocity = global_position.direction_to(hero.global_position) * SPEED
		
	move_and_slide()
