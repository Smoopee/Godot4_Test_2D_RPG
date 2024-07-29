extends AnimatedSprite2D

var fireball_scene = load("res://scenes/TBScenes/SkillsAndAttacks/fireball_tb.tscn")

var attack = 11
var health = 100
var mana = 100

var enemy_health = 100

var da_attack: int = 0

func _ready():
	var fireball_skill = fireball_scene.instantiate()
	add_child(fireball_skill)
	
	fireball_skill.attack_initializer(attack)
	fireball_skill.attack_health_changer()
	
