extends Projectile

enum Type {
	GREEN,
	PINK
}

var projectile_type:     int   = -1
var pink_sprite_region:  Rect2 = Rect2(0.485, 0, 14.189, 14.891)
var green_sprite_region: Rect2 = Rect2(16.392, 0, 14.608, 15)

func _ready():
	super._ready()
	self.random_projectile_type()
	self.set_projectile_sprite()

func random_projectile_type():
	var chance = randf() #between 0.0 and 0.1 inclusive
	if chance >= 0.3: #70% chance for shot to be pink
		projectile_type = Type.PINK
	else:
		projectile_type = Type.GREEN

func set_projectile_sprite():
	if int(projectile_type) == Type.PINK:
		sprite.region_rect = pink_sprite_region
	else:
		sprite.region_rect = green_sprite_region

func invert_projectile_type():
	projectile_type = not projectile_type
	self.set_projectile_sprite()
	

func _on_body_entered(body):
	if body.has_method("get_team"):
		if body.get_team() == self.team:
			return
		if body.has_method("handle_hit"):
			body.handle_hit(self.damage, self.projectile_type)
			queue_free()
	else:
		queue_free()
