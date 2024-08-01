extends Node2D

@onready var tb_enemy_health_bar = $TBEnemyHealthBar

var speed: int = 2
var attack: int = 100
var health: int = 100

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
func _ready():
	set_state(State.ALIVE)
	tb_enemy_health_bar.value = health

func get_speed():
	return speed

func change_health(value):
	health += value
	tb_enemy_health_bar.value = health
	if health <= 0:
		health = 0
		set_state(State.DEAD)
