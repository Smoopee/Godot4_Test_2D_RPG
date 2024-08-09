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

var player_group = []

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

func get_group_array():
	player_group = []
	for node in get_tree().get_nodes_in_group("djinn"):
		player_group.push_front(node)

func cast_skill(_caster = null, target = null):
	get_group_array()
	
	var momentum_buff = momentum_buff_scene

	var current_player_index = player_group.find(target)
	var right_player_index = current_player_index + 1
	var left_player_index = current_player_index - 1
	
	if right_player_index + 1 > player_group.size():
		right_player_index = 0
	
	if current_player_index - 1 < 0:
		left_player_index = player_group.size()-1
	
	player_group[current_player_index].add_child(momentum_buff.instantiate())
	print("Target's children are " + str(target.get_node("MomentumBuff")))
	target.get_node("MomentumBuff").speed_buff = 50
	player_group[current_player_index].change_speed(50)
	
	if right_player_index != current_player_index:
		player_group[right_player_index].add_child(momentum_buff.instantiate())
		player_group[right_player_index].get_node("MomentumBuff").speed_buff = 25
		player_group[right_player_index].change_speed(25)
	if left_player_index != current_player_index:
		player_group[left_player_index].add_child(momentum_buff.instantiate())
		player_group[left_player_index].get_node("MomentumBuff").speed_buff = 25
		player_group[left_player_index].change_speed(25)

