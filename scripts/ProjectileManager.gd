extends Node2D

func handle_projectile_spawned(a_projectile: Projectile, speed: int, damage: int, a_team: int, a_position: Vector2, a_direction: Vector2):
	add_child(a_projectile)
	a_projectile.speed = speed
	a_projectile.damage = damage
	a_projectile.team = a_team
	a_projectile.global_position = a_position
	a_projectile.set_direction(a_direction)
	
