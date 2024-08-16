extends Control

var save_file_path = "user://save/"
var save_file_name = "DjinnParty.tres"

@onready var party_members = $PartyMembers

var djinnData
var current_party

func _ready():
	pass

func _on_tree_entered():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	current_party = Global.current_party
	print("Current party is" + str(current_party))
	
func tree_is_leaving():
	await get_tree().create_timer(1).timeout
	queue_free()

func load_djinn_data():
	djinnData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	print("load")

