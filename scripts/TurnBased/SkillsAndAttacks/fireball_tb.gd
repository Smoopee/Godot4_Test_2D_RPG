extends CharacterBody2D

var power: int = 10
var mana_cost: int = 50
var hit_rate: float = .95
var target_selection: String = "Single"
var elemental_typing: String = "Fire"
var elemental_intensity: int = 1
var attack_type: String = "Projectile"

var target = self

func _ready():
	visible = false
	
func _process(delta):
	start_cast_path()

func attack_initializer(attack_value):
	visible = true
	print("Fire ball hit for " + str(attack_value * power))
	return attack_value * power

func start_cast_path():
	var current_position = global_position
	velocity = current_position.direction_to(target.global_position) * 600
	move_and_slide()
	await get_tree().create_timer(1).timeout
	queue_free()

func get_spell_name():
	return "Fireball"
