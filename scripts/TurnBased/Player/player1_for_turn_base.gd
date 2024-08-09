extends Panel

var djinn_scene = load("res://scenes/TBScenes/Player/lightning_djinn.tscn")
var skill_one_scene = load("res://scenes/TBScenes/SkillsAndAttacks/lightning_strike.tscn")
var skill_two_scene = load("res://scenes/TBScenes/SkillsAndAttacks/momentum.tscn")

var player_panel
var ultimate_bar

func _ready():
	var djinn = djinn_scene.instantiate()
	add_child(djinn)
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")
	var my_node = get_node("LightningDjinn")
	Global.change_max_player1_health(my_node.stats.max_health)
	Global.change_max_player1_mana(my_node.stats.max_mana)
	Global.change_max_player1_stamina(my_node.stats.max_stamina)


func ui_change_health(value):
	Global.change_health_player1(value)
	player_panel[0].change_health(1)

func ui_change_mana(value):
	Global.change_mana_player1(value)
	player_panel[0].change_mana(1)

func ui_change_stamina(value):
	Global.change_stamina_player1(value)
	player_panel[0].change_stamina(1)

func charge_ultimate(value):
	ultimate_bar[0].value += value
	print("The ultimate bar's value is " + str(ultimate_bar[0].value))
