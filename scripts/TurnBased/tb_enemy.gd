extends Node2D

@onready var tb_enemy_health_bar = $TBEnemyHealthBar

var speed: int = 2
var attack: int = 2

func _ready():
	tb_enemy_health_bar.value = 100

func get_speed():
	return speed
