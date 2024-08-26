extends Node

var game_state_tracker

func ready():
	game_state_tracker = get_tree().get_nodes_in_group("game_state_tracker")
	
	
func trigger(djinn):
		print("Talent Mana Adept Triggered")
		djinn.skill_one_mana_cost -= 40
		djinn.skill_two_mana_cost -= 40
