extends CharacterBody2D
class_name Maggot

@onready var health_stat      = $Health
@onready var ai               = $MaggotAI
@onready var weapon: MaggotWeapon = $Weapon
@onready var team             = $Team
@onready var animation_player = $AnimationPlayer
@export var speed: int = 100

func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team, 0.75)

func _physics_process(_delta):
	update_animations()

func update_animations():
	var direction = "down"
	if velocity.length() == 0:
		var last_animation_played = animation_player.assigned_animation
		if "left" in last_animation_played:
			animation_player.play("left_idle")
		elif "right" in last_animation_played:
			animation_player.play("right_idle")
		elif "up" in last_animation_played:
			animation_player.play("up_idle")
		elif "down" in last_animation_played:
			animation_player.play("down_idle")
		
		if animation_player.is_playing():
			animation_player.stop()
	else:
		if velocity.x < 0:   direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		animation_player.play("walk_" + direction)

func velocity_toward(alocation: Vector2) -> Vector2:
	return global_position.direction_to(alocation) * speed

func get_team() -> int:
	return team.team

func handle_hit(damage):
	health_stat.health -= damage
	if health_stat.health <= 0:
		queue_free()
