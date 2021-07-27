extends VisibilityNotifier2D

signal off_screen

func _process(delta):
	if(is_on_screen() == false):
		emit_signal("off_screen")
