extends TextureProgressBar

func _ready():
	var health = Global.player_health
	value = health


func _process(delta):
	value = Global.player_health
