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

@onready var ct_sprite_1 = $CurrentTurnContainer/Panel1/CTSprite1
@onready var ct_sprite_2 = $CurrentTurnContainer/Panel2/CTSprite2
@onready var ct_sprite_3 = $CurrentTurnContainer/Panel3/CTSprite3
@onready var ct_sprite_4 = $CurrentTurnContainer/Panel4/CTSprite4
@onready var ct_sprite_5 = $CurrentTurnContainer/Panel5/CTSprite5
@onready var ct_sprite_6 = $CurrentTurnContainer/Panel6/CTSprite6
@onready var ct_sprite_7 = $CurrentTurnContainer/Panel7/CTSprite7
@onready var ct_sprite_8 = $CurrentTurnContainer/Panel8/CTSprite8

@onready var nt_sprite_1 = $NextTurnContainer/Panel1/NTSprite1
@onready var nt_sprite_2 = $NextTurnContainer/Panel2/NTSprite2
@onready var nt_sprite_3 = $NextTurnContainer/Panel3/NTSprite3
@onready var nt_sprite_4 = $NextTurnContainer/Panel4/NTSprite4
@onready var nt_sprite_5 = $NextTurnContainer/Panel5/NTSprite5
@onready var nt_sprite_6 = $NextTurnContainer/Panel6/NTSprite6
@onready var nt_sprite_7 = $NextTurnContainer/Panel7/NTSprite7
@onready var nt_sprite_8 = $NextTurnContainer/Panel8/NTSprite8



var ct_sprite_array = []
var nt_sprite_array = []
var turn_list_array = []
var next_turn_list_array = []

func _ready():
	ct_sprite_array = [
		ct_sprite_1,
		ct_sprite_2,
		ct_sprite_3,
		ct_sprite_4,
		ct_sprite_5,
		ct_sprite_6,
		ct_sprite_7,
		ct_sprite_8,
	]
	
	nt_sprite_array = [
		nt_sprite_1,
		nt_sprite_2,
		nt_sprite_3,
		nt_sprite_4,
		nt_sprite_5,
		nt_sprite_6,
		nt_sprite_7,
		nt_sprite_8,
	]

	create_turn_panel()
	create_next_turn_panel()

func create_turn_panel():
	turn_label_changer()
	print("TurnPanel: ct_sprite_array = " + str(ct_sprite_array))

	turn_list_array = turn_queue.characters_array
	for i in ct_sprite_array.size():
		if i < turn_list_array.size():
			ct_sprite_array[i].texture = turn_list_array[i].stats.turn_sprite
			ct_sprite_array[i].visible = true
		else:
			ct_sprite_array[i].visible = false


func create_next_turn_panel():
	next_turn_list_array = turn_queue.next_turn_characters_array
	for i in nt_sprite_array.size():
		if i < next_turn_list_array.size():
			nt_sprite_array[i].texture = next_turn_list_array[i].stats.turn_sprite
			nt_sprite_array[i].visible = true
		else:
			nt_sprite_array[i].visible = false

func turn_label_changer():
	current_turn_label.text = "Turn " + str(turn_queue.turn_counter)
	next_turn_label.text = "Turn " + str(turn_queue.turn_counter+1)



func change_order():
	turn_queue.new_list()
	create_turn_panel()
	create_next_turn_panel()

