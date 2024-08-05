extends CharacterBody2D


var power: int = 2
var multi_attack_power = 0
var mana_cost: int = 60
var hit_rate: float = .95
var target_selection: String = "AOE"
var elemental_typing: String = "Water"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Drizzle"


func _ready():
	visible = false

func _process(_delta):
	start_cast_path()


func start_cast_path():
	
	if animation_lok:
		global_position = self.global_position
		velocity = global_position.direction_to(self.global_position) * 600
		move_and_slide()
		animation_lok = false
		await get_tree().create_timer(1).timeout

func cast_skill(caster = null, target = null):
	var elemental_reaction_power = caster.reaction_power
	var damage = caster.attack * power
	
	target.change_health(-damage)
	target.add_water_application(elemental_intensity, elemental_reaction_power)
	

