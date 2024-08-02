extends Node

#OVERWORLD
var max_player_health
var max_player_mana
var max_player_stamina
var player_health = 100
var player_mana = 100
var player_stamina = 100
#------------------------------------------------------------------------------
#TURNBASED
var max_player1_health
var max_player2_health
var max_player3_health

var max_player1_mana
var max_player2_mana
var max_player3_mana

var max_player1_stamina
var max_player2_stamina
var max_player3_stamina

var player1_health = 100
var player2_health = 100
var player3_health = 100

var player1_mana = 100
var player2_mana = 100
var player3_mana = 100

var player1_stamina = 100
var player2_stamina = 100
var player3_stamina = 100

#-------------------------------------------------------------------------------
func _ready():
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
#TURNBASE

func change_max_player1_health(value):
	max_player1_health = value

func change_max_player2_health(value):
	max_player2_health = value

func change_max_player3_health(value):
	max_player3_health = value
	
func change_max_player1_mana(value):
	max_player1_mana = value

func change_max_player2_mana(value):
	max_player2_mana = value

func change_max_player3_mana(value):
	max_player3_mana = value
	
func change_max_player1_stamina(value):
	max_player1_stamina = value

func change_max_player2_stamina(value):
	max_player2_stamina = value
	
func change_max_player3_stamina(value):
	max_player3_stamina = value


func change_health_player1(value):
	player1_health += value
	if player1_health <= 0: player1_health = 0
	if player1_health > max_player1_health: player1_health = max_player1_health

func change_health_player2(value):
	player2_health += value
	if player2_health <= 0: player2_health = 0
	if player2_health > max_player2_health: player2_health = max_player2_health

func change_health_player3(value):
	player3_health += value
	if player3_health <= 0: player3_health = 0
	if player3_health > max_player3_health: player3_health = max_player3_health

func change_mana_player1(value):
	player1_mana += value
	if player1_mana <= 0: player1_mana = 0
	if player1_mana > max_player1_mana: player1_mana = max_player1_mana

func change_mana_player2(value):
	player2_mana += value
	if player2_mana <= 0: player2_mana = 0
	if player2_mana > max_player2_mana: player2_mana = max_player2_mana

func change_mana_player3(value):
	player3_mana += value
	if player3_mana <= 0: player3_mana = 0
	if player3_mana > max_player3_mana: player3_mana = max_player3_mana

func change_stamina_player1(value):
	player1_stamina += value
	if player1_stamina <= 0: player1_stamina = 0
	if player1_stamina > max_player1_stamina: player1_stamina = max_player1_stamina

func change_stamina_player2(value):
	player2_stamina += value
	if player2_stamina <= 0: player2_stamina = 0
	if player2_stamina > max_player2_stamina: player2_stamina = max_player2_stamina

func change_stamina_player3(value):
	player3_stamina += value
	if player3_stamina <= 0: player3_stamina = 0
	if player3_stamina > max_player3_stamina: player3_stamina = max_player3_stamina
	

