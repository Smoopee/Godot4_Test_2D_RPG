extends Node

var game_state_tracker

func ready():
	game_state_tracker = get_tree().get_nodes_in_group("game_state_tracker")
	
	
func trigger(djinn):
		print("Talent Quick Charge Triggered")
		djinn.change_mana(20)
