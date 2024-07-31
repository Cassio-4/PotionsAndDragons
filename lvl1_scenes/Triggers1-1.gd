extends Node2D

var tilemap: TileMap = null

func initialize(tilemap: TileMap):
	self.tilemap = tilemap

func _on_area_trigger_1_body_entered(body):
	enable_barrier_layer(body)

func _on_area_trigger_2_body_entered(body):
	enable_barrier_layer(body)

func _on_area_trigger_3_body_entered(body):
	enable_barrier_layer(body)

func _on_area_trigger_4_body_entered(body):
	enable_barrier_layer(body)

func enable_barrier_layer(body):
	if body.is_in_group("player"):
		tilemap.set_layer_enabled(2, true)
