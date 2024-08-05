extends Panel

#UI ELEMENTS--------------------------------------------------------------------
@onready var action_container = $ActionContainer
@onready var attack_container = $AttackContainer
@onready var evasion_container = $EvasionContainer
@onready var arrow_logic = $"../../ArrowLogic"

@onready var enemies = $"../../Enemies"

#PLAYERS PARTY------------------------------------------------------------------
@onready var player_1 = $"../../PartyMembers/Player1ForTurnBase"
@onready var player_2 = $"../../PartyMembers/Player2ForTurnBase"
@onready var player_3 = $"../../PartyMembers/Player3ForTurnBase"
@onready var active_character_highlighter1 = $"../PlayerPanel/PartyMember1/ActiveCharacterHighlighter"
@onready var active_character_highlighter2 = $"../PlayerPanel/PartyMember2/ActiveCharacterHighlighter"
@onready var active_character_highlighter3 = $"../PlayerPanel/PartyMember3/ActiveCharacterHighlighter"


@onready var turn_queue = $"../../TurnQueue"
@onready var party_members = $"../../PartyMembers"


@onready var turn_panel = $"../TurnPanel"
@onready var current_turn_container = $"../TurnPanel/CurrentTurnContainer"
@onready var next_turn_container = $"../TurnPanel/NextTurnContainer"

@onready var skill_1 = $"AttackContainer/Skill 1"
@onready var skill_2 = $"AttackContainer/Skill 2"


#DECLARING STATES---------------------------------------------------------------
enum State{
	SELECTING,
	DEFAULT,
	SKILLONE,
	SKILLTWO,
	DODGE,
}

var current_state: int = -1: set = set_state

func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state

#SCRIPT WIDE VARIABLES----------------------------------------------------------
var current_character 
var target_confirmation_check = []
var rng = RandomNumberGenerator.new()


func _ready():
	turn_keeper()

func turn_keeper():
	turn_queue.turn_cycle()
	current_character = turn_queue.active_character
	if current_character.is_in_group("enemy"):
		action_counter()
		current_character.shield_turn_tracker()
		current_character.stagger_turn_tracker()
		enemy_ai(current_character)
		
	active_player_highlighter()

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
	action_container.visible = false
	attack_container.visible = true
	skill_1.text = current_character.skill_one_spellname
	skill_2.text = current_character.skill_two_spellname


func _on_evasion_pressed():
	action_container.visible = false
	evasion_container.visible = true

func _on_sprint_pressed():
	if stamina_checker(): return
	stamina_checker()
	current_character.cast_sprint()
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

func _on_back_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_clear()
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true


func _on_default_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_clear()
	arrow_logic.arrow_initializer(current_character.default_attack_targeting)
	set_state(State.DEFAULT)

func _on_skill_1_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_clear()
	arrow_logic.arrow_initializer(current_character.skill_one_targeting)
	set_state(State.SKILLONE)

func _on_skill_2_pressed():
	target_confirmation_check.clear()
	arrow_logic.arrow_clear()
	arrow_logic.arrow_initializer(current_character.skill_two_targeting)
	set_state(State.SKILLTWO)

#ENEMY BUTTONS------------------------------------------------------------------
func button_handler(body):
	if dead_checker(body): return
	if target_confirmation_checker(body):
		the_attack_step(body)


func _on_button_pressed():
	button_handler(enemies.get_child(0))

func _on_button_2_pressed():
	button_handler(enemies.get_child(1))


func _on_button_3_pressed():
	button_handler(enemies.get_child(2))


func _on_button_4_pressed():
	button_handler(enemies.get_child(3))


func _on_button_5_pressed():
	button_handler(enemies.get_child(4))


#PARTY MEMBER BUTTONS-----------------------------------------------------------

func _on_player_1_button_pressed():
	button_handler(party_members.get_child(0))


func _on_player_2_button_pressed():
	button_handler(party_members.get_child(1))


