extends "res://scripts/TurnBased/Enemy/tb_enemy_parent.gd"


func _on_tree_entered():
	enemy_stats_resource = load("res://resources/tb_resources/Enemies/minoutaur.tres")
	set_stats(enemy_stats_resource)

func attack_ai(targets):
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, targets.size()-1)
	
	for i in targets:
		if i.is_dodging == false:
			i.change_health(-stats.attack)


