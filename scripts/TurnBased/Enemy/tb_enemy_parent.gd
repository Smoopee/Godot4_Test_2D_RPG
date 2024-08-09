extends Control

class_name TBEnemyParent

var turn_sprite_scene = load("res://scenes/TBScenes/enemy_turn_sprite_panel.tscn")
var enemy_stats_resource = load("res://resources/tb_resources/Enemies/slimeBlue.tres")

@export var enemy_resource: EnemyStatsTB
@onready var tb_enemy_health_bar = $VBoxContainer/TBEnemyHealthBar
@onready var animated_sprite = $AnimatedSprite2D


@onready var tb_enemy_stagger_bar = $VBoxContainer/Panel/TBEnemyStaggerBar
@onready var tb_enemy_shield_bar = $VBoxContainer/TBEnemyHealthBar/TBEnemyShieldBar

@onready var elemental_indicators = $VBoxContainer/ElementalIndicators

@onready var panel = $VBoxContainer/Panel
@onready var water = $VBoxContainer/ElementalIndicators/Water
@onready var electric = $VBoxContainer/ElementalIndicators/Electric
@onready var fire = $VBoxContainer/ElementalIndicators/Fire



var is_shielded: bool
var is_staggered: bool = false
var is_sprinting: bool = false
var is_dodging: bool = false

var stagger: int
var shield_tracker: int
var stagger_tracker: int

var enemy_group = []
var stats: EnemyStatsTB = null 

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
	set_stats(enemy_stats_resource)
	set_state(State.ALIVE)
	tb_enemy_health_bar.max_value = stats.health
	tb_enemy_health_bar.value = stats.health
	tb_enemy_shield_bar.value = stats.shield
	tb_enemy_stagger_bar.value = 0
	print(stats.attack)

func set_stats(enemy_stats = EnemyStatsTB) -> void:
	stats = enemy_stats
	
func get_speed():
	return stats.speed

func change_health(value):
	change_shield(value)
	change_stagger(value)
	if is_shielded:
		value = round(value/2)
	
	if is_staggered:
		value = value * 2
	
	stats.health += value
	tb_enemy_health_bar.value = stats.health
	
	
	if stats.health <= 0:
		stats.health = 0
		set_state(State.DEAD)
		elemental_indicators.visible = false
		tb_enemy_health_bar.visible = false
		tb_enemy_shield_bar.visible = false
		tb_enemy_stagger_bar.visible = false
		animated_sprite.visible = false
		#dead_sprite.visible = true
		var game_state = get_tree().get_nodes_in_group("game_state_tracker")
		game_state[0].character_died(self)

func change_speed(value):
	stats.speed += value
	var game_state = get_tree().get_nodes_in_group("game_state_tracker")
	game_state[0].character_speed_change(self)

func change_stagger(value):
	stagger -= value
	tb_enemy_stagger_bar.value -= value
	
	if stagger >= stats.stagger_max:
		stagger = stats.stagger_max
		is_staggered = true
		stats.speed -= 30

func change_shield(value):
	stats.shield += value
	tb_enemy_shield_bar.value = stats.shield
	
	if stats.shield <= 0:
		stats.shield = 0
		is_shielded = false

func stagger_turn_tracker():
	if stagger == stats.stagger_max:
		stagger_tracker += 1
	
	if stagger_tracker == 1:
		change_stagger(stats.stagger_max)
		is_staggered = false
		stagger_tracker = 0
		stats.speed += 30
	
func shield_turn_tracker():
	if stats.shield == 0:
		shield_tracker += 1
		
	if shield_tracker == 2:
		change_shield(stats.base_shield)
		is_shielded = true
		shield_tracker = 0

func debuff_incrementer(body):
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("debuff"):
		if body.is_ancestor_of(node): 
			children_in_group.push_front(node)
			
	for i in children_in_group:
		i.turn_expiration(body)

func get_group_array():
	enemy_group = []
	for node in get_tree().get_nodes_in_group("enemy"):
		print("Enemy group is " + str(get_tree().get_nodes_in_group("enemy")))
		enemy_group.push_front(node)
#ELEMENTAL REACTIONS------------"-----------------------------------------------
var water_application = 0
var electric_application = 0
var fire_application = 0

func add_water_application(value, power):
	water_application += value
	water.visible = true
	
	if electric_application > 0:
		water_application -= 1
		electric_application -= 1
		zapped(power)
		
	if fire_application > 0:
		water_application -= 1
		fire_application -= 1
		boil(value, power)
	
	elemental_symbol_checker()

func add_electric_application(value, power):
	electric_application += value
	electric.visible = true
	
	if water_application > 0:
		water_application -= 1
		electric_application -= 1
		zapped(power)
	
	if fire_application > 0:
		fire_application -= 1
		electric_application -= 1
		overcharge(power)
		
	elemental_symbol_checker()

func add_fire_application(value, power, damage):
	fire_application += value
	fire.visible = true
	
	if water_application > 0:
		water_application -= 1
		fire_application -= 1
		boil(power, damage)
		
	if electric_application > 0:
		electric_application -= 1
		fire_application -= 1
		overcharge(power)
	
	elemental_symbol_checker()

func elemental_symbol_checker():
	if water_application == 0:
		water.visible = false
	
	if electric_application == 0:
		electric.visible = false
	
	if fire_application == 0:
		fire.visible = false

func zapped(power):
	get_group_array()
	print("Enemy group is: " + str(enemy_group))
	var damage = power * 10
	
	var current_enemy_index = enemy_group.find(self)
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1
	
	if right_enemy_index + 1 > enemy_group.size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = enemy_group.size()-1
		
	change_health(-damage)


	if right_enemy_index != current_enemy_index:
		enemy_group[right_enemy_index].change_health(-damage)
	
	if left_enemy_index != current_enemy_index:
		enemy_group[left_enemy_index].change_health(-damage)
	
	print("You got zapped for: " + str(damage))

func boil(power, damage):
	var boil_damage = damage + power * 10
	change_health(-boil_damage)
	print("You've been boiled for: " + str(boil_damage))

func overcharge(power):
	get_group_array()
	print(enemy_group)
	var overcharge_damage = power * 10
	for i in enemy_group.size():
		enemy_group[i].change_shield(-overcharge_damage)
		enemy_group[i].change_stagger(-overcharge_damage)
		print("You've been hit for overcharge damage of: " + str(overcharge_damage))

func instantiate_turn_sprite(target, zSetter):
	var turn_sprite = turn_sprite_scene.instantiate()
	target.add_child(turn_sprite)
	turn_sprite.get_child(0).texture = stats.turn_sprite
	turn_sprite.z_index = zSetter
