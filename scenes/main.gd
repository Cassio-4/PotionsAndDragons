extends Node2D

const Player = preload("res://scenes/player/player.tscn")
const GameOverScreen = preload("res://ui/GameOverScreen.tscn")
const PauseScreen = preload("res://ui/PauseScreen.tscn")

@onready var projectile_manager = $ProjectileManager
@onready var camera: Camera2D = $Camera2D
@onready var gui = $GUI
var player = null

func _ready():
	randomize()
	GlobalSignals.projectile_fired.connect(projectile_manager.handle_projectile_spawned)
	GlobalSignals.enemy_died.connect($ItemManager.handle_spawn_item)
	spawn_player()
	GlobalSignals.emit_signal("player_spawned", player)

func spawn_player():
	player = Player.instantiate()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	gui.set_player(player)
	player.died.connect(self.handle_player_lost)
	
func handle_player_lost():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instantiate()
		add_child(pause_menu)
