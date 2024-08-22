extends Panel

class_name DjinnParent

var turn_sprite_scene = load("res://scenes/TBScenes/TBBattleScene/turn_sprite_template.tscn")


var level:int = 1
var experience:int = 0

#DECLARES AND SETS STATES-------------------------------------------------------c
enum State{
	DEAD,
	ALIVE,
}

var current_state: int = -1: set = set_state

func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state

#Generic Stats------------------------------------------------------------------
var is_sprinting: bool = false
var is_dodging: bool = false

var stats: Djinn = null 

#SKILL ONE SETUP----------------------------------------------------------------
var skill_one_spellname: String
var skill_one_targeting: String
var skill_one_multi_damage: int
var skill_one_single_damage: int
var skill_one_mana_cost: int
var skill_one

#SKILL TWO SETUP----------------------------------------------------------------
var skill_two_spellname: String
var skill_two_targeting: String
var skill_two_multi_damage: int
var skill_two_single_damage: int
var skill_two_mana_cost: int
var skill_two


#DEFAULT ATTACK SETUP-----------------------------------------------------------
var default_attack_name: String
var default_attack_targeting: String 
var default_attack

#BATTLE ARENA VARIABLES---------------------------------------------------------
var player_panel
var player_position
var ultimate_bar

func _ready():
	set_state(State.ALIVE)
	
	player_panel = get_tree().get_nodes_in_group("player_panel")
	ultimate_bar = get_tree().get_nodes_in_group("ultimate")


func set_stats(player_stats) -> void:
	stats = player_stats

func get_speed():
	return stats.speed

func change_health(value):
	stats.health += value
	if stats.health <= 0:
		stats.health = 0
		set_state(State.DEAD)
		print("Your character DIED!")
	player_panel[0].change_health()

func change_mana(value):
	stats.mana += value
	if stats.mana <= 0:
		stats.mana = 0
	print("tb_djinn_parent: Player panel is " + str(player_panel))
	player_panel[0].change_mana()

func change_stamina(value):
	stats.stamina += value
	if stats.stamina <= 0:
		stats.stamina = 0
	player_panel[0].change_stamina()


func charge_ultimate(value):
	ultimate_bar[0].value += value
	print("The ultimate bar's value is " + str(ultimate_bar[0].value))
	
func change_speed(value):
	stats.speed += value
	var game_state = get_tree().get_nodes_in_group("game_state_tracker")
	game_state[0].character_speed_change(self)


func instantiate_default_attack():
	var default_attack_scene = load(stats.default_attack_path)
	default_attack = default_attack_scene.instantiate()
	print("djinn_parent_scene: default attack is = " + str(default_attack))
	add_child(default_attack)
	default_attack_targeting = default_attack.target_selection
	print("djinn_parent_scene: default attack is = " + str(default_attack.target_selection))
	skill_one_spellname = default_attack.default_attack_name
	print("djinn_parent_scene: default attack is = " + str(default_attack.default_attack_name))
	

func instantiate_skill_one():
	var skill_one_scene = load(stats.skill_one_path)
	skill_one = skill_one_scene.instantiate()
	add_child(skill_one)
	skill_one_targeting = skill_one.target_selection
	skill_one_spellname = skill_one.spell_name
	skill_one_multi_damage = skill_one.multi_attack_power * stats.attack
	skill_one_single_damage = skill_one.power * stats.attack
	skill_one_mana_cost = skill_one.mana_cost

func instantiate_skill_two():
	var skill_two_scene = load(stats.skill_two_path)
	skill_two = skill_two_scene.instantiate()
	add_child(skill_two)
	skill_two_targeting = skill_two.target_selection
	skill_two_spellname = skill_two.spell_name
	skill_two_multi_damage = skill_two.multi_attack_power * stats.attack
	skill_two_single_damage = skill_two.power * stats.attack
	skill_two_mana_cost = skill_two.mana_cost

func instantiate_turn_sprite(target, zSetter = 1):
	var turn_sprite = turn_sprite_scene.instantiate()
	target.add_child(turn_sprite)
	turn_sprite.get_child(0).texture = stats.turn_sprite
	turn_sprite.z_index = zSetter

func cast_sprint():
	change_stamina(-50)
	change_speed(50)
	is_sprinting = true

func stop_sprint():
	change_speed(-50)
	is_sprinting = false

func cast_dodge():
	change_stamina(-50)
	is_dodging = true

func stop_dodge():
	is_dodging = false

func cast_skill_one(caster = self, target = null):
	print("skill one is " + str(skill_one))
	skill_one.cast_skill(caster, target)
	charge_ultimate(stats.ultimate_charge)
	print("skill one has been cast and ultimate is charged by: " + str(stats.ultimate_charge))

func cast_skill_two(caster = self, target = null):
	skill_two.cast_skill(caster, target)
	charge_ultimate(stats.ultimate_charge)

func cast_default_attack(caster = self, target = null):
	default_attack.default_attack_function(caster, target)
	charge_ultimate(stats.ultimate_charge)

func buff_incrementer(body):
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("buff"):
		if body.is_ancestor_of(node): 
			children_in_group.push_front(node)
			
	for i in children_in_group:
		i.turn_expiration(body)

