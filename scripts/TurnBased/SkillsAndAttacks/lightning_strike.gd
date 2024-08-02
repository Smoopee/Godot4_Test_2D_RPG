extends CharacterBody2D

var power: int = 10
var mana_cost: int = 30
var hit_rate: float = .95
var target_selection: String = "Multi"
var elemental_typing: String = "Lightning"
var elemental_intensity: int = 1
var attack_type: String = "Bolt"
var animation_lok = true

var target = self

func _ready():
	visible = false

func _process(delta):
	start_cast_path()

func attack_initializer(attack_value):
	visible = true
	print("Lightning Strike hit for " + str(attack_value * power))
	return attack_value * power

func start_cast_path():
	
	if animation_lok:
		global_position = target.global_position
		velocity = global_position.direction_to(target.global_position) * 600
		move_and_slide()
		animation_lok = false
		await get_tree().create_timer(1).timeout
		queue_free()
	
func get_spell_name():
	return "Lightning Strike"
