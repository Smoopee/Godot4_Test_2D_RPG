extends AnimatedSprite2D

var lightning_strike_scene = load("res://scenes/TBScenes/SkillsAndAttacks/lightning_strike.tscn")

@onready var player_panel = $"../../CanvasLayer/PlayerPanel"


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
var attack = 100
var speed = 21
var base_speed = 11

var is_sprinting: bool = false
var is_dodging: bool = false

#SKILL ONE SETUP----------------------------------------------------------------
var skill_one_spellname: String
var skill_one_targeting: String
var skill_one_multi_damage: int
var skill_one_single_damage: int
var skill_one_mana_cost: int
var skill_one

#DEFAULT ATTACK SETUP-----------------------------------------------------------
var default_attack_targeting: String = "Single"



func _ready():
	set_state(State.ALIVE)
	Global.change_max_player1_health(max_health)
	Global.change_max_player1_mana(max_mana)
	Global.change_max_player1_stamina(max_stamina)
	instantiate_skill_one()

func get_speed():
	return speed

func change_health(value):
	Global.change_health_player1(value)
	player_panel.change_health(1)
	health += value
	if health <= 0:
		health = 0
		set_state(State.DEAD)
		print("Your character DIED!")

func change_mana(value):
	Global.change_mana_player1(value)
	player_panel.change_mana(1)
	mana += value

func instantiate_skill_one():
	skill_one = lightning_strike_scene.instantiate()
	add_child(skill_one)
	skill_one_targeting = skill_one.target_selection
	skill_one_spellname = skill_one.get_spell_name()
	skill_one_multi_damage = skill_one.multi_attack_power * attack
	skill_one_single_damage = skill_one.power * attack
	skill_one_mana_cost = skill_one.mana_cost
	

func cast_sprint():
	Global.change_stamina_player1(-50)
	player_panel.change_stamina(1)
	stamina = Global.player1_stamina
	speed += 50
	is_sprinting = true

func stop_sprint():
	speed = base_speed
	is_sprinting = false

func cast_dodge():
	Global.change_stamina_player1(-50)
	stamina = Global.player1_stamina
	player_panel.change_stamina(1)
	is_dodging = true

func stop_dodge():
	is_dodging = false

