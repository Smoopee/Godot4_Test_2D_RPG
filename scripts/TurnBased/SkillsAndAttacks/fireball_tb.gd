extends AnimatedSprite2D

var power: int = 10
var mana_cost: int = 10
var hit_rate: float = .95
var target_selection: String = "Single"
var elemental_typing: String = "Fire"
var elemental_intensity: int = 1
var damage: int = 0
var enemy_health = 1000


func attack_initializer(attack_value):
	damage = attack_value * power

func attack_health_changer():
	enemy_health -= damage
	print(enemy_health)
