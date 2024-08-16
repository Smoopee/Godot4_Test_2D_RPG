extends Node

var save_file_path = "user://save/"
var save_file_name = "DjinnParty.tres"

#OVERWORLD
var max_player_health
var max_player_mana
var max_player_stamina
var player_health = 100
var player_mana = 100
var player_stamina = 100
#------------------------------------------------------------------------------
var current_party = []


func _ready():
	var djinnData = load_djinn_data()
	current_party = djinnData.party
	
	player_health = 100
	player_mana = 100
	player_stamina = 100

#OVERWORLD
func change_max_player_health(value):
	max_player_health = value
	
func change_max_player_mana(value):
	max_player_mana = value
	
func change_max_player_stamina(value):
	max_player_stamina = value
	
func change_health(value):
	player_health += value
	if player_health <= 0: player_health = 0
	if player_health > max_player_health: player_health = max_player_health

func change_mana(value):
	player_mana += value
	if player_mana <= 0: player_mana = 0
	if player_mana > max_player_mana: player_mana = max_player_mana

func change_stamina(value):
	player_stamina += value
	if player_stamina <= 0: player_stamina = 0
	if player_stamina > max_player_stamina: player_stamina = max_player_stamina

#-------------------------------------------------------------------------------

func load_djinn_data():
	return ResourceLoader.load(save_file_path + save_file_name)

