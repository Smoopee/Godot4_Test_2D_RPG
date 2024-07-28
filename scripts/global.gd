extends Node


var player_health = 100
var player_mana = 100


func _ready():
	pass
#
func change_health(value):
	player_health += value

func change_mana(value):
	player_mana += value
