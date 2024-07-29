extends Node

#OVERWORLD
var max_player_health
var max_player_mana
var player_health = 100
var player_mana = 100
#---------------------------------------------------------------------------------------------------------


#TURNBASED
var player_party_1_health = 100



#---------------------------------------------------------------------------------------------------------
func _ready():
	player_health = 100
	player_mana = 100


#OVERWORLD
func change_max_player_health(value):
	max_player_health = value
	
func change_max_player_mana(value):
	max_player_mana = value

func change_health(value):
	player_health += value
	if player_health <= 0: player_health = 0

func change_mana(value):
	player_mana += value
	if player_mana <= 0: player_mana = 0
	if player_mana > max_player_mana: player_mana = max_player_mana
	print("Mana value is: " + str(player_mana))
#---------------------------------------------------------------------------------------------------------
