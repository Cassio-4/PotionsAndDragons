extends CanvasLayer

func _on_button_play_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_quit_pressed():
	get_tree().quit()
