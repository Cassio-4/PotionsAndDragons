extends Node2D

signal state_changed(new_state)

enum State {
	SLEEP,
	ATTACK,
	SEEK
}

@onready var detection_zone   = $DetectionZone
@onready var navigation_agent = $"../NavigationAgent2D"

var weapon: MothWeapon  = null
var team: int = -1
var is_player_lamp_active: bool = false
var target: CharacterBody2D  = null
var actor: CharacterBody2D = null
var origin: Vector2 = Vector2.ZERO

var current_state: int = -1:
	set(new_state):
		if new_state == current_state:
			return
		current_state = new_state
		emit_signal("state_changed", current_state)

func _ready():
	current_state = State.SLEEP
	GlobalSignals.player_lamp_changed.connect(self.lamp_changed)
	GlobalSignals.player_spawned.connect(self.navigation_setup)
	
func initialize(a_actor: CharacterBody2D, a_weapon: MothWeapon, a_team: int):
	self.actor = a_actor
	self.weapon = a_weapon
	self.team = a_team

func navigation_setup(a_player):
	# Wait for a physics frame for safety 
	await get_tree().physics_frame
	target = a_player
	if target:
		navigation_agent.target_position = target.global_position

func _physics_process(_delta):
	match current_state:
		State.SLEEP:
			actor.velocity = Vector2.ZERO
		State.SEEK:
			if target:
				navigation_agent.target_position = target.global_position
			else:
				return
			#if navigation_agent.is_navigation_finished():
				##current_state = State.ATTACK
				#return
			var next_path_position = navigation_agent.get_next_path_position()
			actor.velocity = actor.velocity_toward(next_path_position)
			actor.move_and_slide()
		State.ATTACK:
			actor.velocity = Vector2.ZERO
			if (self.target != null) and (weapon != null):
				weapon.stab(target)
		_:
			print("ERROR: Enemy state non-existent")

func lamp_changed(is_lamp_active):
	if is_lamp_active:
		current_state = State.SEEK
		var ov_bodies = detection_zone.get_overlapping_bodies()
		for body in ov_bodies:
			if body.has_method("get_team") and body.get_team() != self.team:
				current_state = State.ATTACK
	else:
		current_state = State.SLEEP
	is_player_lamp_active = is_lamp_active

func _on_detection_zone_body_entered(abody):
	if not is_player_lamp_active:
		return
	if abody.has_method("get_team") and abody.get_team() != self.team:
		current_state = State.ATTACK
		target = abody

func _on_detection_zone_body_exited(abody):
	if target and abody == target and is_player_lamp_active:
		current_state = State.SEEK
	if not is_player_lamp_active:
		current_state = State.SLEEP
