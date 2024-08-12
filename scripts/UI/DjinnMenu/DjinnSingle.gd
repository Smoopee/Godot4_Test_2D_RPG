extends VBoxContainer

@onready var texture_rect = $TextureRect
@onready var label = $Label
@onready var skill_1_button = $SpellContainer/Skill1Button
@onready var skill_2_button = $SpellContainer/Skill2Button
@onready var spell_list = $"../SpellList"

var selected_djinn

var skill1_button_toggle: bool = false
var skill2_button_toggle: bool = false


func set_texture_and_spells(djinn):
	texture_rect.texture = djinn["texture"]
	label.text = djinn["name"]
	skill_1_button.text = djinn["skill_one"]
	skill_2_button.text = djinn["skill_two"]
	selected_djinn = djinn


func _on_skill_1_button_pressed():
	spell_list.visible = true
	skill1_button_toggle = true


func _on_skill_2_button_pressed():
	spell_list.visible = true
	skill2_button_toggle = true

func _on_spell_list_item_activated(index):
	if skill1_button_toggle == true:
		selected_djinn["skill_one"] = spell_list.get_item_text(index)
		skill_1_button.text = selected_djinn["skill_one"]
		spell_list.visible = false
		skill1_button_toggle = false
		
	if skill2_button_toggle == true:
		selected_djinn["skill_two"] = spell_list.get_item_text(index)
		skill_2_button.text = selected_djinn["skill_two"]
		spell_list.visible = false
		skill2_button_toggle = false
