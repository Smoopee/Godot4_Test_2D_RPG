extends CharacterBody2D

var power: int = 1000
var multi_attack_power = 0
var mana_cost: int = 30
var hit_rate: float = .95
var target_selection: String = "Single"
var elemental_typing: String = "Fire"
var elemental_intensity: int = 1
var attack_type: String = "Projectile"
var spell_name = "Fireball"



func _ready():
	visible = false
	

func cast_skill(caster = null, target = null):
	var elemental_reaction_power = caster.stats.reaction_power
	var damage = caster.stats.attack * power
	
	target.change_health(-damage)
	target.add_fire_application(elemental_intensity, elemental_reaction_power, damage)
