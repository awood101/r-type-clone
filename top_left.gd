extends PathFollow2D

func _process(delta):
	self.set_offset(self.get_offset() + 200 * delta)
