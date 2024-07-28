extends CollisionShape2D

var d = 0.0
var stacks = 0
var xLength = stacks * 1
var mana_cost = 10

@onready var spin_to_win = $"../AnimationPlayer"
@onready var bv_sprite =  $AnimatedSprite2D
@onready var bv_sprite2 = $AnimatedSprite2D2
@onready var bv_sprite3 = $AnimatedSprite2D3
@onready var blade_vortex = $".."



func _ready():
	spin_to_win.play("spin_to_win")
	spin_to_win.speed_scale = 2.0

func _process(delta):
	d += delta
	
	if stacks == 0: 
		blade_vortex.set_collision_layer_value(2, false)
	else:
		blade_vortex.set_collision_layer_value(2, true)
	xLength = 5 + stacks * 3
	if stacks == 0:
		xLength = 0
		blade_vortex.set_collision_layer_value(2, false)
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
		print("stacks are: " + str(stacks))
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
		
	shape.extents = Vector2(xLength, 0)
	position = Vector2(xLength, 0)
	
	bv_sprite.position = Vector2(xLength, 0)


func _timer_Timeout():
	stacks -= 1
	if stacks < 0:
		stacks = 0

