extends Node2D

@onready var side_scene_layer = $SideSceneLayer

func _ready():
	pass

func show_side_scene(side_scene: Node) -> void:
	$SideSceneLayer.add_child(side_scene)
	get_tree().paused = true


func _on_side_scene_layer_child_exiting_tree(node):
	get_tree().paused = false
	print("We are back")

