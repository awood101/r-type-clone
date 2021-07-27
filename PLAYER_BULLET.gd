extends Area2D

var speed = 400
var identifier = "PLAYER_BULLET"

func _physics_process(delta):
	position.y -= speed * delta
	if(global_position.y < 0):
		queue_free()

