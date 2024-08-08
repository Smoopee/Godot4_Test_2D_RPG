extends Node

var tb_enemy_scene = load("res://scenes/TBScenes/Enemy/tb_enemy.tscn")
var minotaur_scene = load("res://scenes/TBScenes/Enemy/minoutaur_tb_enemy.tscn")

@onready var spawn_location = $"../PositionContainer/HBoxContainer/EnemySpawnLocation"



var enemies_array = []

var rng = RandomNumberGenerator.new()
func _ready():
	var random_number_of_enemies = rng.randi_range(1,5)
	var n = 0
	
	
	while n <= random_number_of_enemies - 1:
		#var temp_n = n
		#print(temp_n)
		#
		#if temp_n == 1: 
			#temp_n = 2
		#elif temp_n == 2:
			#temp_n = 4
		#elif temp_n == 4:
			#temp_n = 1

		var tb_enemy = minotaur_scene.instantiate()
		spawn_location.get_child(n).add_child(tb_enemy)
		enemies_array.push_back(tb_enemy)
		n += 1
