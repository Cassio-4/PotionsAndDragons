extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE,
	SEEK
}

@onready var detection_zone   = $DetectionZone
@onready var patrol_timer     = $PatrolTimer
@onready var navigation_agent = $"../NavigationAgent2D"

var weapon: Weapon  = null
var team: int = -1
var target: CharacterBody2D  = null
var actor: CharacterBody2D = null
var origin: Vector2 = Vector2.ZERO
var patrol_location = Vector2.ZERO
var patrol_location_reached = false

var current_state: int = -1:
	set(new_state):
		if new_state == current_state:
			return
		if new_state == State.PATROL:
			origin = global_position
			patrol_timer.start()
			patrol_location_reached = true
		current_state = new_state
		emit_signal("state_changed", current_state)

func _ready():
	current_state = State.SEEK

func initialize(a_actor: CharacterBody2D, a_weapon: Weapon, a_team: int):
	self.actor = a_actor
	self.weapon = a_weapon
	self.team = a_team

func navigation_setup():
	# Wait for a physics frame for safety 
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position

func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor.move_and_slide()
				actor.rotate_toward(patrol_location)
				if actor.global_position.distance_to(patrol_location) <= 5:
					patrol_location_reached = true
					patrol_timer.start()
					actor.velocity = Vector2.ZERO
		State.ENGAGE:
			if (self.target != null) and (weapon != null):
				actor.rotate_toward(target.global_position)
				if self.aiming_at_target():
					weapon.shoot()
			else:
				print("Engage state without weapon/player")
		State.SEEK:
			if target:
				navigation_agent.target_position = target.global_position
			if navigation_agent.is_navigation_finished():
				State.ENGAGE
				return
			var next_path_position = navigation_agent.get_next_path_position()
			actor.velocity = actor.velocity_toward(next_path_position)
			actor.move_and_slide()
		_:
			print("ERROR: Enemy state non-existent")

func aiming_at_target() -> bool:
	# Only shoot if aiming close to player position
	if target:
		var angle_to_target = actor.global_position.direction_to(target.global_position).angle()
		if abs(actor.rotation - angle_to_target) <= 0.1:
			return true
	return false

func _on_patrol_timer_timeout():
	var patrol_range = 60
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor.velocity = actor.velocity_toward(patrol_location)

func _on_detection_zone_body_entered(abody):
	if abody.has_method("get_team") and abody.get_team() != self.team:
		current_state = State.ENGAGE
		target = abody

func _on_detection_zone_body_exited(abody):
	if target and abody == target:
		current_state = State.SEEK
