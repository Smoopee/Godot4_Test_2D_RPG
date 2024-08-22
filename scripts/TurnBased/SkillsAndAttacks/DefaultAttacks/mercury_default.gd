extends Node2D

var power = 20
var target_selection: String = "Single"
var default_attack_name: String = "Flint Strike"

func default_attack_function(caster, target):
	var damage = caster.stats.attack * power
	target.change_health(-damage)
	
	caster.change_mana(20)
	caster.change_stamina(20)
	
