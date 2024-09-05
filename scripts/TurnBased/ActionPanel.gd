extends Panel

@onready var tb_battle_arena = $".."

#UI ELEMENTS--------------------------------------------------------------------
@onready var action_container = $ActionContainer
@onready var attack_container = $AttackContainer
@onready var evasion_container = $EvasionContainer
@onready var arrow_logic = $"../ArrowLogic"

@onready var enemies = $"../Enemies"


#PLAYERS PARTY------------------------------------------------------------------
@onready var active_character_highlighter1 = $"../PlayerPanel/PartyMember1/ActiveCharacterHighlighter"
@onready var active_character_highlighter2 = $"../PlayerPanel/PartyMember2/ActiveCharacterHighlighter"
@onready var active_character_highlighter3 = $"../PlayerPanel/PartyMember3/ActiveCharacterHighlighter"
@onready var items_panel = $"../ItemsPanel"
@onready var items = $"../Items"
@onready var ultimate_progress_bar = $"../Ultimate/UltimateProgressBar"


@onready var turn_queue = $"../TurnQueue"
@onready var party_members = $"../PartyMembers"


@onready var turn_panel = $"../TurnPanel"
@onready var current_turn_container = $"../TurnPanel/CurrentTurnContainer"
@onready var next_turn_container = $"../TurnPanel/NextTurnContainer"

@onready var skill_1 = $"AttackContainer/Skill 1"
@onready var skill_2 = $"AttackContainer/Skill 2"
@onready var scene_transition_animation = $"../sceneTransitionAnimation/AnimationPlayer"
@onready var transition_animation = $"../sceneTransitionAnimation"




#DECLARING STATES---------------------------------------------------------------
enum State{
	SELECTING,
	DEFAULT,
	SKILLONE,
	SKILLTWO,
	DODGE,
	ENEMY_TURN
}

var current_state: int = -1: set = set_state

func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state
	
enum Mode{
	BATTLE,
	INSPECTOR,
}

var current_mode: int = -1: set = set_mode

func set_mode(new_mode):
	if new_mode == current_mode:
		return
	current_mode = new_mode
	
enum Target{
	SINGLE,
	MULTI,
	AOE,
	FRIENDLY_SINGLE,
	FRIENDLY_MULTI,
	FRIENDLY_AOE
}

var current_target: int = -1: set = set_target

func set_target(new_target):
	if new_target == current_target:
		return
	current_target = new_target

var target_tracker: String

#SCRIPT WIDE VARIABLES----------------------------------------------------------
var current_character 
var target_confirmation_check = []

var player_1
var player_2
var player_3

func _ready():
	player_1 = party_members.players_array[0]
	player_2 = party_members.players_array[1]
	player_3 = party_members.players_array[2]
	set_mode(Mode.BATTLE)
	
	for i in turn_queue.characters_array:
		on_start_of_game_trigger(i)
	
	
func turn_keeper():
	turn_queue.turn_cycle()
	current_character = turn_queue.active_character
	on_upkeep_trigger(current_character)
	active_player_highlighter()
	print("Current character is " + str(current_character))
	if current_character.is_in_group("enemy"):
		current_character.shield_turn_tracker()
		current_character.stagger_turn_tracker()
		set_state(State.ENEMY_TURN)
		enemy_ai(current_character)
	elif current_character.is_in_group("allys"):
		set_state(State.SELECTING)
		print("ActionPanel: current_character.state is " + str(current_state))


func active_player_highlighter():
	match current_character:
		player_1:
			active_character_highlighter1.visible = true
			active_character_highlighter2.visible = false
			active_character_highlighter3.visible = false
		player_2:
			active_character_highlighter1.visible = false
			active_character_highlighter2.visible = true
			active_character_highlighter3.visible = false
		player_3:
			active_character_highlighter1.visible = false
			active_character_highlighter2.visible = false
			active_character_highlighter3.visible = true
		_:
			active_character_highlighter1.visible = false
			active_character_highlighter2.visible = false
			active_character_highlighter3.visible = false

