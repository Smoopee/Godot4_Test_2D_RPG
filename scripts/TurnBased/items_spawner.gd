extends Node

var health_flask_charges = 3
var mana_flask_charges = 3
var stamina_flask_charges = 3

func change_health_flask(value):
	health_flask_charges += 1

func change_mana_flask(value):
	mana_flask_charges += 1

func change_stamina_flask(value):
	stamina_flask_charges += 1

func use_health_flask(character):
	character.change_health(50)

func use_mana_flask(character):
	character.change_mana(50)

func use_stamina_flask(character):
	character.change_stamina(50)
