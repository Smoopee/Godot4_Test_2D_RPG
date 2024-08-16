extends Resource

class_name DjinnParty

var loadout: String = "loadout 1"

@export var party: Array 

func change_loadout(text):
	loadout = text
