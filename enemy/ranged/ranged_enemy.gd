extends Enemy


var is_at_dangerous_range := false
var is_at_shoot_range := false


func _physics_process(delta: float) -> void:
	var hero := get_tree().get_first_node_in_group("hero") as CharacterBody2D
	if is_at_dangerous_range:
		var target := global_position.direction_to(hero.global_position).angle() - PI
		velocity = Vector2.RIGHT.rotated(target) * SPEED
	elif !is_at_shoot_range and !is_at_dangerous_range:
		var target := global_position.direction_to(hero.global_position).angle()
		velocity = Vector2.RIGHT.rotated(target) * SPEED
	elif is_at_shoot_range and !is_at_dangerous_range:
		velocity = Vector2.ZERO
		
	move_and_slide()


func _on_danger_zone_area_entered(area: Area2D) -> void: is_at_dangerous_range = true


func _on_danger_zone_area_exited(area: Area2D) -> void: is_at_dangerous_range = false


func _on_ranged_zone_area_entered(area: Area2D) -> void: is_at_shoot_range = true


func _on_ranged_zone_area_exited(area: Area2D) -> void: is_at_shoot_range = false
