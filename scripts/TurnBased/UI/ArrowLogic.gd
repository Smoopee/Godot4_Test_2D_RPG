extends Control

var arrow_inicator_scene = load("res://scenes/TBScenes/TBBattleScene/arrow_indicator.tscn")

@onready var party_members = $"../PartyMembers"
@onready var enemies = $"../Enemies"
@onready var spawn_location = $"../SpawnLocation"


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


func arrow_initializer(targeting):
	for i in enemies.get_children().size():
		if enemies.get_child(i).current_state == 1:
			first_alive_enemy = i
			break
	
	match targeting:
		"Single":
			set_state(State.SINGLE)
			arrow_indicator = arrow_inicator_scene.instantiate()
			add_child(arrow_indicator)
			arrow_indicator.scale = Vector2(.2, .2)
			arrow_indicator.global_position = spawn_location.get_child(first_alive_enemy).global_position + Vector2(55,5)
		"Multi":
			set_state(State.MULTI)
			arrow_multi()
		"AOE":
			set_state(State.AOE)
			arrow_duplicator()
		"Friendly_Single":
			set_state(State.FRIENDLY_SINGLE)
		"Friendly_Multi":
			set_state(State.FRIENDLY_MULTI)
		"Friendly_AOE":
			set_state(State.FRIENDLY_AOE)
			
func arrow_duplicator():
	for i in enemies.get_children().size():
		
		#SKIPS DEAD ENEMIES
		if enemies.get_child(i).current_state == 0:
			continue
		
		#RESUMES MAKING REST OF ARROWS
		arrow_indicator = arrow_inicator_scene.instantiate()
		add_child(arrow_indicator)
		arrow_indicator.scale = Vector2(.2, .2)
		arrow_indicator.position = enemies.get_child(i).global_position + Vector2(55,5)
		
func arrow_multi(current_enemy_index = first_alive_enemy):
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1
	
	if right_enemy_index + 1 > enemies.get_children().size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = enemies.get_children().size()-1
	
	arrow_indicator = arrow_inicator_scene.instantiate()
	add_child(arrow_indicator)
	arrow_indicator.scale = Vector2(.2, .2)
	arrow_indicator.position = enemies.get_child(current_enemy_index).global_position + Vector2(55,5)
	
	if enemies.get_child(right_enemy_index).current_state == 1:
		arrow_indicator = arrow_inicator_scene.instantiate()
		add_child(arrow_indicator)
		arrow_indicator.scale = Vector2(.1, .1)
		arrow_indicator.position = enemies.get_child(right_enemy_index).global_position + Vector2(35,5)
	
	
	if enemies.get_child(left_enemy_index).current_state == 1:
		arrow_indicator = arrow_inicator_scene.instantiate()
		add_child(arrow_indicator)
		arrow_indicator.scale = Vector2(.1, .1)
		arrow_indicator.position = enemies.get_child(left_enemy_index).global_position + Vector2(35,5)


func arrow_repositioner(enemy):
	match current_state:
		State.SINGLE:
			arrow_indicator.position = enemy.global_position + Vector2(55,5)
		State.MULTI:
			arrow_clear()
			arrow_multi(enemy.get_index())
		State.AOE:
			pass
		State.FRIENDLY_SINGLE:
			pass
		State.MULTI:
			pass
		State.FRIENDLY_AOE:
			pass


func arrow_start():
	match current_state:
		State.SINGLE:
			arrow_indicator.arrow_blink()
		State.MULTI:
			for i in get_children().size():
				get_child(i).arrow_blink()
		State.AOE:
			for i in get_children().size():
				get_child(i).arrow_blink()
		State.FRIENDLY_SINGLE:
			arrow_indicator.arrow_blink()
		State.MULTI:
			arrow_indicator.arrow_blink()
		State.FRIENDLY_AOE:
			arrow_indicator.arrow_blink()

func arrow_stop():
	match current_state:
		State.SINGLE:
			arrow_indicator.arrow_stop()
		State.MULTI:
			for i in get_children().size():
				get_child(i).arrow_stop()
		State.AOE:
			for i in get_children().size():
				get_child(i).arrow_stop()
		State.FRIENDLY_SINGLE:
			arrow_indicator.arrow_stop()
		State.MULTI:
			arrow_indicator.arrow_stop()
		State.FRIENDLY_AOE:
			arrow_indicator.arrow_stop()


func arrow_clear():
	for i in get_children().size():
		get_child(i).queue_free()
