extends Sprite2D

@onready var animation_player = $AnimationPlayer


func arrow_blink():
	animation_player.play("arrow_blink")

func arrow_stop():
	animation_player.stop()
