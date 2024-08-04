extends Panel

var player_sprite = load("res://scenes/TBScenes/player_turn_sprite_panel.tscn")
var enemy_sprite = load("res://scenes/TBScenes/enemy_turn_sprite_panel.tscn")

@onready var enemies = $"../../Enemies"
@onready var party_members = $"../../PartyMembers"
@onready var turn_queue = $"../../TurnQueue"
@onready var current_turn_container = $CurrentTurnContainer
@onready var next_turn_container = $NextTurnContainer
@onready var current_turn_label = $CurrentTurnLabel
@onready var next_turn_label = $NextTurnLabel


var turn_list_array = []
var next_turn_list_array = []
var turn_sprite
var zindex_setter = 9

func _ready():
	#CURRENT TURN CREATOR ON STARTUP--------------------------------------------
	turn_list_array = turn_queue.characters_array
	for i in turn_list_array.size():
		if turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()

		current_turn_container.add_child(turn_sprite)
		turn_sprite.z_index = zindex_setter
		zindex_setter -=1
	#NEXT TURN CREATOR ON STARTUP-----------------------------------------------
	next_turn_list_array = turn_queue.next_turn_characters_array
	zindex_setter = 9
	for i in next_turn_list_array.size():
		if next_turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if next_turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()

		next_turn_container.add_child(turn_sprite)
		turn_sprite.z_index = zindex_setter
		zindex_setter -=1

func create_turn_panel():
	turn_label_changer()
	turn_list_array = turn_queue.characters_array
	zindex_setter = 9
	for i in turn_list_array.size():
		if turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()
			
		current_turn_container.add_child(turn_sprite)
		turn_sprite.z_index = zindex_setter
		zindex_setter -=1

func create_next_turn_panel():
	#CLEARS THE NEXT TURN PANEL------------------------------------------------
	for n in next_turn_container.get_children():
		n.queue_free()
	#CREATES THE NEXT TURN PAENEL----------------------------------------------
	next_turn_list_array = turn_queue.next_turn_characters_array
	zindex_setter = 9
	for i in next_turn_list_array.size():
		if next_turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if next_turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()

		next_turn_container.add_child(turn_sprite)
		turn_sprite.z_index = zindex_setter
		zindex_setter -=1

func turn_label_changer():
	current_turn_label.text = "Turn " + str(turn_queue.turn_counter)
	next_turn_label.text = "Turn " + str(turn_queue.turn_counter + 1)
