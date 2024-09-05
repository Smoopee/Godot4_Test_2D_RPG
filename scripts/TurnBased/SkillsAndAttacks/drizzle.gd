extends CharacterBody2D


var power: int = 2
var multi_attack_power = 0
var mana_cost: int = 60
var hit_rate: float = .95
var target_selection: String = "AOE"
var elemental_typing: String = "Water"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Drizzle"


func _ready():
	visible = false


func cast_skill(caster = null, target = null):
	var elemental_reaction_power = caster.stats.reaction_power
	var damage = caster.stats.attack * power
	
	target.change_health(-damage)
	target.add_water_application(elemental_intensity, elemental_reaction_power)
