extends CharacterBody2D
class_name Enemy

@onready var health_stat = $Health
@onready var ai          = $AI
@onready var weapon      = $Weapon
@onready var team        = $Team
@export var movement_speed: int

func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team, 0.5)

func velocity_toward(alocation: Vector2) -> Vector2:
	return global_position.direction_to(alocation) * movement_speed

func get_team() -> int:
	return team.team

func handle_hit(damage):
	health_stat.health -= damage
	if health_stat.health <= 0:
		queue_free()
