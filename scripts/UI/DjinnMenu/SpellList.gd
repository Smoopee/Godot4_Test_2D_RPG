extends ItemList


func _ready():
	for i in GlobalObtainables.spell_list_dictionary:
		add_item(i)

