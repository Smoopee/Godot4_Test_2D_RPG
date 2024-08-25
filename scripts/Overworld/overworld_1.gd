extends Node2D

@onready var side_scene_layer = $SideSceneLayer
@onready var djinn_menu = $CanvasLayer/DjinnMenu


var save_file_path = "user://save/"
var save_file_name = "DjinnParty.tres"

var djinn_party = DjinnData.new()

var party

func _ready():
	party = Global.current_party

func show_side_scene(side_scene: Node) -> void:
	$SideSceneLayer.add_child(side_scene)
	get_tree().paused = true
	djinn_menu.visible = false

func _on_side_scene_layer_child_exiting_tree(node):
	get_tree().paused = false
	djinn_menu.visible = true
	party = Global.current_party
	
	print("We are back")

func load_djinn_data():
	return ResourceLoader.load(save_file_path + save_file_name)

func save_djinn_data():
	for i in party:
		ResourceSaver.save(i, save_file_path + i.save_file_name)
		print("save")
	ResourceSaver.save(djinn_party, save_file_path + save_file_name)
	

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func _on_save_pressed():
	verify_save_directory(save_file_path + save_file_name)
	djinn_party.party = Global.current_party
	save_djinn_data()
