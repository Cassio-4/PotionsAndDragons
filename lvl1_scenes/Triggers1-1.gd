extends Node2D

var tilemap: TileMap = null

signal area1_entered
signal area2_entered
signal area3_entered
signal area_final_entered


func initialize(a_tilemap: TileMap):
	self.tilemap = a_tilemap

func _on_area_trigger_1_body_entered(body):
	enable_barrier_layer(body, "area1_entered")

func _on_area_trigger_2_body_entered(body):
	enable_barrier_layer(body, "area2_entered" )

func _on_area_trigger_3_body_entered(body):
	enable_barrier_layer(body, "area3_entered")

func enable_barrier_layer(body, a_signal):
	if body.is_in_group("player"):
		tilemap.set_layer_enabled(2, true)
		emit_signal(a_signal)
		if a_signal == "area1_entered":
			$AreaTrigger1/CollisionShape2D.queue_free()
		elif a_signal == "area2_entered":
			$AreaTrigger2/CollisionShape2D.queue_free()
		elif a_signal == "area3_entered":
			$AreaTrigger3/CollisionShape2D.queue_free()
		

func _on_area_trigger_final_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("area_final_entered")
