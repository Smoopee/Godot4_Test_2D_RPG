extends Node

var tb_enemy_scene = load("res://scenes/TBScenes/Enemy/tb_enemy.tscn")
@onready var spawn_location = $"../SpawnLocation"

var rng = RandomNumberGenerator.new()
func _ready():
	var random_number_of_enemies = rng.randi_range(1,5)
	var n = 1
	
	while n <= random_number_of_enemies:
		var tb_enemy = tb_enemy_scene.instantiate()
		add_child(tb_enemy)
		n += 1

	
	for i in get_children().size():
		get_child(i).global_position = spawn_location.get_child(i).global_position
		get_child(i).scale = Vector2(2,2)
