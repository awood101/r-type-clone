extends Area2D


var SPEED = 400

func _ready():
	connect('body_entered', self, '_on_body_entered')

func _process(delta):
   var motion = Vector2(cos(self.rotation), sin(self.rotation)) * SPEED
   position += motion * delta

func _on_body_entered(body):
   print('bullet just hit: ', body.name)
   queue_free()
