extends VBoxContainer


@onready var djinn_menu = $".."
@onready var djinn_1 = $Djinn1
@onready var djinn_2 = $Djinn2
@onready var djinn_3 = $Djinn3
@onready var button_1 = $Button1
@onready var button_2 = $Button2
@onready var button_3 = $Button3
@onready var label_1 = $Djinn1/Label1
@onready var label_2 = $Djinn2/Label2
@onready var label_3 = $Djinn3/Label3


var party = []


func _ready():
	party = djinn_menu.party
	
	
	djinn_1.texture = party[0]["texture"]
	button_1.text = party[0]["name"]
	label_1.text = "lvl " + str(party[0]["level"])
	djinn_2.texture = party[1]["texture"]
	button_2.text = party[1]["name"]
	label_2.text = "lvl " + str(party[1]["level"])
	djinn_3.texture = party[2]["texture"]
	button_3.text = party[2]["name"]
	label_3.text = "lvl " + str(party[2]["level"])
