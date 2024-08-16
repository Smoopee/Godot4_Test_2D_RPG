extends Node2D
class_name DamageNumber2D

@onready var label = $LabelContainer/Label
@onready var label_container = $LabelContainer
@onready var ap = $AnimationPlayer

func set_value_and_animate(value: String, start_pos: Vector2, height: float, spread: float) -> void:
	#global_position = start_pos + Vector2(15, -10)
	label.text = value
	ap.play("Rise and Hide")
	var tween = create_tween()
	var end_pos = Vector2(randf_range(-spread,spread), -height) + start_pos
	var tween_length = ap.get_animation("Rise and Hide").length
	print("combat_text: start_pos = " + str(start_pos))
	print("height is " + str(height))
	print("length is " + str(end_pos))

	tween.tween_property(label_container, "position", end_pos, tween_length).from(start_pos)
	
	
func remove() -> void:
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
