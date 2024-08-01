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
	
	print("My stamina is: " + str(Global.player1_stamina))

func _process(delta):
	player_health_bar1.value = Global.player1_health
	player_health_bar2.value = Global.player2_health
	player_health_bar3.value = Global.player3_health
	
	player_mana_bar1.value = Global.player1_mana
	player_mana_bar2.value = Global.player2_mana
	player_mana_bar3.value = Global.player3_mana
	
	player_stamina_bar1.value = Global.player1_stamina
	player_stamina_bar2.value = Global.player2_stamina
	player_stamina_bar3.value = Global.player3_stamina
