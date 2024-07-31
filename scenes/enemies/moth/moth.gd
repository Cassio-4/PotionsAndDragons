extends Enemy

@onready var animation_player = $AnimationPlayer

func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team, 0.5)
	weapon.visible = false

func late_ai_target_setup(target):
	ai.target = target

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
