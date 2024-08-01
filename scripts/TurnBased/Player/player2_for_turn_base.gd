extends AnimatedSprite2D

var fireball_scene = load("res://scenes/TBScenes/SkillsAndAttacks/fireball_tb.tscn")

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
#-------------------------------------------------------------------------------

var max_health: int = 100
var max_mana: int = 100
var max_stamina: int = 100
var health: int = max_health
var attack = 50
var speed = 12

var da_attack: int = 0

func _ready():
	set_state(State.ALIVE)
	Global.change_max_player2_health(max_health)
	Global.change_max_player2_mana(max_mana)
	Global.change_max_player2_stamina(max_stamina)
	var fireball_skill = fireball_scene.instantiate()
	add_child(fireball_skill)
	
	fireball_skill.attack_initializer(attack)
	fireball_skill.attack_health_changer()

func get_speed():
	return speed
	
func change_health(value):
	Global.change_health_player2(value)
	health += value
	if health <= 0:
		health = 0
		set_state(State.DEAD)
		print("Your character DIED!")
