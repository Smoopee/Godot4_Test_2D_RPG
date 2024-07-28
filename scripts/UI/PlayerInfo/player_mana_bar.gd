extends TextureProgressBar

var mana_timer_lock = true


func _ready():
	var mana = Global.player_mana
	value = mana


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		value -= 10
		print("Mana is: " + str(value))
		
	if mana_timer_lock:
		var timer : Timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.autostart = true
		timer.wait_time = 3.0
		timer.timeout.connect(_timer_Timeout)
		timer.start()
		mana_timer_lock = false

func _timer_Timeout():
	print("Gaining mana")
	value += 15
	mana_timer_lock = true
