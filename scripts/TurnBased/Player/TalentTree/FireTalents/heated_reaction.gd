extends Node

var game_state_tracker

func ready():
	game_state_tracker = get_tree().get_nodes_in_group("game_state_tracker")
	
	
func trigger(djinn):
	print("Talent Heated Reaction Triggered")
	djinn.change_health(-10)
	djinn.change_mana(10)
