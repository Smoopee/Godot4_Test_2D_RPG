extends Control

@onready var spell_list = $SpellList
@onready var djinn_single = $DjinnSingle
@onready var djinn_party = $DjinnParty
@onready var open_menu = $OpenMenu
@onready var close_button = $DjinnParty/CloseButton
@onready var overworld_1 = $"../.."


@onready var party = Global.current_party

func _ready():
	print("party now is " + str(party))

func _on_open_menu_pressed():
	djinn_party.visible = true
	open_menu.visible = false
	get_tree().paused = true
	djinn_party.set_djinn_party()

func _on_close_button_pressed():
	djinn_party.visible = false
	open_menu.visible = true
	get_tree().paused = false


func _on_button_1_pressed():
	djinn_single.set_texture_and_spells(party[0])
	djinn_party.visible = false
	djinn_single.visible = true


func _on_button_2_pressed():
	djinn_single.set_texture_and_spells(party[1])
	djinn_party.visible = false
	djinn_single.visible = true


func _on_button_3_pressed():
	djinn_single.set_texture_and_spells(party[2])
	djinn_party.visible = false
	djinn_single.visible = true


func _on_back_button_pressed():
	djinn_single.visible = false
	djinn_party.visible = true
	


