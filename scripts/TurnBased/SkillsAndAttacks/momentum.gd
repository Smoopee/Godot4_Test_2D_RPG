extends CharacterBody2D

var momentum_buff_scene = load("res://scenes/TBScenes/SkillsAndAttacks/Buffs/momentum_buff.tscn")


var power: int = 0
var multi_attack_power = 0
var mana_cost: int = 30
var hit_rate: float = .95
var target_selection: String = "Friendly_Multi"
var elemental_typing: String = "Lightning"
var elemental_intensity: int = 1
var attack_type: String = "Pool"
var animation_lok = true
var spell_name = "Momentum"


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
	var momentum_buff = momentum_buff_scene

	var current_player_index = target.get_index()
	var right_player_index = current_player_index + 1
	var left_player_index = current_player_index - 1
	
	if right_player_index + 1 > target.get_parent().get_children().size():
		right_player_index = 0
	
	if current_player_index - 1 < 0:
		left_player_index = target.get_parent().get_children().size()-1
	
	target.get_parent().get_child(current_player_index).add_child(momentum_buff.instantiate())
	print("Target's children are " + str(target.get_node("MomentumBuff")))
	target.get_node("MomentumBuff").speed_buff = 50
	target.get_parent().get_child(current_player_index).change_speed(50)
	
	if right_player_index != current_player_index:
		target.get_parent().get_child(right_player_index).add_child(momentum_buff.instantiate())
		target.get_parent().get_child(right_player_index).get_node("MomentumBuff").speed_buff = 25
		target.get_parent().get_child(right_player_index).change_speed(25)
	if left_player_index != current_player_index:
		target.get_parent().get_child(left_player_index).add_child(momentum_buff.instantiate())
		target.get_parent().get_child(left_player_index).get_node("MomentumBuff").speed_buff = 25
		target.get_parent().get_child(left_player_index).change_speed(25)