func _on_attack_pressed():
	if current_state == State.ENEMY_TURN: return
	action_container.visible = false
	attack_container.visible = true
	skill_1.text = current_character.stats.skill_one_name
	skill_2.text = current_character.stats.skill_two_name


func _on_evasion_pressed():
	if current_state == State.ENEMY_TURN: return
	action_container.visible = false
	evasion_container.visible = true

func _on_sprint_pressed():
	if stamina_checker(): return
	stamina_checker()
	current_character.cast_sprint()
	on_sprint_trigger(current_character)
	turn_queue.next_turn_creator()
	turn_panel.create_next_turn_panel()
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true

func _on_dodge_pressed():
	if stamina_checker(): return
	current_character.cast_dodge()
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true

func _on_item_pressed():
	if current_state == State.ENEMY_TURN: return
	items_panel.visible = true

func _on_health_flask_pressed():
	items.use_health_flask(current_character)
	items.change_health_flask(-1)


func _on_mana_flask_pressed():
	items.use_mana_flask(current_character)
	items.change_mana_flask(-1)


func _on_stamina_flask_pressed():
	items.use_stamina_flask(current_character)
	items.change_stamina_flask(-1)

func _on_back_pressed():
	target_tracker = ""
	target_confirmation_check.clear()
	arrow_logic.arrow_clear()
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true
	items_panel.visible = false


func _on_default_pressed():
	target_confirmation_check.clear()
	print("Actionpanel: current_character.default_attack_targeting is " + str(current_character.default_attack_targeting))
	arrow_logic.arrow_initializer(current_character.default_attack_targeting)
	targeting_state(current_character.default_attack_targeting)
	on_default_trigger(current_character)
	set_state(State.DEFAULT)

func _on_skill_1_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_initializer(current_character.skill_one_targeting)
	targeting_state(current_character.skill_one_targeting)
	set_state(State.SKILLONE)

func _on_skill_2_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_initializer(current_character.skill_two_targeting)
	targeting_state(current_character.skill_two_targeting)
	set_state(State.SKILLTWO)

#ENEMY BUTTONS------------------------------------------------------------------
func button_handler(body):
	if current_state == State.ENEMY_TURN: return
	if dead_checker(body): return
	if target_confirmation_checker(body):
		the_attack_step(body)


func _on_enemy_1_pressed():
	if target_tracker == "enemy":
		button_handler(enemies.enemies_array[0])
		print("Pressed Enemy 1 Button")

func _on_enemy_2_pressed():
	if target_tracker == "enemy":
		button_handler(enemies.enemies_array[1])
		print("Pressed Enemy 5 Button")

func _on_enemy_3_pressed():
	if target_tracker == "enemy":
		button_handler(enemies.enemies_array[2])
		print("Pressed Enemy 2 Button")

func _on_enemy_4_pressed():
	if target_tracker == "enemy":
		button_handler(enemies.enemies_array[3])
		print("Pressed Enemy 4 Button")

func _on_enemy_5_pressed():
	if target_tracker == "enemy":
		button_handler(enemies.enemies_array[4])
		print("Pressed Enemy 3 Button")

#PARTY MEMBER BUTTONS-----------------------------------------------------------

func _on_player_1_pressed():
	if target_tracker == "friendly":
		print("Player 1 Button has been pressed")
		button_handler(party_members.players_array[0])

func _on_player_2_pressed():
	if target_tracker == "friendly":
		print("Player 2 Button has been pressed")
		button_handler(party_members.players_array[1])

func _on_player_3_pressed():
	if target_tracker == "friendly":
		print("Player 3 Button has been pressed")
		button_handler(party_members.players_array[2])

func targeting_state(targeting):
	match targeting:
		"Single":
			set_target(Target.SINGLE)
			target_tracker = "enemy"
		"Multi":
			set_target(Target.MULTI)
			target_tracker = "enemy"
		"AOE":
			set_target(Target.AOE)
			target_tracker = "enemy"
		"Friendly_Single":
			set_target(Target.FRIENDLY_SINGLE)
			target_tracker = "friendly"
		"Friendly_Multi":
			set_target(Target.FRIENDLY_MULTI)
			target_tracker = "friendly"
		"Friendly_AOE":
			set_target(Target.FRIENDLY_AOE)
			target_tracker = "friendly"

