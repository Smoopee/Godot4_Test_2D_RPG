extends Panel

var party_member3 =  GlobalDjinnTracker.current_party[2]
var skill_one_scene =party_member3["skill_one_scene"]
var skill_two_scene =party_member3["skill_two_scene"]

var player_panel
var ultimate_bar

func _ready():
	var djinn = party_member3["scene"]
	add_child(djinn.instantiate())
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")
	var my_node = get_node(party_member3["node_name"])
	my_node.level_stats(party_member3["level"])
	
func ui_change_health(value):
	GlobalDjinnTracker.change_health(party_member3, value)
	player_panel[0].change_health(3)

func ui_change_mana(value):
	GlobalDjinnTracker.change_mana(party_member3, value)
	player_panel[0].change_mana(3)

func ui_change_stamina(value):
	GlobalDjinnTracker.change_stamina(party_member3, value)
	player_panel[0].change_stamina(3)

func charge_ultimate(value):
	ultimate_bar[0].value += value


