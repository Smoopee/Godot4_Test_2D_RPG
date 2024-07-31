extends Node2D

class_name TurnQueue

@onready var enemies = $"../Enemies"
@onready var party_members = $"../PartyMembers"


var characters_array
var active_character
var index_tracker = 0


#func play_turn():
	#await active_character.play_turn()
	#var new_index : int = (active_character.get_index() + 1) % get_child_count()
	#active_character = get_child(new_index)

func _ready():
	#GETS AND SORTS ARRAY------------------------------------------------------
	characters_array = enemies.get_children()
	for i in party_members.get_children().size():
		characters_array.append(party_members.get_children()[i])
		
	characters_array.sort_custom(custom_sorter)
	
	initialize()

func custom_sorter(a, b):
	if a.speed > b.speed:
		return true
	return false
	
func initialize():
	active_character = characters_array[index_tracker]

func next_character():
	index_tracker = (index_tracker + 1) % (characters_array.size())
	print("Index tracker is: " + str(index_tracker))
	active_character = characters_array[index_tracker]
	return active_character

