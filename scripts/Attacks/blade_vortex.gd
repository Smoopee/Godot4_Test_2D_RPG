extends Area2D

@onready var blade_vortex_collision = $blade_vortex_collision
@onready var bv_sprite = $blade_vortex_collision/AnimatedSprite2D
@onready var bv_sprite2 = $blade_vortex_collision/AnimatedSprite2D2
@onready var bv_sprite3 = $blade_vortex_collision/AnimatedSprite2D3


var stacks = 0
var power = 2
var xLength = stacks * 1
var mana_cost = 10


func _process(delta):
	if stacks == 0:
		set_collision_layer_value(2, false)
	else:
		set_collision_layer_value(2, true)
		
	xLength = 5 + stacks * 3
	
	if stacks == 0:
		xLength = 0
		set_collision_layer_value(2, false)
		bv_sprite.visible = false
		bv_sprite2.visible = false
		bv_sprite3.visible = false
	elif stacks == 1:
		bv_sprite.visible = true
		bv_sprite2.visible = false
		bv_sprite3.visible = false
	elif stacks == 5:
		bv_sprite.visible = true
		bv_sprite2.visible = true
		bv_sprite3.visible = false
	elif stacks == 10:
		bv_sprite.visible = true
		bv_sprite2.visible = true
		bv_sprite3.visible = true
	
	if Input.is_action_just_pressed("attack"):
		if Global.player_mana < mana_cost:
			return
		print("stacks are: " + str(stacks))
		
		Global.change_mana(-mana_cost)
		
		if stacks >= 10:
			stacks = 10
		stacks += 1
		var timer : Timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.autostart = false
		timer.wait_time = 5.0
		timer.timeout.connect(_timer_Timeout)
		timer.start()
		
		blade_vortex_collision.shape.extents = Vector2(xLength, 0)
		blade_vortex_collision.position = Vector2(xLength, 0)
		
		bv_sprite.position = Vector2(xLength, 0)

func attack_callback(value):
	return stacks * value * power

func _timer_Timeout():
	stacks -= 1
	if stacks < 0:
		stacks = 0
