extends Panel

var djinn_scene = load("res://scenes/TBScenes/Player/fire_djinn.tscn")
var skill_one_scene = load("res://scenes/TBScenes/SkillsAndAttacks/fireball_tb.tscn")
var skill_two_scene = load("res://scenes/TBScenes/SkillsAndAttacks/hex.tscn")

var player_panel
var ultimate_bar

func _ready():
	var djinn = djinn_scene.instantiate()
	add_child(djinn)
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")
	var my_node = get_node("FireDjinn")
	Global.change_max_player2_health(my_node.stats.max_health)
	Global.change_max_player2_mana(my_node.stats.max_mana)
	Global.change_max_player2_stamina(my_node.stats.max_stamina)

func ui_change_health(value):
	Global.change_health_player2(value)
	player_panel[0].change_health(2)

func ui_change_mana(value):
	Global.change_mana_player2(value)
	player_panel[0].change_mana(2)

func ui_change_stamina(value):
	Global.change_stamina_player2(value)
	player_panel[0].change_stamina(2)

func charge_ultimate(value):
	ultimate_bar[0].value += value

