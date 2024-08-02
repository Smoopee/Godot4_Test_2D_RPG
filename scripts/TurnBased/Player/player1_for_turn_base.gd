extends AnimatedSprite2D

var lightning_strike_scene = load("res://scenes/TBScenes/SkillsAndAttacks/lightning_strike.tscn")

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
var attack = 100
var speed = 110
var base_speed = 11

var is_sprinting: bool = false
var is_dodging: bool = false

#SKILL ONE SETUP----------------------------------------------------------------
var skill_one_spellname: String
var skill_one_targeting: String
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
	health += value
	if health <= 0:
		health = 0
		set_state(State.DEAD)
		print("Your character DIED!")

func instantiate_skill_one():
	skill_one = lightning_strike_scene.instantiate()
	add_child(skill_one)
	skill_one_targeting = skill_one.target_selection
	skill_one_spellname = skill_one.get_spell_name()
	
func cast_skill_one():
	Global.change_mana_player1(-skill_one.mana_cost)
	return skill_one.attack_initializer(attack)

func cast_sprint():
	Global.change_stamina_player1(-50)
	speed += 50
	is_sprinting = true
	print(skill_one_targeting)

func stop_sprint():
	speed = base_speed
	is_sprinting = false

func cast_dodge():
	Global.change_stamina_player1(-50)
	is_dodging = true

func stop_dodge():
	is_dodging = false
