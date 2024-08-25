extends Node

var game_state_tracker

func ready():
	game_state_tracker = get_tree().get_nodes_in_group("game_state_tracker")
	
	
func trigger(djinn):
	var game_state_tracker_array = get_tree().get_nodes_in_group("game_state_tracker")
	game_state_tracker = game_state_tracker_array[0]
	
	if game_state_tracker.turn_queue.action_counter == 1:
		djinn.change_mana(20)
