extends Area2D
class_name Projectile

@export var speed : int = 5
@onready var kill_timer = $KillTimer
@onready var sprite = $Sprite2D

var direction: Vector2 = Vector2.ZERO
var team:      int     = -1
var damage:    int     = 0

func _ready():
	kill_timer.start()
	
func set_direction(adirection: Vector2):
	self.direction = adirection
	rotation = adirection.angle()
	
func _physics_process(_delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func _on_kill_timer_timeout():
	queue_free()

func get_team():
	return self.team

func _on_body_entered(body):
	if body.has_method("get_team"):
		if body.get_team() == self.team:
			return
		if body.has_method("handle_hit"):
			body.handle_hit(self.damage)
			queue_free()
	else:
		queue_free()
