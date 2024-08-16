extends Control

@onready var button = $Button

var save_file_path = "user://save/"
var save_file_name = "DjinnParty.tres"
var fn1 = "TempestDjinn.tres"
var fn2 = "MercuryDjinn.tres"
var fn3 = "PlutoDjinn.tres"

var djinn_scene = preload("res://resources/tb_resources/Player/lightning_djinn.tres")
var djinn_parent_scene = preload("res://scenes/TBScenes/Player/djinn_parent_scene.tscn")

var djinn_party = DjinnData.new()

var djinn1
var djinn2
var djinn3

var party = []

func _ready():
	pass


func _on_button_toggled(toggled_on):
	if toggled_on: print("attack increased by 10")


func _on_button_2_pressed():
	verify_save_directory(save_file_path)
	save_djinn_data(djinn_party)
	Global.current_party = djinn_party.party

func save_djinn_data(data):
	ResourceSaver.save(data, save_file_path + save_file_name)

#func load_djinn_data():
	#if ResourceLoader.exists(save_file_path + save_file_name):
		#var djinn = ResourceLoader.load(save_file_path + save_file_name)
		#if djinn is Djinn:
			#print("y")
			#return djinn
		#print("y")
	#print("n")
	#return null

func _on_button_3_pressed():
	load_djinn_data()

func load_djinn_data():
	djinn1 = ResourceLoader.load(save_file_path + fn1)
	djinn2 = ResourceLoader.load(save_file_path + fn2)
	djinn3 = ResourceLoader.load(save_file_path + fn3)

func _on_button_pressed():
	party = [djinn1, djinn2, djinn3]
	djinn_party.party = party
	
	

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
