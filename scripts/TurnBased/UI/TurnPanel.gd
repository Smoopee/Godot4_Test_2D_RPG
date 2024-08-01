extends Panel

var player_sprite = load("res://scenes/TBScenes/player_turn_sprite_panel.tscn")
var enemy_sprite = load("res://scenes/TBScenes/enemy_turn_sprite_panel.tscn")

@onready var enemies = $"../../Enemies"
@onready var party_members = $"../../PartyMembers"
@onready var turn_queue = $"../../TurnQueue"
@onready var current_turn_container = $CurrentTurnContainer

var panel = Panel.new()

var turn_list_array = []
var turn_sprite

func _on_turn_queue_ready():
	turn_list_array = turn_queue.characters_array
	print("The Array is: " + str(turn_list_array))
	for i in turn_list_array.size():
		if turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()

		current_turn_container.add_child(turn_sprite)
		

		print(get_node("CurrentTurnContainer").get_children().size())

func create_turn_panel():
	turn_list_array = turn_queue.characters_array
	print("The Array is: " + str(turn_list_array))
	for i in turn_list_array.size():
		if turn_list_array[i].get_parent() == enemies:
			turn_sprite = enemy_sprite.instantiate()
		
		if turn_list_array[i].get_parent() == party_members:
			turn_sprite = player_sprite.instantiate()

		current_turn_container.add_child(turn_sprite)
		

		print(get_node("CurrentTurnContainer").get_children().size())
