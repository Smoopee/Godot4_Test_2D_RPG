extends Control

@onready var damage_number_2d_template = preload("res://scenes/TBScenes/TBBattleScene/UIPanels/combat_text.tscn")

var damage_number_2d_pool: Array[DamageNumber2D] = []

func spawn_damage_number(value: int, spawn_location):
	var damage_number = get_damage_number()
	var val = str(round(value))
	var pos = spawn_location 
	var height = 30
	var spread = 30
	add_child(damage_number, true)
	damage_number.set_value_and_animate(val,pos,height,spread)


func get_damage_number() -> DamageNumber2D:
	if damage_number_2d_pool.size() > 0:
		return damage_number_2d_pool.pop_front()
	else:
		var new_damage_number = damage_number_2d_template.instantiate()
		new_damage_number.tree_exiting.connect(
			func():damage_number_2d_pool.append(new_damage_number))
		return new_damage_number
