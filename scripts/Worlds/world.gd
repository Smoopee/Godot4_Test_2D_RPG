extends Node2D

var loot_scene = load("res://scenes/Items/microchip.tscn")

func _ready():
	Global.player_health
	Global.player_mana

func spawn_loot(area):
	var loot = loot_scene.instantiate()
	add_child(loot)
	loot.position = area


func _on_inventory_gui_opened():
	get_tree().paused = true



func _on_inventory_gui_closed():
	get_tree().paused = false
