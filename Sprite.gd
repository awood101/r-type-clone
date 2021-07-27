extends Sprite

var speed = 100

func _physics_process(delta):
	global_position.y -= speed * delta
