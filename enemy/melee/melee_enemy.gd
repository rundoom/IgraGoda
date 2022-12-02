extends Enemy


var BASE_SAFE_MARGIN := safe_margin
var safe_margin_tween : Tween


func _physics_process(delta: float) -> void:
	var hero := get_tree().get_first_node_in_group("hero") as CharacterBody2D
	var target := global_position.direction_to(hero.global_position).angle()
	velocity = Vector2.RIGHT.rotated(target) * SPEED
		
	move_and_slide()
	

func _on_charge_distance_area_entered(area: Area2D) -> void:
	if safe_margin_tween: safe_margin_tween.kill()
	safe_margin_tween = create_tween()
	safe_margin_tween.tween_property(self, "safe_margin", 0, 0.5)


func _on_charge_distance_area_exited(area: Area2D) -> void:
	if safe_margin_tween: safe_margin_tween.kill()
	safe_margin_tween = create_tween()
	safe_margin_tween.tween_property(self, "safe_margin", BASE_SAFE_MARGIN, 0.5)