func _on_player_3_button_pressed():
	button_handler(party_members.get_child(2))


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
			evasion_container.visible = false
			attack_container.visible = false
			action_container.visible = true
			action_counter()
			current_turn_container.get_child(0).free()
			turn_queue.characters_array.pop_front()
			set_state(State.SELECTING)
			turn_queue.next_character()
		State.SKILLONE:
			skill_one_attack_step(defender)
			evasion_container.visible = false
			attack_container.visible = false
			action_container.visible = true
			action_counter()
			current_turn_container.get_child(0).queue_free()
			turn_queue.characters_array.pop_front()
			set_state(State.SELECTING)
			turn_queue.next_character()
		State.SKILLTWO:
			skill_two_attack_step(defender)
			evasion_container.visible = false
			attack_container.visible = false
			action_container.visible = true
			action_counter()
			current_turn_container.get_child(0).queue_free()
			turn_queue.characters_array.pop_front()
			set_state(State.SELECTING)
			turn_queue.next_character()
	turn_keeper()

func enemy_ai(body):
	body.debuff_incrementer(body)
	var random = rng.randi_range(0, party_members.get_child_count()-1)
	var enemy_target = party_members.get_children()[random]
	if enemy_target.is_dodging == false:
		enemy_target.change_health(-current_character.attack)

	current_turn_container.get_child(0).free()

	turn_queue.characters_array.pop_front()
	print("Current Turn Container is: " + str(current_turn_container.get_children()))
	print("Character array is: " + str(turn_queue.characters_array))
	turn_queue.next_character()
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
			next_turn_container.get_child(next_turn_body_index).free()
			return
		return
	
	turn_queue.characters_array.remove_at(current_body_index)
	current_turn_container.get_child(current_body_index).free()

	
	turn_queue.next_turn_characters_array.remove_at(next_turn_body_index)
	next_turn_container.get_child(next_turn_body_index).free()
	action_counter()

func default_attack_step(defender):
	current_character.default_attack(defender)

func skill_one_attack_step(defender):
	match current_character.skill_one_targeting:
		"Single":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			current_character.cast_skill_one(current_character, defender)

		"Multi":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			current_character.cast_skill_one(current_character, defender)
		
		"AOE":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			
			for i in enemies.get_children().size():
			
			#SKIPS DEAD ENEMIES
				if enemies.get_child(i).current_state == 0:
					continue
				
				current_character.cast_skill_one(current_character, enemies.get_child(i))
					
		"Friendly_Single":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			current_character.cast_skill_one(current_character, defender)
		"Friendly_Multi":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			current_character.cast_skill_one(current_character, defender)
		"Friendly_AOE":
			current_character.instantiate_skill_one()
			current_character.change_mana(-current_character.skill_one_mana_cost)
			
			for i in party_members.get_children().size():
				
				if party_members.get_child(i).current_state == 0:
					continue
				current_character.cast_skill_one(current_character, party_members.get_child(i))
	

func skill_two_attack_step(defender):
	match current_character.skill_two_targeting:
		"Single":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			current_character.cast_skill_two(current_character, defender)
		"Multi":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			current_character.cast_skill_two(current_character, defender)
			
		"AOE":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			
			for i in enemies.get_children().size():
			
			#SKIPS DEAD ENEMIES
				if enemies.get_child(i).current_state == 0:
					continue
				
				current_character.cast_skill_two(current_character, enemies.get_child(i))
		"Friendly_Single":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			current_character.cast_skill_two(current_character, defender)
		"Friendly_Multi":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			current_character.cast_skill_two(current_character, defender)
		"Friendly_AOE":
			current_character.instantiate_skill_two()
			current_character.change_mana(-current_character.skill_two_mana_cost)
			
			for i in party_members.get_children().size():
				
				if party_members.get_child(i).current_state == 0:
					continue
				current_character.cast_skill_two(current_character, party_members.get_child(i))

func mana_checker():
	match current_state:
		State.DEFAULT:
			pass
		State.SKILLONE:
			if current_character.skill_one_mana_cost > current_character.mana:
				print("Too much mana for skill one")
				return true
			else: 
				return false
		State.SKILLTWO:
			if current_character.skill_two_mana_cost > current_character.mana:
				print("Too much mana for skill two")
				return true
			else: 
				return false

func stamina_checker():
	if current_character.stamina < 50:
		print("Too much stamina")
		return true

func character_died(body):
	print("a character has died")
	queue_and_array_remover(body)
