extends Node

var turn = 0
var speed_buff: int


func turn_expiration(parent):
	print("the speed buff is: " + str(speed_buff))
	turn += 1
	if turn >= 3:
		parent.change_speed(-speed_buff)
		queue_free()
