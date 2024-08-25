extends Node2D

class_name TurnQueue

@onready var enemies = $"../Enemies"
@onready var party_members = $"../PartyMembers"
@onready var turn_panel = $"../TurnPanel"


var characters_array = []
var next_turn_characters_array = []
var active_character
var turn_counter = 0
var action_counter: int = 0
var turn_size: int = 0


func _ready():
	turn_order_array_creator()
	next_turn_creator()
	initialize()
	turn_size = characters_array.size()
	print("TurnQueue: turn_size = " + str(turn_size))

func custom_sorter(a, b):
	if a.stats.speed > b.stats.speed:
		return true
	return false
	
func initialize():
	active_character = characters_array[0]

func next_character():
	if characters_array.size() == 0 or characters_array == null:
		turn_order_array_creator()
		turn_counter -= 1
	active_character = characters_array[0]
	print("Active Character is: " + str(active_character))
	return characters_array[0]
	
func turn_order_array_creator():
	turn_counter += 1
	characters_array.resize(0)
	for i in enemies.enemies_array.size():
		characters_array.append(enemies.enemies_array[i])
	
	for i in party_members.players_array.size():
		characters_array.append(party_members.players_array[i])

	characters_array = characters_array.filter(dead_check)

	characters_array.sort_custom(custom_sorter)
	
func next_turn_creator():
	next_turn_characters_array.resize(0)
	for i in enemies.enemies_array.size():
		next_turn_characters_array.append(enemies.enemies_array[i])
	
	for i in party_members.players_array.size():
		next_turn_characters_array.append(party_members.players_array[i])
	
	next_turn_characters_array = next_turn_characters_array.filter(dead_check)
	
	next_turn_characters_array.sort_custom(custom_sorter)
	
func dead_check(body):
	return body.current_state != 0
	
func turn_cycle():
	if action_counter >= turn_size:
		turn_order_array_creator()
		next_turn_creator()
		action_counter = 1
		turn_size = characters_array.size()
		print("TurnQueue: turn_size = " + str(turn_size))
		turn_panel.create_turn_panel()
		turn_panel.create_next_turn_panel()
		sprint_checker()
		dodge_checker()

func sprint_checker():
	for i in characters_array.size():
		if characters_array[i].is_sprinting:
			characters_array[i].stop_sprint()
			next_turn_creator()
			turn_panel.create_next_turn_panel()


func dodge_checker():
	for i in characters_array.size():
		if characters_array[i].is_dodging:
			characters_array[i].stop_dodge()

func new_list():
	characters_array.sort_custom(custom_sorter)
	next_turn_characters_array.sort_custom(custom_sorter)
