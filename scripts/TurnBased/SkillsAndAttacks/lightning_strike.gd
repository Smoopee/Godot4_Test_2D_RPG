extends CharacterBody2D


var power: int = 20
var multi_attack_power = 15
var mana_cost: int = 60
var hit_rate: float = .95
var target_selection: String = "Multi"
var elemental_typing: String = "Lightning"
var elemental_intensity: int = 1
var attack_type: String = "Bolt"
var animation_lok = true
var spell_name = "Lightning Strike"

var enemy_group
func _ready():
	visible = false

func get_group_array():
	enemy_group = []
	for node in get_tree().get_nodes_in_group("enemy"):
		enemy_group.push_front(node)


func cast_skill(caster = null, target = null):
	
	get_group_array()
	
	print("Enemies " + str(enemy_group))
	
	var elemental_reaction_power = caster.stats.reaction_power
	var current_enemy_index = enemy_group.find(target)
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1

	if right_enemy_index + 1 > enemy_group.size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = enemy_group.size()-1

	target.change_health(-caster.skill_one_single_damage)
	target.add_electric_application(elemental_intensity, elemental_reaction_power)
	if right_enemy_index != current_enemy_index:
		enemy_group[right_enemy_index].change_health(-caster.skill_one_multi_damage)
		enemy_group[right_enemy_index].add_electric_application(elemental_intensity, elemental_reaction_power)
	if left_enemy_index != current_enemy_index:
		enemy_group[left_enemy_index].change_health(-caster.skill_one_multi_damage)
		enemy_group[left_enemy_index].add_electric_application(elemental_intensity, elemental_reaction_power)

