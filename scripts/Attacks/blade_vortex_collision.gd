extends CollisionShape2D


@onready var spin_to_win = $"../AnimationPlayer"


func _ready():
	spin_to_win.play("spin_to_win")
	spin_to_win.speed_scale = 2.0




