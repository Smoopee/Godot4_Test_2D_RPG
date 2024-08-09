extends CharacterBody2D

var hex_debuff_scene = load("res://scenes/TBScenes/SkillsAndAttacks/hex_debuff.tscn")


var power: int = 0
var multi_attack_power = 0
var mana_cost: int = 90
var hit_rate: float = .95
var target_selection: String = "AOE"
var elemental_typing: String = "Water"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Hex"


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

func cast_skill(_caster = null, target = null):
	var hex_debuff = hex_debuff_scene
	print("hex target is " + str(target))
	target.add_child(hex_debuff.instantiate())
	target.stats.attack -= 10
