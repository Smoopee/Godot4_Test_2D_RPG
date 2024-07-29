extends TextureProgressBar

func _ready():
	var stamina = Global.player_stamina
	value = stamina


func _process(delta):
	value = Global.player_stamina

