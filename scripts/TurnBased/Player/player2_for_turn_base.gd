extends Panel

var party_member2 =  GlobalDjinnTracker.current_party[1]
var skill_one_scene =party_member2["skill_one_scene"]
var skill_two_scene =party_member2["skill_two_scene"]

var player_panel
var ultimate_bar

func _ready():
	var djinn = party_member2["scene"]
	add_child(djinn.instantiate())
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")
	var my_node = get_node(party_member2["node_name"])
	my_node.level_stats(party_member2["level"])

func ui_change_health(value):
	GlobalDjinnTracker.change_health(party_member2, value)
	player_panel[0].change_health(2)

func ui_change_mana(value):
	GlobalDjinnTracker.change_mana(party_member2, value)
	player_panel[0].change_mana(2)

func ui_change_stamina(value):
	GlobalDjinnTracker.change_stamina(party_member2, value)
	player_panel[0].change_stamina(2)

func charge_ultimate(value):
	ultimate_bar[0].value += value

