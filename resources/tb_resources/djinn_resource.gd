extends Resource

class_name Djinn

@export var turn_sprite: Texture


@export var name: String
@export var max_health: int 
@export var max_mana: int
@export var max_stamina: int
@export var health: int
@export var mana: int
@export var stamina: int
@export var attack: int
@export var speed: int
@export var base_speed: int
@export var intellect: int
@export var reaction_power: int
@export var ultimate_charge: int
@export var base_shield: int
@export var shield: int
@export var stagger_max: int
@export var crit_chance: int
@export var crit_damage: int
@export var lightning_resistance: int
@export var water_resistance: int
@export var fire_resistance: int
@export var level: int
@export var experience: int
@export var skill_one_name: String
@export var skill_two_name: String
@export var skill_one_path: String
@export var skill_two_path: String
@export var default_attack_name:String
@export var default_attack_path: String
@export var node_name: String
@export var save_file_name: String
@export var talent_tree_path: String
@export var talent_tree_spread: Array = [
	[0,0,0],
	[0,0,0],
	[0,0,0],
	[0,0,0],
	[0,0,0],
	[0,0,0],
	[0,0,0],
	[0,0,0],
]
@export var talent1_path: String
@export var talent2_path: String
@export var talent3_path: String
@export var talent4_path: String
@export var talent5_path: String
@export var talent6_path: String
@export var talent7_path: String
@export var talent8_path: String

var level_experience_bracket = [0,40,90,150,250,450,650,1000]

func change_experience(target, value):
	target.experience += value
	if target.experience > level_experience_bracket[target.level]:
		level_up(target)
		change_experience(target, 0)

func level_up(target):
	target.level += 1
	stats_on_level_up(target)
	target.health = target.max_health
	target.mana = target.max_mana
	print("Congrats! " + str(target["name"]) + " has leveled up to " + str(target.level) + "!")
	print("Their current experience is: " + str(target["experience"]))
	target.stamina = target.max_stamina

func stats_on_level_up(target):
	target.max_health += 4
	target.health += 4
	target.max_mana += 4
	target.mana += 4
	target.attack += 100
	target.speed += 2
	target.base_speed += 2
	target.intellect += 2
	target.reaction_power += 2
	print("djinn_resource: Target's attack is " + str(target.attack))

