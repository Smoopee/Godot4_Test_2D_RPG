extends Node2D

var djinn_parent_scene = preload("res://scenes/TBScenes/Player/djinn_parent_scene.tscn")

@onready var player_spawn_location = $"../PositionContainer/HBoxContainer/PlayerSpawnLocation"
@onready var tb_battle_arena = $".."


var players_array = []
var skill1p1 

func _ready():
	var n = 0
	
	var djinn_parent = djinn_parent_scene.instantiate()
	player_spawn_location.get_child(n).add_child(djinn_parent)
	#player_spawn_location.get_child(n).texture_normal = tb_battle_arena.current_party[n].turn_sprite
	var party_member1 = djinn_parent
	
	party_member1.set_stats(tb_battle_arena.current_party[n])
	party_member1.instantiate_turn_sprite(player_spawn_location.get_child(n))
	party_member1.instantiate_default_attack()
	print("PartyMembers: party member 1 is = " + str(party_member1))
	print("PartyMembers: DA name = " + str(party_member1.default_attack_name))
	party_member1.instantiate_skill_one()
	print("PartyMembers: skill1 name = " + str(party_member1.skill_one_spellname))
	party_member1.instantiate_skill_two()
	players_array.push_back(party_member1)
	n += 1
	
	djinn_parent = djinn_parent_scene.instantiate()
	player_spawn_location.get_child(n).add_child(djinn_parent)
	#player_spawn_location.get_child(n).texture_normal = tb_battle_arena.current_party[n].turn_sprite
	var party_member2 = djinn_parent
	
	party_member2.set_stats(tb_battle_arena.current_party[n])
	party_member2.instantiate_turn_sprite(player_spawn_location.get_child(n))
	party_member2.instantiate_default_attack()
	party_member2.instantiate_skill_one()
	party_member2.instantiate_skill_two()
	players_array.push_back(party_member2)
	n += 1
	
	djinn_parent = djinn_parent_scene.instantiate()
	player_spawn_location.get_child(n).add_child(djinn_parent)
	#player_spawn_location.get_child(n).texture_normal = tb_battle_arena.current_party[n].turn_sprite
	var party_member3 = djinn_parent
	party_member3.set_stats(tb_battle_arena.current_party[n])
	party_member3.instantiate_turn_sprite(player_spawn_location.get_child(n))
	party_member3.instantiate_default_attack()
	party_member3.instantiate_skill_one()
	party_member3.instantiate_skill_two()
	players_array.push_back(party_member3)
	
	print("party is " + str(players_array))

	
	
