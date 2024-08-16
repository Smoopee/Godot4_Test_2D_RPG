extends "res://scripts/TurnBased/Player/tb_djinn_parent.gd"


func _on_tree_entered():
	player_stats_resource = load("res://resources/tb_resources/Player/fire_djinn.tres")
	set_stats(player_stats_resource)

func level_stats(level = 1):
	stats.attack = stats.attack + level * 3
	stats.health = stats.health + level * 30
