extends "res://scripts/TurnBased/Player/tb_djinn_parent.gd"


func _on_tree_entered():
	player_stats_resource = load("res://resources/tb_resources/Player/fire_djinn.tres")
	set_stats(player_stats_resource)
