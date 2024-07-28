extends CharacterBody2D

signal state_changed(new_state)
signal health_change(value)

var enemy_attack_area_scene = load("res://scenes/Enemy/enemy_attack_area.tscn")

enum State{
	ROAM,
	AGGRO,
	RETURN,
	STAY,
	DEAD,
	ATTACK,
	ATTACKING,
}


@export var speed = 10
@export var knockbackPower = 40
@export var attack_range = 10

@onready var aggro_range = $detection_area/CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var roam_timer = $RoamTimer
@onready var return_timer = $ReturnTimer
@onready var collision_area = $collision_area
@onready var health_bar = $health_bar
@onready var attack_timer = $AttackTimer
@onready var attack_recovery_timer = $AttackRecoveryTimer
@onready var can_attack_timer = $CanAttackTimer
@onready var player_health_bar = $"../../UI/player_health_bar"
@onready var world = $"../.."

var current_state: int = -1: set = set_state
var player

# STATS
var health = 100
var attack = -10
var chase_range = 7

# ROAM STATE VARIABLES
var home 
var home_location_reached := false
var roam_location: Vector2 = Vector2.ZERO
var roam_location_reached := false

# ATTACK VARIABLES
var can_attack = true
var target_attack_position
var attack_position_reached = true


func _ready():
	set_state(State.ROAM)
	home = position
	
	health_bar.value = health
	
func _physics_process(delta):
	
	# Testing
	if health <= 0:
		enemey_death()
		
	match current_state:
		State.ROAM:
			if not roam_location_reached:
				move_and_slide()
				if position.distance_to(roam_location) < 5:
					roam_location_reached = true
					velocity = Vector2.ZERO
					roam_timer.start()
		State.AGGRO:
			if player != null and current_state != State.DEAD:
				aggrod() 
		State.RETURN:
			home_location_reached = false
			if not home_location_reached:
				if position.distance_to(home) < 5:
					print("Roaming")
					home_location_reached = true
					set_state(State.ROAM)
					animated_sprite.play("idle")
					velocity = Vector2.ZERO
				move_and_slide()	
				velocity = position.direction_to(home) * speed
		State.STAY:
			velocity = Vector2.ZERO
		State.ATTACK:
			enemy_attack()
		State.ATTACKING:
			attacking()
		State.DEAD:
			pass
		_:
			print("NO STATE")


func set_state(new_state):
	if new_state == current_state:
		return
	
	if new_state == State.ROAM:
		roam_timer.start()
		roam_location_reached = true
	
	current_state = new_state
	emit_signal("state_changed", current_state)


# Controls Patrol/Roam Functions
func _on_roam_timer_timeout():
	var roam_range = 50
	var random_x = randf_range(-roam_range, roam_range)
	var random_y = randf_range(-roam_range, roam_range)
	roam_location = Vector2(random_x, random_y) + home
	roam_location_reached = false
	velocity = position.direction_to(roam_location) * speed

func _on_return_timer_timeout():
	set_state(State.RETURN)


# Controls Aggro Functions
func aggrod():
	# Leashing Mechanics
	if position.distance_to(home) > 400:
		set_state(State.RETURN)
		return
		
	if (position - player.position).length() > 200:
		print("Returning Home")
		animated_sprite.play("idle")
		set_state(State.STAY)
		return_timer.start()
		return
	
	# Starts Attacking 
	if (position - player.position).length() < attack_range and can_attack:
		print("Attacking")
		set_state(State.ATTACK)
		return
	elif(position - player.position).length() < chase_range and !can_attack:
		velocity = Vector2.ZERO
		return
		
	animated_sprite.play("aggro")
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed 
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		print("Aggro")
		set_state(State.AGGRO)
		player = body



# Controls HitBox and Knockback of Attacks
func _on_collision_area_area_entered(area):
	if !area.is_in_group("attack"):
		return
	
	velocity = position + (position - area.get_parent().position) * knockbackPower
	move_and_slide()
	
	health -= 10
	health_bar.value = health
	print("Health is: " + str(health_bar.value))



# Controls Enemey Death
func enemey_death():
	animated_sprite.play("death")
	set_state(State.DEAD)
	collision_area.set_collision_mask_value(2, false)
	set_collision_layer_value(2, false)
	var animate_death_timer : Timer = Timer.new()
	add_child(animate_death_timer)
	animate_death_timer.one_shot = true
	animate_death_timer.autostart = false
	animate_death_timer.wait_time = 1.0
	animate_death_timer.timeout.connect(_animate_death_timer_Timeout)
	animate_death_timer.start()

func _animate_death_timer_Timeout():
	animated_sprite.play("corpse")
	health_bar.hide()
	world.spawn_loot(position)
	queue_free()


# Controls Enemy Attacks
func enemy_attack():
	set_state(State.STAY)
	target_attack_position = player.position
	attack_position_reached = false
	animated_sprite.play("attacking")
	create_enemey_attack_area(target_attack_position)
	print("attack position is: " + str(target_attack_position))
	print("First Phase of Attack")
	await get_tree().create_timer(1).timeout
	
	attacking()
	


func attacking():
	set_state(State.ATTACKING)
	
	if position.distance_to(target_attack_position) >= 3:
		velocity = position.direction_to(target_attack_position) * 300
		move_and_slide()
		return
	
	if position.distance_to(target_attack_position) < 10:
		attack_position_reached = true
		print("attack position reached")
		if (position - player.position).length() < 30:
			player_health_bar.value += attack
			print("Health bar value is: " + str(player_health_bar.value))
			print("My attack hit!")

	print("I have unleashed my attack")
	set_state(State.STAY)
	attack_recovery_timer.start()
	can_attack = false
	can_attack_timer.start()


func _on_attack_recovery_timer_timeout():
	set_state(State.AGGRO)


func _on_can_attack_timer_timeout():
	can_attack = true


func create_enemey_attack_area(location):
	var enemey_attack_area = enemy_attack_area_scene.instantiate()
	add_sibling(enemey_attack_area)
	enemey_attack_area.position = location
	print("Actual position is " + str(location))
	await get_tree().create_timer(1.2).timeout
	#enemey_attack_area.visible = false
	enemey_attack_area.queue_free()
