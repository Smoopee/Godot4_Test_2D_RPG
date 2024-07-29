extends Area2D

signal attack_hit_player
var damage = 0


func _ready():
	await get_tree().create_timer(1.2).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("gotcha")
		Global.change_health(damage)


func add_attack_damage(attack_power):
	damage = attack_power
