extends Area2D

@onready var animation_player = $AnimationPlayer
var is_lamp_active: bool = false
var team = -1

func _ready():
	set_lamp_state()

func initialize(a_team):
	self.team = a_team

func set_lamp_state():
	is_lamp_active = not is_lamp_active
	GlobalSignals.emit_signal("player_lamp_changed", is_lamp_active)
	if is_lamp_active:
		animation_player.play("light_turn_on")
	else:
		animation_player.play("light_turn_off")

func _on_area_entered(area):
	if area.has_method("get_team") and area.get_team() != self.team: 
		if area.has_method("invert_projectile_type"):
			area.invert_projectile_type()

func _on_area_exited(area):
	if area.has_method("get_team") and area.get_team() != self.team: 
		if area.has_method("invert_projectile_type"):
			area.invert_projectile_type()
