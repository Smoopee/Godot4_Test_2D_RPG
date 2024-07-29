extends TextureProgressBar

func _ready():
	var mana = Global.player_mana
	value = mana


func _process(delta):
	value = Global.player_mana
