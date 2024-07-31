extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_continue_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/MainMenuScreen.tscn")
