extends Node2D

var power = 20
var target_selection: String = "Friendly_AOE"
var default_attack_name: String = "Quench"

func default_attack_function(caster, target):
	var heal = caster.stats.attack * power
	target.change_health(heal)
	
	caster.change_mana(20)
	caster.change_stamina(20)