func target_confirmation_checker(test):
	
	if mana_checker():
		arrow_logic.arrow_stop()
		return

	target_confirmation_check.append(test)
	if target_confirmation_check.size() > 2:
		target_confirmation_check.resize(0)
		target_confirmation_check.append(test)
	if target_confirmation_check.size() == 2:
		
		if target_confirmation_check[0] == target_confirmation_check [1]:
			arrow_logic.arrow_clear()
			return true
		else: 
			target_confirmation_check.pop_front()
			arrow_logic.arrow_repositioner(test)
			arrow_logic.arrow_start()
			return false
			
	arrow_logic.arrow_repositioner(test)
	arrow_logic.arrow_start()

func the_attack_step(defender):
	match current_state:
		State.SELECTING:
			pass
		State.DEFAULT:
			default_attack_step(defender)
		State.SKILLONE:
			skill_one_attack_step(defender)
		State.SKILLTWO:
			skill_two_attack_step(defender)

	var temp_array = []
	for i in enemies.enemies_array.size():
			if enemies.enemies_array[i].current_state == 1:
				temp_array.push_front(i)
	if temp_array == []: 
		victory()

	set_state(State.SELECTING)
	current_character.buff_incrementer(current_character)

	end_turn()

func enemy_ai(body):
	body.debuff_incrementer(body)
	var possible_targets = []
	print("The players array before enemy attack is " + str(party_members.players_array))
	for i in party_members.players_array:
		if i.current_state == 1:
			possible_targets.push_back(i)
	
	body.attack_ai(possible_targets)
	
func end_turn():
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true
	action_counter()
	turn_queue.characters_array.pop_front()
	turn_queue.next_character()
	turn_panel.change_order()
	print("ActionPanel: End of turn summary of turn " + str(turn_queue.turn_counter))
	print("action_counter = " + str(turn_queue.action_counter))
	turn_keeper()

func dead_checker(body):
	if body.current_state == 0:
		return true

func action_counter():
	turn_queue.action_counter += 1

func current_index(body):
	return turn_queue.characters_array.find(body)

func next_turn_index(body):
	return turn_queue.next_turn_characters_array.find(body)

func queue_and_array_remover(body):
	var current_body_index = current_index(body)
	var next_turn_body_index = next_turn_index(body)
	
	if current_body_index == -1:
		if next_turn_body_index != -1:
			turn_queue.next_turn_characters_array.remove_at(next_turn_body_index)
			turn_panel.change_order()
			return
		return
	
	turn_queue.characters_array.remove_at(current_body_index)
	turn_panel.change_order()

	
	turn_queue.next_turn_characters_array.remove_at(next_turn_body_index)
	turn_panel.change_order()
	action_counter()

func default_attack_step(defender):
	on_attack_trigger(current_character)
	match current_character.default_attack_targeting:
		"Single":
			current_character.cast_default_attack(current_character, defender)

		"Multi":
			current_character.cast_default_attack(current_character, defender)
		
		"AOE":
			
			for i in enemies.enemies_array.size():
			#SKIPS DEAD ENEMIES
				if enemies.enemies_array[i].current_state == 0:
					continue
				
				current_character.cast_default_attack(current_character, enemies.enemies_array[i])
					
		"Friendly_Single":
			current_character.default_attack(current_character, defender)
		"Friendly_Multi":
			current_character.default_attack(current_character, defender)
		"Friendly_AOE":
			for i in party_members.players_array.size():
				
				if party_members.players_array[i].current_state == 0:
					continue
				current_character.cast_default_attack(current_character, party_members.players_array[i])

