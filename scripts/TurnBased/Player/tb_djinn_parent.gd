extends Panel


var turn_sprite_scene = load("res://scenes/TBScenes/TBBattleScene/turn_sprite_template.tscn")

var player_stats_resource = load("res://resources/tb_resources/Player/generic_player_tb.tres")

@export var enemy_resource: PlayerStatsTB

@onready var animated_sprite = $AnimatedSprite2D


#DECLARES AND SETS STATES-------------------------------------------------------
enum State{
	DEAD,
	ALIVE,
}

var current_state: int = -1: set = set_state

func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state

#Generic Stats------------------------------------------------------------------
var is_sprinting: bool = false
var is_dodging: bool = false

var stats: PlayerStatsTB = null 

#SKILL ONE SETUP----------------------------------------------------------------
var skill_one_spellname: String
var skill_one_targeting: String
var skill_one_multi_damage: int
var skill_one_single_damage: int
var skill_one_mana_cost: int
var skill_one

#SKILL TWO SETUP----------------------------------------------------------------
var skill_two_spellname: String
var skill_two_targeting: String
var skill_two_multi_damage: int
var skill_two_single_damage: int
var skill_two_mana_cost: int
var skill_two


#DEFAULT ATTACK SETUP-----------------------------------------------------------
var default_attack_targeting: String = "Single"

var player_panel
var player_position

func _ready():
	set_stats(player_stats_resource)
	set_state(State.ALIVE)
	instantiate_skill_one()
	instantiate_skill_two()


func _on_resized():
	if animated_sprite == null: return
	
	animated_sprite.scale.x = get_viewport().size.x * 0.0015
	animated_sprite.scale.y = get_viewport().size.y * 0.0015
	
func set_stats(player_stats =PlayerStatsTB) -> void:
	stats = player_stats

func get_speed():
	return stats.speed

func change_health(value):
	get_parent().ui_change_health(value)
	stats.health += value
	if stats.health <= 0:
		stats.health = 0
		set_state(State.DEAD)
		print("Your character DIED!")

func change_mana(value):
	get_parent().ui_change_mana(value)
	stats.mana += value
	if stats.mana <= 0:
		stats.mana = 0

func change_stamina(value):
	get_parent().ui_change_stamina(value)
	stats.stamina += value
	if stats.stamina <= 0:
		stats.stamina = 0

func change_speed(value):
	stats.speed += value
	var game_state = get_tree().get_nodes_in_group("game_state_tracker")
	game_state[0].character_speed_change(self)

func default_attack(defender):
	defender.change_health(-stats.attack)
	change_mana(20)
	change_stamina(20)

func instantiate_skill_one():
	skill_one = get_parent().skill_one_scene.instantiate()
	add_child(skill_one)
	skill_one_targeting = skill_one.target_selection
	skill_one_spellname = skill_one.spell_name
	skill_one_multi_damage = skill_one.multi_attack_power * stats.attack
	skill_one_single_damage = skill_one.power * stats.attack
	skill_one_mana_cost = skill_one.mana_cost

func instantiate_skill_two():
	skill_two = get_parent().skill_two_scene.instantiate()
	add_child(skill_two)
	skill_two_targeting = skill_two.target_selection
	skill_two_spellname = skill_two.spell_name
	skill_two_multi_damage = skill_two.multi_attack_power * stats.attack
	skill_two_single_damage = skill_two.power * stats.attack
	skill_two_mana_cost = skill_two.mana_cost

func instantiate_turn_sprite(target, zSetter):
	var turn_sprite = turn_sprite_scene.instantiate()
	target.add_child(turn_sprite)
	turn_sprite.get_child(0).texture = stats.turn_sprite
	turn_sprite.z_index = zSetter

func cast_sprint():
	change_stamina(-50)
	change_speed(50)
	is_sprinting = true

func stop_sprint():
	change_speed(-50)
	is_sprinting = false

func cast_dodge():
	change_stamina(-50)
	is_dodging = true

func stop_dodge():
	is_dodging = false

func cast_skill_one(caster = self, target = null):
	skill_one.cast_skill(caster, target)
	get_parent().charge_ultimate(stats.ultimate_charge)
	print("skill one has been cast and ultimate is charged by: " + str(stats.ultimate_charge))
func cast_skill_two(caster = self, target = null):
	skill_two.cast_skill(caster, target)
	get_parent().charge_ultimate(stats.ultimate_charge)

func buff_incrementer(body):
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("buff"):
		if body.is_ancestor_of(node): 
			children_in_group.push_front(node)
			
	for i in children_in_group:
		i.turn_expiration(body)



