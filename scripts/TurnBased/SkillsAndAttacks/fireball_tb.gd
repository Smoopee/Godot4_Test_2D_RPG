extends CharacterBody2D

var power: int = 10
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
	
func _process(_delta):
	start_cast_path()


func start_cast_path():
	var current_position = global_position
	velocity = current_position.direction_to(self.global_position) * 600
	move_and_slide()
	await get_tree().create_timer(1).timeout
	queue_free()

func cast_skill(caster = null, target = null):
	var elemental_reaction_power = caster.reaction_power
	var damage = caster.attack * power
	
	target.change_health(-damage)
	target.add_fire_application(elemental_intensity, elemental_reaction_power, damage)
