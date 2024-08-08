extends Node2D

var player1_scene = load ("res://scenes/TBScenes/Player/player1_for_turn_base.tscn")
var player2_scene = load("res://scenes/TBScenes/Player/player2_for_turn_base.tscn")
var player3_scene = load("res://scenes/TBScenes/Player/player3_for_turn_base.tscn")

@onready var player_spawn_location = $"../PositionContainer/HBoxContainer/PlayerSpawnLocation"



var players_array = []

func _ready():
	var n = 0
	var player1 = player1_scene.instantiate()
	players_array.push_back(player1)
	player_spawn_location.get_child(n).add_child(player1)
	n += 1
	var player2 = player2_scene.instantiate()
	players_array.push_back(player2)
	player_spawn_location.get_child(n).add_child(player2)
	n += 1
	
	var player3 = player3_scene.instantiate()
	players_array.push_back(player3)
	player_spawn_location.get_child(n).add_child(player3)
	
