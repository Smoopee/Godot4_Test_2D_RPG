extends Control

var current_djinn

@onready var fire_talent_tree = $"."


@onready var t_1b_1 = $Tier1Panel/VBoxContainer/HBoxContainer/T1B1
@onready var t_1b_2 = $Tier1Panel/VBoxContainer/HBoxContainer/T1B2
@onready var t_1b_3 = $Tier1Panel/VBoxContainer/HBoxContainer/T1B3
@onready var t_2b_1 = $Tier1Panel/VBoxContainer/HBoxContainer2/T2B1
@onready var t_2b_2 = $Tier1Panel/VBoxContainer/HBoxContainer2/T2B2
@onready var t_2b_3 = $Tier1Panel/VBoxContainer/HBoxContainer2/T2B3
@onready var t_3b_1 = $Tier1Panel/VBoxContainer/HBoxContainer3/T3B1
@onready var t_3b_2 = $Tier1Panel/VBoxContainer/HBoxContainer3/T3B2
@onready var t_3b_3 = $Tier1Panel/VBoxContainer/HBoxContainer3/T3B3
@onready var t_4b_1 = $Tier1Panel/VBoxContainer/HBoxContainer4/T4B1
@onready var t_4b_2 = $Tier1Panel/VBoxContainer/HBoxContainer4/T4B2
@onready var t_4b_3 = $Tier1Panel/VBoxContainer/HBoxContainer4/T4B3
@onready var t_5b_1 = $Tier1Panel/VBoxContainer/HBoxContainer5/T5B1
@onready var t_5b_2 = $Tier1Panel/VBoxContainer/HBoxContainer5/T5B2
@onready var t_5b_3 = $Tier1Panel/VBoxContainer/HBoxContainer5/T5B3
@onready var t_6b_1 = $Tier1Panel/VBoxContainer/HBoxContainer6/T6B1
@onready var t_6b_2 = $Tier1Panel/VBoxContainer/HBoxContainer6/T6B2
@onready var t_6b_3 = $Tier1Panel/VBoxContainer/HBoxContainer6/T6B3
@onready var t_7b_1 = $Tier1Panel/VBoxContainer/HBoxContainer7/T7B1
@onready var t_7b_2 = $Tier1Panel/VBoxContainer/HBoxContainer7/T7B2
@onready var t_7b_3 = $Tier1Panel/VBoxContainer/HBoxContainer7/T7B3
@onready var t_8b_1 = $Tier1Panel/VBoxContainer/HBoxContainer8/T8B1
@onready var t_8b_2 = $Tier1Panel/VBoxContainer/HBoxContainer8/T8B2
@onready var t_8b_3 = $Tier1Panel/VBoxContainer/HBoxContainer8/T8B3

var save_file_path = "user://save/"
var save_file_name 


var current_button


func _ready():
	for button in get_tree().get_nodes_in_group("fire_talent_button"):
		button.pressed.connect(on_pressed.bind(button))


func transfer_djinn(djinn):
	current_djinn = djinn
	set_talents(current_djinn)


func _on_t_1b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[0] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_1b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[0] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_1b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[0] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_2b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[1] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_2b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[1] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_2b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[1] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_3b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[2] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_3b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[2] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_3b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[2] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_4b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[3] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_4b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[3] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_4b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[3] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_5b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[4] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_5b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[4] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_5b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[4] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_6b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[5] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_6b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[5] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_6b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[5] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_7b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[6] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_7b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[6] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_7b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[6] = [0, 0, 1]
	current_djinn.talent1_path = ""

func _on_t_8b_1_toggled(toggled_on):
	current_djinn.talent_tree_spread[7] = [1, 0, 0]
	current_djinn.talent1_path = ""

func _on_t_8b_2_toggled(toggled_on):
	current_djinn.talent_tree_spread[7] = [0, 1, 0]
	current_djinn.talent1_path = ""

func _on_t_8b_3_toggled(toggled_on):
	current_djinn.talent_tree_spread[7] = [0, 0, 1]
	current_djinn.talent1_path = ""

