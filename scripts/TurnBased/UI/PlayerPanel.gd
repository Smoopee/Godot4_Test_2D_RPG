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

@onready var tb_battle_arena = $".."
@onready var party_members = $"../PartyMembers"


var party_member1
var party_member2
var party_member3

func _ready():
	print("The player's array is " + str(party_members.players_array))
	
	party_member1 = party_members.players_array[0]
	party_member2 = party_members.players_array[1]
	party_member3 = party_members.players_array[2]
	
	print("The party_member 1 is " + str(party_member1))
	
	player_health_bar1.value = party_member1.stats.health
	player_health_bar2.value = party_member2.stats.health
	player_health_bar3.value = party_member3.stats.health
	
	player_mana_bar1.value = party_member1.stats.mana
	player_mana_bar2.value = party_member2.stats.mana
	player_mana_bar3.value =party_member3.stats.mana
	
	player_stamina_bar1.value = party_member1.stats.stamina
	player_stamina_bar2.value = party_member2.stats.stamina
	player_stamina_bar3.value = party_member3.stats.stamina


func change_health():
	print("party member 1 is " + str(party_member1))
	player_health_bar1.value = party_member1.stats.health
	player_health_bar2.value = party_member2.stats.health
	player_health_bar3.value = party_member3.stats.health

func change_mana():
	player_mana_bar1.value = party_member1.stats.mana
	player_mana_bar2.value = party_member2.stats.mana
	player_mana_bar3.value = party_member3.stats.mana

func change_stamina():
	player_stamina_bar1.value = party_member1.stats.stamina
	player_stamina_bar2.value = party_member2.stats.stamina
	player_stamina_bar3.value =party_member3.stats.stamina
