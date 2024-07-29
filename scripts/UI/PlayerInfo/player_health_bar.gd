extends TextureProgressBar


func _ready():
	var health = Global.player_health
	value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	value = Global.player_health
