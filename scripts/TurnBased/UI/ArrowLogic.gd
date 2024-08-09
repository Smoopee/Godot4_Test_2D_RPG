extends Control

var arrow_inicator_scene = load("res://scenes/TBScenes/TBBattleScene/arrow_indicator.tscn")

@onready var party_members = $"../PartyMembers"
@onready var enemies = $"../Enemies"
@onready var enemy_spawn_location = $"../PositionContainer/HBoxContainer/EnemySpawnLocation"
@onready var player_spawn_location = $"../PositionContainer/HBoxContainer/PlayerSpawnLocation"
@onready var enemy_arrows = $EnemyArrows
@onready var player_arrows = $PlayerArrows



#DECLARES AND SETS STATES-------------------------------------------------------
enum State{
	SINGLE,
	MULTI,
	AOE,
	FRIENDLY_SINGLE,
	FRIENDLY_MULTI,
	FRIENDLY_AOE,
}

var current_state: int = -1: set = set_state

func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state
#-------------------------------------------------------------------------------

var arrow_indicator
var first_alive_enemy
var first_alive_friendly


var x_position = 0
var y_position = 0
var x_scale = .1
var y_scale = .1
var initial_position = Vector2(x_position,y_position)
var initial_scale =Vector2(x_scale, y_scale)

var enemy_arrows_array = []
var player_arrows_array = []

func _ready():
	arrow_creator()
	arrow_clear()

func arrow_creator():
	for i in enemies.enemies_array.size():
		arrow_indicator = arrow_inicator_scene.instantiate()
		enemy_arrows_array.push_back(arrow_indicator)
		enemy_spawn_location.get_child(i).add_child(arrow_indicator)
		arrow_indicator.scale = initial_scale
		arrow_indicator.global_position += initial_position
	
	for i in party_members.players_array.size():
		arrow_indicator = arrow_inicator_scene.instantiate()
		player_arrows_array.push_back(arrow_indicator)
		player_spawn_location.get_child(i).add_child(arrow_indicator)
		arrow_indicator.scale = initial_scale
		arrow_indicator.global_position +=  initial_position

func arrow_tracker():
	for i in enemy_arrows.get_children().size():
		enemy_arrows.get_child(i).scale = initial_scale
		enemy_arrows.get_child(i).global_position = enemies.enemies_array[i].global_position + initial_position
	
	for i in player_arrows.get_children().size():
		player_arrows.get_child(i).scale = initial_scale
		player_arrows.get_child(i).global_position = party_members.players_array[i].global_position + initial_position

#func _on_position_container_resized():
	#if enemy_arrows == null: return
	#print("Before xpos is " + str(get_viewport().size.x))
	#
	#x_scale = get_viewport().size.x * .0001
	#y_scale = get_viewport().size.y * .0001
	#initial_scale = Vector2(x_scale, y_scale)
	#
	#x_position = get_viewport().size.x * .13
	#y_position = get_viewport().size.y * .05
	#initial_position = Vector2(x_position, y_position)
	#print("After xpos is " + str(initial_position))
#
	#arrow_tracker()

func arrow_initializer(targeting):
	arrow_clear()
	
	for i in enemies.enemies_array.size():
		if enemies.enemies_array[i].current_state == 1:
			first_alive_enemy = i
			break
			
	for i in party_members.players_array.size():
		if party_members.players_array[i].current_state == 1:
			first_alive_friendly = i
			break
	
	
	match targeting:
		"Single":
			set_state(State.SINGLE)
			enemy_arrows_array[first_alive_enemy].visible = true
		"Multi":
			set_state(State.MULTI)
			arrow_multi()
		"AOE":
			set_state(State.AOE)
			arrow_duplicator_enemy()
		"Friendly_Single":
			set_state(State.FRIENDLY_SINGLE)
		"Friendly_Multi":
			set_state(State.FRIENDLY_MULTI)
			arrow_multi_friendly()
		"Friendly_AOE":
			set_state(State.FRIENDLY_AOE)
			arrow_duplicator_friendly()
			
