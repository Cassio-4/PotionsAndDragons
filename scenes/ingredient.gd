extends Node2D

var ingredient3_sprite_region:  Rect2 = Rect2(37, 3, 22, 26)
var ingredient2_sprite_region:  Rect2 = Rect2(7, 35, 17, 23)
var ingredient1_sprite_region:  Rect2 = Rect2(33, 37, 30, 25)
var type: int = -1

func initialize(a_position):
	self.type = randi_range(1, 3)
	self.set_sprite_region()
	self.global_position = a_position

func set_sprite_region():
	if type == 1:
		$Sprite2D.region_rect = ingredient1_sprite_region
	elif type == 2:
		$Sprite2D.region_rect = ingredient2_sprite_region
	elif type == 3:
		$Sprite2D.region_rect = ingredient3_sprite_region
	else:
		print("ERROR: ingredient type is invalid")
		queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("handle_pickup"):
		body.handle_pickup(self.type)
	queue_free()
