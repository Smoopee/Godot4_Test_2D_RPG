extends TextureProgressBar

@onready var tb_enemy_health_bar = $".."


func _ready():
	modulate.a = 0.8
	global_position = tb_enemy_health_bar.global_position
