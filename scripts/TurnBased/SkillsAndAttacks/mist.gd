extends CharacterBody2D

var power: int = 2
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

func _process(_delta):
	start_cast_path()


func start_cast_path():
	
	if animation_lok:
		velocity = global_position.direction_to(global_position) * 600
		move_and_slide()
		animation_lok = false
		await get_tree().create_timer(1).timeout

func cast_skill(caster = null, target = null):
	target.change_health(caster.intellect * power)