func arrow_duplicator_enemy():
	for i in enemies.enemies_array.size():
		
		#SKIPS DEAD ENEMIES
		if enemies.enemies_array[i].current_state == 0:
			continue
		
		#RESUMES MAKING REST OF ARROWS
		enemy_arrows_array[i].visible = true

func arrow_duplicator_friendly():
	for i in party_members.players_array.size():
		
		#SKIPS DEAD PLAYERS
		if party_members.players_array[i].current_state == 0:
			continue
		
		#RESUMES MAKING REST OF ARROWS
		player_arrows_array[i].visible = true

func arrow_multi(current_enemy_index = first_alive_enemy):
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1
	
	if right_enemy_index + 1 > enemies.enemies_array.size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = enemies.enemies_array.size()-1
	
	enemy_arrows_array[current_enemy_index].visible = true
	enemy_arrows_array[current_enemy_index].scale = initial_scale
	
	if current_enemy_index != right_enemy_index:
		if enemies.enemies_array[right_enemy_index].current_state == 1:
			enemy_arrows_array[right_enemy_index].visible = true
			enemy_arrows_array[right_enemy_index].global_position += Vector2(1,1)
			enemy_arrows_array[right_enemy_index].scale = Vector2(.05, .05)

	if current_enemy_index != left_enemy_index:
		if enemies.enemies_array[left_enemy_index].current_state == 1:
			enemy_arrows_array[left_enemy_index].visible = true
			enemy_arrows_array[left_enemy_index].global_position += Vector2(1,1)
			enemy_arrows_array[left_enemy_index].scale = Vector2(.05, .05)

func arrow_multi_friendly(current_player_index = first_alive_friendly):
	var right_player_index = current_player_index + 1
	var left_player_index = current_player_index - 1
	
	if right_player_index + 1 > party_members.players_array.size():
		right_player_index = 0
	
	if current_player_index - 1 < 0:
		left_player_index = party_members.players_array.size()-1
	
	player_arrows_array[current_player_index].visible = true
	player_arrows_array[current_player_index].scale = initial_scale
	
	if current_player_index != right_player_index:
		if party_members.players_array[right_player_index].current_state == 1:
			player_arrows_array[right_player_index].visible = true
			player_arrows_array[right_player_index].global_position += Vector2(1,1)
			player_arrows_array[right_player_index].scale = Vector2(.05, .05)

	if current_player_index != left_player_index:
		if party_members.players_array[left_player_index].current_state == 1:
			player_arrows_array[left_player_index].visible = true
			player_arrows_array[left_player_index].global_position += Vector2(1,1)
			player_arrows_array[left_player_index].scale = Vector2(.05, .05)

func arrow_repositioner(target):
	arrow_clear()
	var enemy_index = enemies.enemies_array.find(target)
	var player_index = party_members.players_array.find(target)

	match current_state:
		State.SINGLE:
			enemy_arrows_array[enemy_index].visible = true
		State.MULTI:
			arrow_multi(enemy_index)
		State.AOE:
			arrow_duplicator_enemy()
		State.FRIENDLY_SINGLE:
			pass
		State.FRIENDLY_MULTI:
			arrow_multi_friendly(player_index)
		State.FRIENDLY_AOE:
			arrow_duplicator_friendly()


func arrow_start():
	for i in enemy_arrows_array.size():
		if enemy_arrows_array[i].visible == true:
			enemy_arrows_array[i].arrow_blink()
		
	for i in player_arrows_array.size():
		if player_arrows_array[i].visible == true:
			player_arrows_array[i].arrow_blink()


func arrow_stop():
	for i in enemy_arrows_array.size():
		enemy_arrows_array[i].arrow_stop()
		
	for i in player_arrows_array.size():
		player_arrows_array[i].arrow_stop()


func arrow_clear():
	arrow_stop()
	for i in enemy_arrows_array.size():
		enemy_arrows_array[i].visible = false
		enemy_arrows_array[i].global_position += initial_position
		enemy_arrows_array[i].scale = initial_scale

	
	for i in player_arrows_array.size():
		player_arrows_array[i].visible = false
		player_arrows_array[i].global_position += initial_position
		player_arrows_array[i].scale = initial_scale








