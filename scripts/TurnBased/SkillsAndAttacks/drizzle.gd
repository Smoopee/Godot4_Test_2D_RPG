extends CharacterBody2D

var power: int = 2
var multi_attack_power = 0
var mana_cost: int = 300
var hit_rate: float = .95
var target_selection: String = "AOE"
var elemental_typing: String = "Water"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Drizzle"

var target = self

func _ready():
	visible = false

func _process(delta):
	start_cast_path()


func start_cast_path():
	
	if animation_lok:
		global_position = target.global_position
		velocity = global_position.direction_to(target.global_position) * 600
		move_and_slide()
		animation_lok = false
		await get_tree().create_timer(1).timeout

func cast_skill(caster = null, target = null):
	target.attack -= 10
