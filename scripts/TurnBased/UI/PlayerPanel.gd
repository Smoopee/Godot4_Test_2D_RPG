extends Panel

@onready var player_health_bar1 = $PartyMember1/VBoxContainer/PlayerHealthBar
@onready var player_health_bar2 = $PartyMember2/VBoxContainer/PlayerHealthBar
@onready var player_health_bar3 = $PartyMember3/VBoxContainer/PlayerHealthBar

@onready var player_mana_bar1 = $PartyMember1/VBoxContainer/PlayerManaBar
@onready var player_mana_bar2 = $PartyMember2/VBoxContainer/PlayerManaBar
@onready var player_mana_bar3 = $PartyMember3/VBoxContainer/PlayerManaBar

@onready var player_stamina_bar1 = $PartyMember1/VBoxContainer/PlayerStaminaBar
@onready var player_stamina_bar2 = $PartyMember2/VBoxContainer/PlayerStaminaBar
@onready var player_stamina_bar3 = $PartyMember3/VBoxContainer/PlayerStaminaBar


func _ready():
	player_health_bar1.value = Global.player1_health
	player_health_bar2.value = Global.player2_health
	player_health_bar3.value = Global.player3_health
	
	player_mana_bar1.value = Global.player1_mana
	player_mana_bar2.value = Global.player2_mana
	player_mana_bar3.value = Global.player3_mana
	
	player_stamina_bar1.value = Global.player1_stamina
	player_stamina_bar2.value = Global.player2_stamina
	player_stamina_bar3.value = Global.player3_stamina



func change_health(player):
	match player:
		1: 
			player_health_bar1.value = Global.player1_health
		2:
			player_health_bar2.value = Global.player2_health
		3:
			player_health_bar3.value = Global.player3_health

func change_mana(player):
	match player:
		1:
			player_mana_bar1.value = Global.player1_mana
		2:
			player_mana_bar2.value = Global.player2_mana
		3:
			player_mana_bar3.value = Global.player3_mana

func change_stamina(player):
	match player:
		1:
			player_stamina_bar1.value = Global.player1_stamina
		2:
			player_stamina_bar2.value = Global.player2_stamina
		3:
			player_stamina_bar3.value = Global.player3_stamina
