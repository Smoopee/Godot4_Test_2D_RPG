extends Node2D

class_name TurnQueue

@onready var enemies = $"../Enemies"
@onready var party_members = $"../PartyMembers"
@onready var turn_panel = $"../CanvasLayer/TurnPanel"


var characters_array = []
var active_character
var index_tracker = 0
var turn_counter = 0
var action_counter: int = 0
var turn_size: int = 0


func _ready():
	#GETS AND SORTS ARRAY------------------------------------------------------
	turn_order_array_creater()
	initialize()
	turn_size = enemies.get_children().size() + party_members.get_children().size()

func custom_sorter(a, b):
	if a.speed > b.speed:
		return true
	return false
	
func initialize():
	active_character = characters_array[index_tracker]

func next_character():
	index_tracker = (index_tracker + 1) % (characters_array.size())
	active_character = characters_array[index_tracker]
	return active_character

func turn_order_array_creater():
	turn_counter += 1
	print("It is turn: " + str(turn_counter))
	characters_array.resize(0)
	for i in enemies.get_children().size():
		characters_array.append(enemies.get_children()[i])
	
	for i in party_members.get_children().size():
		characters_array.append(party_members.get_children()[i])
		
	characters_array = characters_array.filter(dead_check)

	characters_array.sort_custom(custom_sorter)
	
func dead_check(body):
	return body.current_state != 0
	
func turn_cycle():
	if action_counter >= turn_size:
		turn_order_array_creater()
		action_counter = 0
		print("The current array size is " + str(characters_array.size()))
		turn_size = characters_array.size()
		turn_panel.create_turn_panel()
