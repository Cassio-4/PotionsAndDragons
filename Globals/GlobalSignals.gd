extends Node

signal projectile_fired(projectile_instance, team, location, direction)
signal player_lamp_changed(is_lamp_active)
signal player_spawned(player)
<<<<<<< Updated upstream
signal enemy_died(a_position)
=======

func change_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
>>>>>>> Stashed changes
