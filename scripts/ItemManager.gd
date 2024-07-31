extends Node2D

@export var Ingredient : PackedScene 

func handle_spawn_item(a_position):
	var ingredient_instance = Ingredient.instantiate()
	ingredient_instance.initialize(a_position)
	call_deferred("add_child", ingredient_instance)
