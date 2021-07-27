extends Area2D

var speed = 100
var velocity = Vector2()
var identifier = "ENEMY_BULLET"
var bullet3 = "res://bullet3.png"
var bullet5 = "res://bullet5.png"
var bullet6 = "res://bullet6.png"
var bullet7 = "res://bullet7.png"
var bullet_array = [bullet3, bullet5, bullet6, bullet7]

func start(_position, _direction, _texture):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	$Sprite.texture = load(bullet_array[_texture])


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_ENEMY_BULLET_body_entered(body):
	print("hit")
	body.queue_free()

func _process(delta):
	 position += velocity * delta
