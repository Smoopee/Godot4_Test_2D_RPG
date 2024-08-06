extends Control

var arrow_inicator_scene = load("res://scenes/TBScenes/TBBattleScene/arrow_indicator.tscn")

@onready var party_members = $"../PartyMembers"
@onready var enemies = $"../Enemies"
@onready var spawn_location = $"../SpawnLocation"
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

func _ready():
	for i in enemies.get_children().size():
		arrow_indicator = arrow_inicator_scene.instantiate()
		enemy_arrows.add_child(arrow_indicator)
		arrow_indicator.scale = Vector2(.2, .2)
		arrow_indicator.global_position = enemies.get_child(i).global_position + Vector2(55,5)
	
	for i in party_members.get_children().size():
		arrow_indicator = arrow_inicator_scene.instantiate()
		player_arrows.add_child(arrow_indicator)
		arrow_indicator.scale = Vector2(.2, .2)
		arrow_indicator.global_position = party_members.get_child(i).global_position + Vector2(55,5)
		
	arrow_clear()
	

func arrow_initializer(targeting):
	arrow_clear()
	
	for i in enemies.get_children().size():
		if enemies.get_child(i).current_state == 1:
			first_alive_enemy = i
			break
			
	for i in party_members.get_children().size():
		if party_members.get_child(i).current_state == 1:
			first_alive_friendly = i
			break
	
	
	match targeting:
		"Single":
			set_state(State.SINGLE)
			enemy_arrows.get_child(first_alive_enemy).visible = true
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
	for i in enemies.get_children().size():
		
		#SKIPS DEAD ENEMIES
		if enemies.get_child(i).current_state == 0:
			continue
		
		#RESUMES MAKING REST OF ARROWS
		enemy_arrows.get_child(i).visible = true

func arrow_duplicator_friendly():
	for i in party_members.get_children().size():
		
		#SKIPS DEAD PLAYERS
		if party_members.get_child(i).current_state == 0:
			continue
		
		#RESUMES MAKING REST OF ARROWS
		player_arrows.get_child(i).visible = true

func arrow_multi(current_enemy_index = first_alive_enemy):
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1
	
	if right_enemy_index + 1 > enemies.get_children().size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = enemies.get_children().size()-1
	
	enemy_arrows.get_child(current_enemy_index).visible = true
	enemy_arrows.get_child(current_enemy_index).scale = Vector2(.2, .2)
	
	if current_enemy_index != right_enemy_index:
		if enemies.get_child(right_enemy_index).current_state == 1:
			enemy_arrows.get_child(right_enemy_index).visible = true
			enemy_arrows.get_child(right_enemy_index).global_position = enemies.get_child(right_enemy_index).global_position + Vector2(35,5)
			enemy_arrows.get_child(right_enemy_index).scale = Vector2(.1, .1)

	if current_enemy_index != left_enemy_index:
		if enemies.get_child(left_enemy_index).current_state == 1:
			enemy_arrows.get_child(left_enemy_index).visible = true
			enemy_arrows.get_child(left_enemy_index).global_position = enemies.get_child(left_enemy_index).global_position + Vector2(35,5)
			enemy_arrows.get_child(left_enemy_index).scale = Vector2(.1, .1)

func arrow_multi_friendly(current_player_index = first_alive_friendly):
	var right_player_index = current_player_index + 1
	var left_player_index = current_player_index - 1
	
	if right_player_index + 1 > party_members.get_children().size():
		right_player_index = 0
	
	if current_player_index - 1 < 0:
		left_player_index = party_members.get_children().size()-1
	
	player_arrows.get_child(current_player_index).visible = true
	player_arrows.get_child(current_player_index).scale = Vector2(.2, .2)
	
	if current_player_index != right_player_index:
		if party_members.get_child(right_player_index).current_state == 1:
			player_arrows.get_child(right_player_index).visible = true
			player_arrows.get_child(right_player_index).global_position = party_members.get_child(right_player_index).global_position + Vector2(35,5)
			player_arrows.get_child(right_player_index).scale = Vector2(.1, .1)

	if current_player_index != left_player_index:
		if party_members.get_child(left_player_index).current_state == 1:
			player_arrows.get_child(left_player_index).visible = true
			player_arrows.get_child(left_player_index).global_position = party_members.get_child(left_player_index).global_position + Vector2(35,5)
			player_arrows.get_child(left_player_index).scale = Vector2(.1, .1)

func arrow_repositioner(target):
	arrow_clear()

	match current_state:
		State.SINGLE:
			enemy_arrows.get_child(target.get_index()).visible = true
		State.MULTI:
			arrow_multi(target.get_index())
		State.AOE:
			arrow_duplicator_enemy()
		State.FRIENDLY_SINGLE:
			pass
		State.FRIENDLY_MULTI:
			print("mult target index is: " + str(target.get_index()))
			arrow_multi_friendly(target.get_index())
		State.FRIENDLY_AOE:
			arrow_duplicator_friendly()


func arrow_start():
	for i in enemy_arrows.get_children().size():
		if enemy_arrows.get_child(i).visible == true:
			enemy_arrows.get_child(i).arrow_blink()
		
	for i in player_arrows.get_children().size():
		if player_arrows.get_child(i).visible == true:
			player_arrows.get_child(i).arrow_blink()


func arrow_stop():
	for i in enemy_arrows.get_children().size():
		enemy_arrows.get_child(i).arrow_stop()
		
	for i in player_arrows.get_children().size():
		player_arrows.get_child(i).arrow_stop()


func arrow_clear():
	arrow_stop()
	for i in enemy_arrows.get_children().size():
		enemy_arrows.get_child(i).visible = false
		enemy_arrows.get_child(i).global_position = enemies.get_child(i).global_position + Vector2(55,5)
		enemy_arrows.get_child(i).scale = Vector2(.2, .2)

	
	for i in player_arrows.get_children().size():
		player_arrows.get_child(i).visible = false
		player_arrows.get_child(i).global_position = party_members.get_child(i).global_position + Vector2(55,5)
		player_arrows.get_child(i).scale = Vector2(.2, .2)

