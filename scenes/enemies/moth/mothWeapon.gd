extends Node2D
class_name MothWeapon

@export var Stab : PackedScene 
@onready var projectile_spawn     = $ProjectileSpawn
@onready var attack_cooldown      = $AttackCooldown

var team: int = -1
@export var bullet_speed: int = 10
@export var damage: int = 25

func initialize(a_team: int, a_cooldown: float):
	self.team = a_team
	self.attack_cooldown.wait_time = a_cooldown

func stab(a_target):
	if attack_cooldown.is_stopped() and Stab != null:
		var stab_instance = Stab.instantiate()
		var direction = projectile_spawn.global_position.direction_to(a_target.global_position).normalized()
		GlobalSignals.emit_signal("projectile_fired", stab_instance, bullet_speed, damage, team, 
								projectile_spawn.global_position, direction)
		attack_cooldown.start()
	else:
		pass
