extends "res://scripts/TurnBased/Enemy/tb_enemy_parent.gd"

func _on_tree_entered():
	enemy_stats_resource = load("res://resources/tb_resources/Enemies/gobuss.tres")
	set_stats(enemy_stats_resource)



func attack_ai(targets):
	print("Enemy targets are " + str(targets))
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, targets.size()-1)
	print("Random number is: " + str(random))
	var enemy_target = targets[random]
	if enemy_target.is_dodging == false:
		enemy_target.change_health(-stats.attack)