func on_pressed(button):
	
	current_button = button
	
	if current_button.is_in_group("fire_tier1") && current_button.button_pressed == true:
		enable_row(2)
	
	if current_button.is_in_group("fire_tier2") && current_button.button_pressed == true:
		enable_row(3)
	
	if current_button.is_in_group("fire_tier3") && current_button.button_pressed == true:
		enable_row(4)
			
	if current_button.is_in_group("fire_tier4") && current_button.button_pressed == true:
		enable_row(5)
			
	if current_button.is_in_group("fire_tier5") && current_button.button_pressed == true:
		enable_row(6)
			
	if current_button.is_in_group("fire_tier6") && current_button.button_pressed == true:
		enable_row(7)
			
	if current_button.is_in_group("fire_tier7") && current_button.button_pressed == true:
		enable_row(8)

func enable_row(row_number):
	match(row_number):
		1:
			for i in get_tree().get_nodes_in_group("fire_tier1"):
				i.disabled = false
		2:
			for i in get_tree().get_nodes_in_group("fire_tier2"):
				i.disabled = false
		3:
			for i in get_tree().get_nodes_in_group("fire_tier3"):
				i.disabled = false
		4:
			for i in get_tree().get_nodes_in_group("fire_tier4"):
				i.disabled = false
		5:
			for i in get_tree().get_nodes_in_group("fire_tier5"):
				i.disabled = false
		6:
			for i in get_tree().get_nodes_in_group("fire_tier6"):
				i.disabled = false
		7:
			for i in get_tree().get_nodes_in_group("fire_tier7"):
				i.disabled = false
		8:
			for i in get_tree().get_nodes_in_group("fire_tier8"):
				i.disabled = false


func _on_reset_button_pressed():
	for button in get_tree().get_nodes_in_group("fire_talent_button"):
		button.button_pressed = false
		button.disabled = true
		
	for i in get_tree().get_nodes_in_group("fire_tier1"):
			i.disabled = false
	
	current_djinn.talent_tree_spread = [
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0]
	]

func set_talents(djinn):
	var i_index: int = 0
	var j_index: int = 0
	
	for i in djinn.talent_tree_spread:
		for j in i.size():
			if i[j] == 1: 
				talent_allocator(i_index,j_index)
			j_index += 1
		i_index += 1
		j_index = 0

func talent_allocator(i, j):
	if i == 0:
		enable_row(1)
		match(j):
			0:
				t_1b_1.button_pressed = true
			1:
				t_1b_2.button_pressed = true
			2:
				t_1b_3.button_pressed = true
	if i == 1:
		enable_row(2)
		match(j):
			0:
				t_2b_1.button_pressed = true
			1:
				t_2b_2.button_pressed = true
			2:
				t_2b_3.button_pressed = true
	if i == 2:
		enable_row(3)
		match(j):
			0:
				t_3b_1.button_pressed = true
			1:
				t_3b_2.button_pressed = true
			2:
				t_3b_3.button_pressed = true
	if i == 3:
		enable_row(4)
		match(j):
			0:
				t_4b_1.button_pressed = true
			1:
				t_4b_2.button_pressed = true
			2:
				t_4b_3.button_pressed = true
	if i == 4:
		enable_row(5)
		match(j):
			0:
				t_5b_1.button_pressed = true
			1:
				t_5b_2.button_pressed = true
			2:
				t_5b_3.button_pressed = true
	if i == 5:
		enable_row(6)
		match(j):
			0:
				t_6b_1.button_pressed = true
			1:
				t_6b_2.button_pressed = true
			2:
				t_6b_3.button_pressed = true
	if i == 6:
		enable_row(7)
		match(j):
			0:
				t_7b_1.button_pressed = true
			1:
				t_7b_2.button_pressed = true
			2:
				t_7b_3.button_pressed = true
	if i == 7:
		enable_row(8)
		match(j):
			0:
				t_8b_1.button_pressed = true
			1:
				t_8b_2.button_pressed = true
			2:
				t_8b_3.button_pressed = true


func _on_close_button_pressed():
	fire_talent_tree.visible = false
	save_djinn_data()
	queue_free()

func save_djinn_data():
	save_file_name = current_djinn.save_file_name
	ResourceSaver.save(current_djinn, save_file_path + save_file_name)
	print("save")

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
