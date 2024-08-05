extends Node

var turn = 0

func turn_expiration(parent):
	turn += 1
	if turn >= 3:
		parent.attack += 10
		queue_free()
