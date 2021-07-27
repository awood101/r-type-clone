extends ParallaxLayer
var speed

#works fine but makes me motion sick so it had to die

func _ready():
	speed = 2

func _process(delta):
	self.motion_offset.y += speed
