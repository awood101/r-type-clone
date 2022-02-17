extends Area2D

var speed = 400
var identifier = "PLAYER_BULLET"

func hit(body):
	pass

func _physics_process(delta):
	position.y -= speed * delta
	if(global_position.y < 0):
		queue_free()

