extends KinematicBody2D

var speed = 250
var player_bullet = preload("res://PLAYER_BULLET.tscn")
var shot_delay = 0.1
var can_shoot = true
var timer
var main_scene

signal create_player_bullet(player_bullet, playerPosition)

func _ready():
	#create timer for rate of fire
	main_scene = get_parent()
	self.connect("create_player_bullet", main_scene, "_on_PLAYER_createPlayerBullet")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(shot_delay)
	timer.connect("timeout", self, "timeout_completed")
	add_child(timer)

func timeout_completed():
	can_shoot = true

func _on_PLAYER_area_entered(area):
	if(area.identifier == "ENEMY_BULLET"):
		get_tree().quit()
		area.queue_free()

func _physics_process(delta):
	#player movement
	var vector = Vector2()
	if Input.is_action_pressed("DOWN"):
		if(position.y >= OS.get_window_size().y):
			vector.y = 0
		else:
			vector.y += 1
	if Input.is_action_pressed("UP"):
		if(position.y <= 0):
			vector.y = 0
		else:
			vector.y -= 1
	if Input.is_action_pressed("RIGHT"):
		if(position.x >= OS.get_window_size().x):
			vector.x = 0
		else:
			vector.x += 1
	if Input.is_action_pressed("LEFT"):
		if(position.x <= 0):
			vector.x = 0
		else:
			vector.x -= 1
	#fire bullet [goes to MAIN node]
	if Input.is_action_pressed("SHOOT"):
		if(can_shoot == true):
			emit_signal("create_player_bullet", player_bullet, global_position)
			can_shoot = false
			timer.start()

	#prevents vector addition speed increase
	vector = vector.normalized()
	move_and_collide(vector * speed * delta)
