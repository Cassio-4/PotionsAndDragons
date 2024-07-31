extends Node2D



const Player = preload("res://scenes/player/player.tscn")
const GameOverScreen = preload("res://ui/GameOverScreen.tscn")
const PauseScreen = preload("res://ui/PauseScreen.tscn")
const MothEnemy = preload("res://scenes/enemies/moth/moth.tscn")
const MaggotEnemy = preload("res://scenes/enemies/maggot/maggot.tscn")

@onready var projectile_manager = $ProjectileManager
@onready var camera: Camera2D = $Camera2D
@onready var gui = $GUI
@onready var triggers = $Triggers
@onready var spawn_points: Dictionary = {
	"area1": [$"SpawnPoints/Area1SpawnPoints/Spawn1-1",$"SpawnPoints/Area1SpawnPoints/Spawn1-2", $"SpawnPoints/Area1SpawnPoints/Spawn1-3", $"SpawnPoints/Area1SpawnPoints/Spawn1-4", $"SpawnPoints/Area1SpawnPoints/Spawn1-5"],
	"area2": [$"SpawnPoints/Area2SpawnPoints/Spawn2-1", $"SpawnPoints/Area2SpawnPoints/Spawn2-2", $"SpawnPoints/Area2SpawnPoints/Spawn2-3", $"SpawnPoints/Area2SpawnPoints/Spawn2-4", $"SpawnPoints/Area2SpawnPoints/Spawn2-5", $"SpawnPoints/Area2SpawnPoints/Spawn2-6"],
	"area3": [$"SpawnPoints/Area3SpawnPoints/Spawn3-1", $"SpawnPoints/Area3SpawnPoints/Spawn3-2", $"SpawnPoints/Area3SpawnPoints/Spawn3-3", $"SpawnPoints/Area3SpawnPoints/Spawn3-4", $"SpawnPoints/Area3SpawnPoints/Spawn3-5", $"SpawnPoints/Area3SpawnPoints/Spawn3-6"]} 


var player = null
var num_enemies = 0

func _ready():
	randomize()
	GlobalSignals.projectile_fired.connect(projectile_manager.handle_projectile_spawned)
	GlobalSignals.enemy_died.connect($ItemManager.handle_spawn_item)
	spawn_player()
	GlobalSignals.emit_signal("player_spawned", player)
	setup_triggers()
	GlobalSignals.enemy_died.connect(check_battle_ended)

func check_battle_ended(_whatever):
	num_enemies -= 1
	if num_enemies == 0:
		$TileMap.set_layer_enabled(2, false)
	#var enemies = get_tree().get_nodes_in_group("enemy")
	#if enemies.is_empty():
		#$TileMap.set_layer_enabled(2, false)
		

func setup_triggers():
	self.triggers.initialize($TileMap)
	self.triggers.area1_entered.connect(start_area1)
	self.triggers.area2_entered.connect(start_area2)
	self.triggers.area3_entered.connect(start_area3)
	self.triggers.area_final_entered.connect(area_final)

func start_area1():
	for point: Node2D in spawn_points["area1"]:
		var enemy
		if randi_range(0, 1):
			enemy = MothEnemy.instantiate()
		else:
			enemy = MaggotEnemy.instantiate()
		enemy.global_position = point.global_position
		call_deferred("add_child", enemy)
		await enemy.is_node_ready()
		num_enemies += 1

func start_area2():
	for point: Node2D in spawn_points["area2"]:
		var enemy
		if randi_range(0, 1):
			enemy = MothEnemy.instantiate()
		else:
			enemy = MaggotEnemy.instantiate()
		enemy.global_position = point.global_position
		call_deferred("add_child", enemy)
		await enemy.is_node_ready()
		num_enemies += 1
		
func start_area3():
	for point: Node2D in spawn_points["area3"]:
		var enemy
		if randi_range(0, 1):
			enemy = MothEnemy.instantiate()
		else:
			enemy = MaggotEnemy.instantiate()
		enemy.global_position = point.global_position
		call_deferred("add_child", enemy)
		await enemy.is_node_ready()
		num_enemies += 1
	
func area_final():
	handle_player_won()

func spawn_player():
	player = Player.instantiate()
	player.global_position = $SpawnPoints/PlayerSpawnPosition.global_position
	add_child(player)
	player.set_camera_transform(camera.get_path())
	gui.set_player(player)
	player.died.connect(self.handle_player_lost)
	
func handle_player_lost():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	get_tree().paused = true

func handle_player_won():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	game_over.label_text.text = "YOU WIN!"
	get_tree().paused = true
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instantiate()
		add_child(pause_menu)
