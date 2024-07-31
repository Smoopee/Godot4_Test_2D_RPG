extends Panel

#UI ELEMENTS--------------------------------------------------------------------
@onready var action_container = $ActionContainer
@onready var attack_container = $AttackContainer
@onready var evasion_container = $EvasionContainer
@onready var arrow_indicator = $"../../ArrowIndicator"

#ENEMIES------------------------------------------------------------------------
@onready var selection_enemy_1 = $"../../SpawnLocation/SelectionEnemy1"
@onready var selection_enemy_2 = $"../../SpawnLocation/SelectionEnemy2"
@onready var selection_enemy_3 = $"../../SpawnLocation/SelectionEnemy3"
@onready var selection_enemy_4 = $"../../SpawnLocation/SelectionEnemy4"
@onready var selection_enemy_5 = $"../../SpawnLocation/SelectionEnemy5"

@onready var tb_enemy_1 = $"../../Enemies/TBEnemy1"
@onready var tb_enemy_2 = $"../../Enemies/TBEnemy2"
@onready var tb_enemy_3 = $"../../Enemies/TBEnemy3"
@onready var tb_enemy_4 = $"../../Enemies/TBEnemy4"
@onready var tb_enemy_5 = $"../../Enemies/TBEnemy5"

@onready var spawn_location = $"../../SpawnLocation"
@onready var enemies = $"../../Enemies"

#PLAYERS PARTY------------------------------------------------------------------
@onready var player_1 = $"../../PartyMembers/Player1ForTurnBase"
@onready var player_2 = $"../../PartyMembers/Player2ForTurnBase"
@onready var player_3 = $"../../PartyMembers/Player3ForTurnBase"

@onready var turn_queue = $"../../TurnQueue"

#DECLARING STATES---------------------------------------------------------------
enum State{
	SELECTING,
	DEFAULT,
	SKILLONE,
	SKILLTWO,
	SPRINT,
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



func _ready():
	set_state(State.SELECTING)
	print("current state is: " + str(current_state))
	arrow_indicator.visible = false

func _process(delta):
	current_character = turn_queue.active_character
	
	if current_character == enemies:
		enemy_ai()
	
	match current_state:
		State.SELECTING:
			pass
		State.DEFAULT:
			pass
		State.SKILLONE:
			pass
		State.SKILLTWO:
			pass

func _on_attack_pressed():
	action_container.visible = false
	attack_container.visible = true


func _on_evasion_pressed():
	action_container.visible = false
	evasion_container.visible = true


func _on_back_pressed():
	evasion_container.visible = false
	attack_container.visible = false
	action_container.visible = true
	spawn_location.visible = false


func _on_default_pressed():
	spawn_location.visible = true
	arrow_indicator.visible = true
	set_state(State.DEFAULT)


func _on_selection_enemy_1_pressed():
	arrow_repositioner(tb_enemy_1.global_position)
	if target_confirmation_checker(1): 
		the_attack_step(tb_enemy_1)

func _on_selection_enemy_2_pressed():
	arrow_repositioner(tb_enemy_2.global_position)
	if target_confirmation_checker(2): 
		the_attack_step(tb_enemy_2)

func _on_selection_enemy_3_pressed():
	arrow_repositioner(tb_enemy_3.global_position)
	if target_confirmation_checker(3): 
		the_attack_step(tb_enemy_3)

func _on_selection_enemy_4_pressed():
	arrow_repositioner(tb_enemy_4.global_position)
	if target_confirmation_checker(4): 
		the_attack_step(tb_enemy_4)

func _on_selection_enemy_5_pressed():
	arrow_repositioner(tb_enemy_5.global_position)
	if target_confirmation_checker(5): 
		the_attack_step(tb_enemy_5)

func arrow_repositioner(enemy_location):
	arrow_indicator.position = enemy_location + Vector2(55,5)

func target_confirmation_checker(test):
	
	target_confirmation_check.append(test)
	if target_confirmation_check.size() > 2:
		target_confirmation_check.resize(0)
		target_confirmation_check.append(test)
		arrow_indicator.arrow_blink()
		return
	if target_confirmation_check.size() == 2:
		if target_confirmation_check[0] == target_confirmation_check [1]:
			arrow_indicator.arrow_blink_stop()
			
			return true
		else: 
			target_confirmation_check.clear()
			return false
	arrow_indicator.arrow_blink()

func the_attack_step(defender):
	
	match current_state:
		State.SELECTING:
			pass
		State.DEFAULT:
			defender.tb_enemy_health_bar.value -= current_character.attack
			current_character = turn_queue.next_character()
			print("current character is: " + str(current_character))
			evasion_container.visible = false
			attack_container.visible = false
			action_container.visible = true
			spawn_location.visible = false
			arrow_indicator.visible = false
			set_state(State.SELECTING)
		State.SKILLONE:
			pass
		State.SKILLTWO:
			pass
	
	
func enemy_ai():
	pass
