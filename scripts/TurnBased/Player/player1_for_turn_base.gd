extends Panel


var party_member1 =  GlobalDjinnTracker.current_party[0]
var skill_one_scene = party_member1["skill_one_scene"]
var skill_two_scene = party_member1["skill_two_scene"]

var player_panel
var ultimate_bar

func _ready():
	var djinn = party_member1["scene"]
	add_child(djinn.instantiate())
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")
	var my_node = get_node(party_member1["node_name"])
	my_node.level_stats(party_member1["level"])


func ui_change_health(value):
	GlobalDjinnTracker.change_health(party_member1, value)
	player_panel[0].change_health(1)

func ui_change_mana(value):
	GlobalDjinnTracker.change_mana(party_member1, value)
	player_panel[0].change_mana(1)

func ui_change_stamina(value):
	GlobalDjinnTracker.change_stamina(party_member1, value)
	player_panel[0].change_stamina(1)

func charge_ultimate(value):
	ultimate_bar[0].value += value
	print("The ultimate bar's value is " + str(ultimate_bar[0].value))
