extends Panel

var player_sprite = load("res://scenes/TBScenes/player_turn_sprite_panel.tscn")
var enemy_sprite = load("res://scenes/TBScenes/enemy_turn_sprite_panel.tscn")

@onready var enemies = $"../Enemies"
@onready var party_members = $"../PartyMembers"


@onready var turn_queue = $"../TurnQueue"
@onready var current_turn_container = $CurrentTurnContainer
@onready var next_turn_container = $NextTurnContainer
@onready var next_turn_label = $NextTurnLabel
@onready var current_turn_label = $CurrentTurnLabel


var turn_list_array = []
var next_turn_list_array = []
var zSetter = 9


func _ready():
	create_turn_panel()
	create_next_turn_panel()

func create_turn_panel():
	zSetter = 9 
	turn_label_changer()
	for n in current_turn_container.get_children():
		n.free()
		
	turn_list_array = turn_queue.characters_array
	for i in turn_list_array.size():
		turn_list_array[i].instantiate_turn_sprite(current_turn_container, zSetter)
		zSetter -= 1

func create_next_turn_panel():
	zSetter = 9 
	#CLEARS THE NEXT TURN PANEL------------------------------------------------
	for n in next_turn_container.get_children():
		n.free()
	#CREATES THE NEXT TURN PAENEL----------------------------------------------
	next_turn_list_array = turn_queue.next_turn_characters_array
	for i in next_turn_list_array.size():
		next_turn_list_array[i].instantiate_turn_sprite(next_turn_container, zSetter)
		zSetter -= 1

func turn_label_changer():
	current_turn_label.text = "Turn " + str(turn_queue.turn_counter)
	next_turn_label.text = "Turn " + str(turn_queue.turn_counter+1)

func change_order():
	print("This is 1")
	turn_queue.new_list()
	turn_list_array = turn_queue.characters_array
	print("The characters array is " + str(turn_list_array.size()))
	zSetter = 9
	for n in current_turn_container.get_children():
		n.free()
	for i in turn_list_array.size():
		turn_list_array[i].instantiate_turn_sprite(current_turn_container, zSetter)
		zSetter -= 1
	
	next_turn_list_array = turn_queue.next_turn_characters_array
	zSetter = 9 
	for n in next_turn_container.get_children():
		n.free()
	for i in next_turn_list_array.size():
		next_turn_list_array[i].instantiate_turn_sprite(next_turn_container, zSetter)
		zSetter -= 1
	
