extends VBoxContainer

@onready var texture_rect = $TextureRect
@onready var label = $Label
@onready var skill_1_button = $SpellContainer/Skill1Button
@onready var skill_2_button = $SpellContainer/Skill2Button
@onready var spell_list = $"../SpellList"

var save_file_path = "user://save/"
var save_file_name 

var selected_djinn

var skill1_button_toggle: bool = false
var skill2_button_toggle: bool = false


func set_texture_and_spells(djinn):
	texture_rect.texture = djinn.turn_sprite
	label.text = djinn.name
	skill_1_button.text = djinn.skill_one_name
	skill_2_button.text = djinn.skill_two_name
	selected_djinn = djinn


func _on_skill_1_button_pressed():
	spell_list.visible = true
	skill1_button_toggle = true


func _on_skill_2_button_pressed():
	spell_list.visible = true
	skill2_button_toggle = true

func _on_spell_list_item_activated(index):
	if index == spell_list.get_item_count() - 1: 
		spell_list.visible = false
		skill1_button_toggle = false
		skill2_button_toggle = false
		return
	
	if skill1_button_toggle == true:
		selected_djinn.skill_one_name = spell_list.get_item_text(index)
		skill_1_button.text = selected_djinn.skill_one_name
		selected_djinn.skill_one_path = GlobalObtainables.spell_list_dictionary[spell_list.get_item_text(index)]
		spell_list.visible = false
		skill1_button_toggle = false
		
	if skill2_button_toggle == true:
		selected_djinn.skill_two_name = spell_list.get_item_text(index)
		skill_2_button.text = selected_djinn.skill_two_name
		selected_djinn.skill_two_path = GlobalObtainables.spell_list_dictionary[spell_list.get_item_text(index)]
		spell_list.visible = false
		skill2_button_toggle = false
		
	save_djinn_data()
	print("selected Djinn is " + str(selected_djinn.skill_two_name))
	var temp = Global.current_party.find(selected_djinn)
	Global.current_party[temp] = selected_djinn

func save_djinn_data():
	save_file_name = selected_djinn.save_file_name
	ResourceSaver.save(selected_djinn, save_file_path + save_file_name)
	print("save")

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
