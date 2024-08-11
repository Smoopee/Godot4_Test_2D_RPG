extends "res://scripts/TurnBased/Player/tb_djinn_parent.gd"


func _on_tree_entered():
	player_stats_resource = load("res://resources/tb_resources/Player/lightning_djinn.tres")
	set_stats(player_stats_resource)

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"level" : level,
		"experience" : experience
	}
	return save_dict
