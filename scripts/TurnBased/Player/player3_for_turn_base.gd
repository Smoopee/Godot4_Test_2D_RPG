extends Control

var drizzle_scene = load("res://scenes/TBScenes/SkillsAndAttacks/drizzle.tscn")
var mist_scene = load("res://scenes/TBScenes/SkillsAndAttacks/mist.tscn")
var turn_sprite_scene = load("res://scenes/TBScenes/Player/TurnSprites/water_djinn_turn_sprite.tscn")
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
var max_health: int = 100
var max_mana: int = 100
var max_stamina: int = 100
var health: int = max_health
var mana: int = max_mana
var stamina: int = max_stamina
var attack = 10
var speed = 4
var base_speed = 10
var intellect = 20
var reaction_power = 5

var is_sprinting: bool = false
var is_dodging: bool = false

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

func _ready():
	player_panel = $"../../../../../PlayerPanel"
	
	set_state(State.ALIVE)
	Global.change_max_player3_health(max_health)
	Global.change_max_player3_mana(max_mana)
	Global.change_max_player3_stamina(max_stamina)
	instantiate_skill_one()
	instantiate_skill_two()

func _process(_delta):
	animated_sprite.scale.x = get_viewport().size.x * 0.002
	animated_sprite.scale.y = get_viewport().size.y * 0.002

func get_speed():
	return speed

func change_health(value):
	Global.change_health_player3(value)
	player_panel.change_health(3)
	health += value
	if health <= 0:
		health = 0
		set_state(State.DEAD)

func change_mana(value):
	Global.change_mana_player3(value)
	player_panel.change_mana(3)
	mana += value

func change_stamina(value):
	Global.change_stamina_player3(value)
	player_panel.change_stamina(3)
	stamina += value

func change_speed(value):
	speed += value
	var game_state = get_tree().get_nodes_in_group("game_state_tracker")
	game_state[0].character_speed_change(self)

func default_attack(defender):
	defender.change_health(-attack)
	self.change_mana(20)
	self.change_stamina(20)

func instantiate_skill_one():
	skill_one = drizzle_scene.instantiate()
	add_child(skill_one)
	skill_one_targeting = skill_one.target_selection
	skill_one_spellname = skill_one.spell_name
	skill_one_multi_damage = skill_one.multi_attack_power * attack
	skill_one_single_damage = skill_one.power * attack
	skill_one_mana_cost = skill_one.mana_cost

func instantiate_skill_two():
	skill_two = mist_scene.instantiate()
	add_child(skill_two)
	skill_two_targeting = skill_two.target_selection
	skill_two_spellname = skill_two.spell_name
	skill_two_multi_damage = skill_two.multi_attack_power * attack
	skill_two_single_damage = skill_two.power * attack
	skill_two_mana_cost = skill_two.mana_cost

func instantiate_turn_sprite(target, zSetter):
	var turn_sprite = turn_sprite_scene.instantiate()
	target.add_child(turn_sprite)
	turn_sprite.z_index = zSetter

func cast_sprint():
	Global.change_stamina_player3(-50)
	stamina = Global.player3_stamina
	player_panel.change_stamina(3)
	change_speed(50)
	is_sprinting = true

func stop_sprint():
	change_speed(-50)
	is_sprinting = false

func cast_dodge():
	Global.change_stamina_player3(-50)
	stamina = Global.player3_stamina
	player_panel.change_stamina(3)
	is_dodging = true

func stop_dodge():
	is_dodging = false

func cast_skill_one(caster = self, target = null):
	skill_one.cast_skill(caster, target)

func cast_skill_two(caster = self, target = null):
	skill_two.cast_skill(caster, target)

func buff_incrementer(body):
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("buff"):
		if body.is_ancestor_of(node): 
			children_in_group.push_front(node)
			
	for i in children_in_group:
		i.turn_expiration(body)
