extends CharacterBody2D

var power: int = 4
var multi_attack_power = 0
var mana_cost: int = 50
var hit_rate: float = .95
var target_selection: String = "Friendly_AOE"
var elemental_typing: String = "Water"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Mist"


func _ready():
	visible = false


func cast_skill(caster = null, target = null):
	target.change_health(caster.stats.intellect * power)
