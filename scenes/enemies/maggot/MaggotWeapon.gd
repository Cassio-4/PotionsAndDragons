extends Node2D
class_name MaggotWeapon

@export var Bullet : PackedScene 
@onready var projectile_spawn     = $ProjectileSpawn
@onready var attack_cooldown      = $AttackCooldown

var team: int = -1
@export var bullet_speed: int = 4
@export var damage: int = 10

func initialize(a_team: int, a_cooldown: float):
	self.team = a_team
	self.attack_cooldown.wait_time = a_cooldown

func shoot(a_target):
	if attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instantiate()
		var direction = projectile_spawn.global_position.direction_to(a_target.global_position).normalized()
		GlobalSignals.emit_signal("projectile_fired", bullet_instance, bullet_speed, damage, team, 
								projectile_spawn.global_position, direction)
		attack_cooldown.start()
	else:
		pass
