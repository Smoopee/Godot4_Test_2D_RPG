extends Control

var turn_sprite_scene = load("res://scenes/TBScenes/enemy_turn_sprite_panel.tscn")

@export var enemy_resource: EnemyStatsTB
@onready var tb_enemy_health_bar = $VBoxContainer/TBEnemyHealthBar
@onready var animated_sprite = $AnimatedSprite2D

@onready var dead_sprite = $DeadSprite
@onready var tb_enemy_stagger_bar = $VBoxContainer/Panel/TBEnemyStaggerBar
@onready var tb_enemy_shield_bar = $VBoxContainer/TBEnemyHealthBar/TBEnemyShieldBar



@onready var panel = $VBoxContainer/Panel
@onready var water = $VBoxContainer/ElementalIndicators/Water
@onready var electric = $VBoxContainer/ElementalIndicators/Electric
@onready var fire = $VBoxContainer/ElementalIndicators/Fire





var speed: int = 30
var attack: int = 10
var health: int = 1000
var base_shield: int = 50
var shield: int = 50
var is_shielded: bool = true
var stagger: int = 0
var stagger_max: int = 300
var is_staggered: bool = false
var is_sprinting: bool = false
var is_dodging: bool = false
var shield_tracker: int = 0
var stagger_tracker: int = 0

var enemy_group = []

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
	tb_enemy_health_bar.max_value = health
	tb_enemy_health_bar.value = health
	tb_enemy_shield_bar.value = shield
	tb_enemy_stagger_bar.value = 0

func _on_resized():
	print("Enemy Resized")
	if animated_sprite == null: return
	animated_sprite.scale.x = get_viewport().size.x * 0.04
	animated_sprite.scale.y = get_viewport().size.y * 0.04
	animated_sprite.position.x = get_viewport().size.x * .5
	animated_sprite.position.y = get_viewport().size.y * .5
	tb_enemy_health_bar.scale.x = get_viewport().size.x * 0.0009
	tb_enemy_health_bar.scale.y = get_viewport().size.y * 0.002
	tb_enemy_stagger_bar.scale.x = get_viewport().size.x * 0.0009
	tb_enemy_stagger_bar.scale.y = get_viewport().size.y * 0.002
	electric.scale.x = get_viewport().size.x * 0.00002
	electric.scale.y = get_viewport().size.y * 0.00003
	fire.scale.x = get_viewport().size.x * 0.0001
	fire.scale.y = get_viewport().size.y * 0.0002
	water.scale.x = get_viewport().size.x * 0.0002
	water.scale.y = get_viewport().size.y * 0.0003


func get_speed():
	return speed

func change_health(value):
	change_shield(value)
	change_stagger(value)
	if is_shielded:
		value = round(value/2)
	
	if is_staggered:
		value = value * 2
	
	health += value
	tb_enemy_health_bar.value = health
	
	
	if health <= 0:
		health = 0
		set_state(State.DEAD)
		tb_enemy_health_bar.visible = false
		tb_enemy_shield_bar.visible = false
		tb_enemy_stagger_bar.visible = false
		animated_sprite.visible = false
		dead_sprite.visible = true
		var game_state = get_tree().get_nodes_in_group("game_state_tracker")
		game_state[0].character_died(self)

func change_speed(value):
	speed += value
	var game_state = get_tree().get_nodes_in_group("game_state_tracker")
	game_state[0].character_speed_change(self)

func change_stagger(value):
	stagger -= value
	tb_enemy_stagger_bar.value -= value
	
	if stagger >= stagger_max:
		stagger = stagger_max
		is_staggered = true
		speed -= 30


func change_shield(value):
	shield += value
	tb_enemy_shield_bar.value = shield
	
	if shield <= 0:
		shield = 0
		is_shielded = false

func stagger_turn_tracker():
	if stagger == stagger_max:
		stagger_tracker += 1
	
	if stagger_tracker == 1:
		change_stagger(stagger_max)
		is_staggered = false
		stagger_tracker = 0
		speed += 30
	
func shield_turn_tracker():
	if shield == 0:
		shield_tracker += 1
		
	if shield_tracker == 2:
		change_shield(base_shield)
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
		enemy_group.push_front(node)
#ELEMENTAL REACTIONS-----------------------------------------------------------
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
	var overcharge_damage = power * 10
	for i in enemy_group.size():
		enemy_group[i].change_shield(-overcharge_damage)
		enemy_group[i].change_stagger(-overcharge_damage)
		print("You've been hit for overcharge damage of: " + str(overcharge_damage))

func instantiate_turn_sprite(target, zSetter):
	var turn_sprite = turn_sprite_scene.instantiate()
	target.add_child(turn_sprite)
	turn_sprite.z_index = zSetter

func attack_ai(targets):
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, targets.size()-1)
	var enemy_target = targets[random]
	if enemy_target.is_dodging == false:
		enemy_target.change_health(-attack)



