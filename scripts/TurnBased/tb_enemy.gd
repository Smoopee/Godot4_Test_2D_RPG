extends Node2D


@onready var tb_enemy_health_bar = $TBEnemyHealthBar
@onready var animated_sprite= $AnimatedSprite2D
@onready var dead_sprite = $DeadSprite
@onready var tb_enemy_shield_bar = $TBEnemyShieldBar
@onready var tb_enemy_stagger_bar = $TBEnemyStaggerBar
@onready var water = $Panel/Water
@onready var electric = $Panel/Electric
@onready var fire = $Panel/Fire



var speed: int = 30
var attack: int = 10
var health: int = 1000
var base_shield: int = 50
var shield: int = 50
var is_shielded: bool = true
var stagger: int = 0
var is_staggered: bool = false
var is_sprinting: bool = false
var is_dodging: bool = false
var shield_tracker: int = 0
var stagger_tracker: int = 0

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
	
	
	print(str(self) + " health is " + str(health))
	if health <= 0:
		health = 0
		set_state(State.DEAD)
		tb_enemy_health_bar.visible = false
		animated_sprite.visible = false
		dead_sprite.visible = true
		var game_state = get_tree().get_nodes_in_group("game_state_tracker")
		game_state[0].character_died(self)

func change_stagger(value):
	stagger -= value
	tb_enemy_stagger_bar.value -= value
	
	if stagger >= 100:
		stagger = 100
		is_staggered = true


func change_shield(value):
	shield += value
	tb_enemy_shield_bar.value = shield
	
	if shield <= 0:
		shield = 0
		is_shielded = false

func stagger_turn_tracker():
	if stagger == 100:
		stagger_tracker += 1
	
	if stagger_tracker == 1:
		change_stagger(100)
		is_staggered = false
		stagger_tracker = 0
	
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
		
	elemental_symbol_checker()
		
func add_fire_application(value, power, damage):
	fire_application += value
	fire.visible = true
	
	if water_application > 0:
		water_application -= 1
		fire_application -= 1
	
	boil(power, damage)
	
	elemental_symbol_checker()

func elemental_symbol_checker():
	if water_application == 0:
		water.visible = false
	
	if electric_application == 0:
		electric.visible = false
	
	if fire_application == 0:
		fire.visible = false

func zapped(power):
	var damage = power * 10
	
	var current_enemy_index = self.get_index()
	var right_enemy_index = current_enemy_index + 1
	var left_enemy_index = current_enemy_index - 1
	
	if right_enemy_index + 1 > self.get_parent().get_children().size():
		right_enemy_index = 0
	
	if current_enemy_index - 1 < 0:
		left_enemy_index = self.get_parent().get_children().size()-1
		
	change_health(-damage)
	
	print("Self is: " + str(self))
	
	if right_enemy_index != current_enemy_index:
		self.get_parent().get_child(right_enemy_index).change_health(-damage)
	
	if left_enemy_index != current_enemy_index:
		self.get_parent().get_child(left_enemy_index).change_health(-damage)
	
	print("You got zapped for: " + str(damage))

func boil(power, damage):
	var boil_damage = damage + power * 10
	change_health(-boil_damage)
	print("You've been boiled for: " + str(boil_damage))
