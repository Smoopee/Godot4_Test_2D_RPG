extends Node2D

var player1_scene = load ("res://scenes/TBScenes/Player/player1_for_turn_base.tscn")
var player2_scene = load("res://scenes/TBScenes/Player/player2_for_turn_base.tscn")
var player3_scene = load("res://scenes/TBScenes/Player/player3_for_turn_base.tscn")

@onready var player_spawn_location = $"../PositionContainer/HBoxContainer/PlayerSpawnLocation"


var players_array = []

func _ready():
	var n = 0
	var player1 = player1_scene.instantiate()
	player_spawn_location.get_child(n).add_child(player1)
	players_array.push_back(player1.get_child(0))
	n += 1
	var player2 = player2_scene.instantiate()
	player_spawn_location.get_child(n).add_child(player2)
	players_array.push_back(player2.get_child(0))
	n += 1
	
	var player3 = player3_scene.instantiate()
	player_spawn_location.get_child(n).add_child(player3)
	players_array.push_back(player3.get_child(0))
	print("Players array is " + str(players_array))
