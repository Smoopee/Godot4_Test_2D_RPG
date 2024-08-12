extends HBoxContainer

@onready var skill_1_button = $Skill1Button
@onready var skill_2_button = $Skill2Button


func _ready():
	skill_1_button.text = GlobalDjinnTracker.djinn1_dicitionary["skill_one"]
	skill_2_button.text = GlobalDjinnTracker.djinn1_dicitionary["skill_two"]
