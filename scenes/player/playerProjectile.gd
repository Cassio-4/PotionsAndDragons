extends Projectile
	
	
func set_direction(adirection: Vector2):
	self.direction = adirection
	rotation = adirection.angle()
	
func _physics_process(_delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func invert_projectile_type():
	projectile_type = not projectile_type
	set_projectile_sprite()

func _on_kill_timer_timeout():
	queue_free()

func _on_body_entered(a_body):
	if a_body.has_method("get_team"):
		if a_body.get_team() == self.team:
			return
		if a_body.has_method("handle_hit"):
			a_body.handle_hit(self.projectile_type, 10)
			queue_free()
	else:
		queue_free()

func get_team():
	return self.team
