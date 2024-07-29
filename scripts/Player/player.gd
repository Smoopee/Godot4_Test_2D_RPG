extends CharacterBody2D

enum State{
	WALKING,
	IDLE,
	ATTACKING,
	RUNNING,
}

var blade_vortex_scene = load("res://scenes/Attacks/blade_vortex.tscn")
var blade_vortex

var maxHealth = 100
var maxMana = 100
var attack_power = 10
var da_damage: int

var speed = 50
var current_dir = "none"

# Click Inputs
var click_position = Vector2()
var target_positon = Vector2()

@onready var animated_sprite = $AnimatedSprite2D

@export var inventory:  Inventory


var current_state: int = -1: set = set_state

func _ready():
	# Click Position
	click_position = position
	set_state(State.IDLE)
	Global.change_max_player_health(maxHealth)
	Global.change_max_player_mana(maxMana)
	
	blade_vortex = blade_vortex_scene.instantiate()
	add_child(blade_vortex)
	
	print("Da Damage is: " + str(da_damage))

func _physics_process(delta):
	
	match current_state:
		State.WALKING:
			pass
		State.IDLE:
			idling()
		State.ATTACKING:
			pass
			
		State.RUNNING:
			pass
		_:
			pass
	
	player_movement(delta)
	
	if Input.is_action_just_pressed("attack"):
		set_state(State.ATTACKING)
		da_damage = blade_vortex.attack_callback(attack_power)


func set_state(new_state):
	if new_state == current_state:
		return
	
	current_state = new_state

func idling():
	pass

func player_movement(delta):
	
	# SPRINT
	if Input.is_action_pressed("sprint"):
		speed = 500
	if Input.is_action_just_released("sprint"):
		speed = 50
		
		
	# CLICK MOVEMENTS
	if Input.is_action_pressed("left_click"):
		click_position = get_global_mouse_position()
		set_state(State.WALKING)
	
	
	var animate_angle = target_positon.angle() # CURRENT DIRECTION OF CHARACTERS BETWEEN -3 and 3
	var character_direction: String
	
	# MOVE WITH CLICK
	if current_state != (State.ATTACKING):
		if position.distance_to(click_position) > 3:
			target_positon = (click_position - position).normalized()
			velocity = target_positon * speed
			move_and_slide()
		else: 
			velocity = Vector2.ZERO # STOPS VELOCITY WHEN TARGET REACHED
			if current_state != (State.ATTACKING):
				set_state(State.IDLE)


	# Setting  Direction
	if animate_angle < 2.25 and animate_angle > .75:
		character_direction = "front"
	if animate_angle > -2.25 and animate_angle < -.75:
		character_direction = "back"
	if animate_angle <= .75 and animate_angle >= -.75:
		character_direction = "right"
	if animate_angle < -2.25 or animate_angle > 2.25:
		character_direction = "left"

	player_animation(character_direction, current_state)
	
	
func player_animation(direction: String, state: State):
	
	# WALKING ANIMATIONS
	if direction == "front" and state == State.WALKING:
		animated_sprite.play("front_walk")
	if direction == "back" and state == State.WALKING:
		animated_sprite.play("back_walk")
	if direction == "right" and state == State.WALKING:
		animated_sprite.flip_h = false
		animated_sprite.play("side_walk")
	if direction == "left" and state == State.WALKING:
		animated_sprite.flip_h = true
		animated_sprite.play("side_walk")
	
	
	# IDLE ANIMATIONS
	if direction == "front" and state == State.IDLE:
		animated_sprite.play("front_idle")
	if direction == "back" and state == State.IDLE:
		animated_sprite.play("back_idle")
	if direction == "right" and state == State.IDLE:
		animated_sprite.flip_h = false
		animated_sprite.play("side_idle")
	if direction == "left" and state == State.IDLE:
		animated_sprite.flip_h = true
		animated_sprite.play("side_idle")

#GRABS THE LOOT
func _on_pickup_area_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func deal_da_damage():
	return da_damage
