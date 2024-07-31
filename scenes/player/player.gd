extends CharacterBody2D
class_name Player

signal player_health_changed(new_health)
signal died
signal ingredient_picked(item)

var direction : Vector2 = Vector2()

@export var speed  : int = 150

@onready var team             = $Team
@onready var weapon           = $Weapon
@onready var health_stat      = $Health
@onready var camera_transform = $CameraTransform
@onready var lamp             = $Lamp
@onready var animation_player = $AnimationPlayer
@onready var inventory        = $Inventory

func _ready():
	weapon.initialize(team.team, 0.5)
	lamp.initialize(team.team)

func _unhandled_key_input(event):
	if event.is_action_pressed("lamp"):
		lamp.set_lamp_state()

func get_team() -> int:
	return team.team

func set_camera_transform(a_camera_path: NodePath):
	camera_transform.remote_path = a_camera_path

func read_input():
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction   = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction   = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction   = Vector2(1, 0)
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
		
	velocity = velocity.normalized()
	velocity = velocity * speed
	move_and_slide()
	
	weapon.look_at(get_global_mouse_position())
	
func _physics_process(_delta):
	read_input()
	update_animation()

func update_animation():
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
		var anim_direction = "down"
		if velocity.x < 0:   anim_direction = "left"
		elif velocity.x > 0: anim_direction = "right"
		elif velocity.y < 0: anim_direction = "up"
		animation_player.play("walk_" + anim_direction)

func handle_hit(damage, type=1):
	if type == 0:
		health_stat.health += damage/2
	else:
		health_stat.health -= damage
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		emit_signal("died")

func handle_pickup(item_type):
	inventory.item_pickup(item_type)
	emit_signal("ingredient_picked", inventory.ingredients)
	