func skill_one_attack_step(defender):
	var available_targets = []
	
	match current_character.skill_one_targeting:
		"Single":
			current_character.cast_skill_one(current_character, defender)
		"Multi":
			current_character.cast_skill_one(current_character, defender)
		"AOE":
			for i in enemies.enemies_array.size():
			#SKIPS DEAD ENEMIES
				if enemies.enemies_array[i].current_state == 0:
					continue
				available_targets.push_front(enemies.enemies_array[i])
				
			current_character.cast_skill_one(current_character, available_targets)

		"Friendly_Single":
			current_character.cast_skill_one(current_character, defender)
		"Friendly_Multi":
			current_character.cast_skill_one(current_character, defender)
		"Friendly_AOE":
			for i in party_members.players_array.size():
				
				if party_members.players_array[i].current_state == 0:
					continue
				current_character.cast_skill_one(current_character, party_members.players_array[i])

func skill_two_attack_step(defender):
	var available_targets = []
	
	match current_character.skill_two_targeting:
		"Single":
			current_character.cast_skill_two(current_character, defender)
		"Multi":
			current_character.cast_skill_two(current_character, defender)
		"AOE":
			for i in enemies.enemies_array.size():
			#SKIPS DEAD ENEMIES
				if enemies.enemies_array[i].current_state == 0:
					continue
				available_targets.push_front(enemies.enemies_array[i])

			current_character.cast_skill_two(current_character, available_targets)
		"Friendly_Single":
			current_character.cast_skill_two(current_character, defender)
		"Friendly_Multi":
			current_character.cast_skill_two(current_character, defender)
		"Friendly_AOE":
			for i in party_members.players_array.size():
				
				if party_members.players_array[i].current_state == 0:
					continue
				current_character.cast_skill_two(current_character, party_members.players_array[i])

func mana_checker():
	match current_state:
		State.DEFAULT:
			pass
		State.SKILLONE:
			if current_character.skill_one_mana_cost > current_character.stats.mana:
				print("Too much mana for skill one")
				return true
			else: 
				return false
		State.SKILLTWO:
			if current_character.skill_two_mana_cost > current_character.stats.mana:
				print("Too much mana for skill two")
				return true
			else: 
				return false

func stamina_checker():
	if current_character.stats.stamina < 50:
		print("Too much stamina")
		return true

func character_died(body):
	print(str(body) + "has died")
	queue_and_array_remover(body)


func character_speed_change(_body):
	print("New zoom on dude")
	turn_panel.change_order()


func _on_inspector_button_pressed():
	if current_mode == Mode.BATTLE:
		print("Inspector Mode")
		set_mode(Mode.INSPECTOR)
	else: 
		print("Battle Mode")
		set_mode(Mode.BATTLE)

func get_group_array():
	var temp_array = []
	for i in enemies.enemies_array.size():
			if enemies.enemies_array[i].current_state == 1:
				temp_array.push_front(i)
	return temp_array


func _on_ultimate_button_pressed():
	if ultimate_progress_bar.value != 100: return
	for i in enemies.enemies_array.size():
		enemies.enemies_array[i].change_health(-50)
	ultimate_progress_bar.value = 0

func victory():
	print("VICTORY")
		
	var experience_tracker: int
	for i in enemies.enemies_array:
		experience_tracker += i.stats.experience
	
	print("You gained " + str(experience_tracker) + "!")
	
	for i in tb_battle_arena.current_party:
		i.change_experience(i, experience_tracker)

	transition_animation.visible = true
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(1).timeout
	tb_battle_arena.tree_is_leaving()

func on_sprint_trigger(body):
	for node in get_tree().get_nodes_in_group("on_sprint"):
		if body.is_ancestor_of(node): 
			node.trigger(body)

func on_default_trigger(body):
	for node in get_tree().get_nodes_in_group("on_default"):
		if body.is_ancestor_of(node): 
			node.trigger(body)

func on_attack_trigger(body):
	for node in get_tree().get_nodes_in_group("on_attack"):
		if body.is_ancestor_of(node): 
			node.trigger(body)
			
func on_start_of_game_trigger(body):
	for node in get_tree().get_nodes_in_group("on_start_of_game"):
		if body.is_ancestor_of(node): 
			node.trigger(body)

func on_upkeep_trigger(body):
	for node in get_tree().get_nodes_in_group("on_upkeep"):
		if body.is_ancestor_of(node): 
			node.trigger(body)
