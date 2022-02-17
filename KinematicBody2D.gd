extends KinematicBody2D

var speed = 250
var player_bullet = preload("res://PLAYER_BULLET.tscn")
var player_sprite_reg = load("res://1.png")
var player_sprite_shield = load("res://1shield.png")
onready var player_shield_collision = get_node("PLAYER_SHIELD_COLLISION")
onready var cur_sprite = get_node("PLAYER_SPRITE")
onready var shield_cooldown_sprite_dark = load("res://1shield_cooldown.png")
var shot_delay = 0.1
var can_shoot = true
var can_shoot_timer = Timer.new()
var can_shield = true
var can_shield_timer = Timer.new()
var can_shield_timer_duration = 30
var shield_duration_timer = Timer.new()
var shield_duration = 1.5
var timer
var main_scene
var time_remaining_label

signal create_player_bullet(player_bullet, playerPosition)

func _ready():
	#create timer for rate of fire
	main_scene = get_parent()
	self.connect("create_player_bullet", main_scene, "_on_PLAYER_createPlayerBullet")
	can_shoot_timer.set_one_shot(true)
	can_shoot_timer.set_wait_time(shot_delay)
	can_shoot_timer.connect("timeout", self, "shoot_timeout_completed")
	can_shield_timer.set_one_shot(true)
	can_shield_timer.set_wait_time(can_shield_timer_duration)
	can_shield_timer.connect("timeout", self, "shield_timeout_completed")
	shield_duration_timer.set_one_shot(true)
	shield_duration_timer.set_wait_time(shield_duration)
	shield_duration_timer.connect("timeout", self, "shield_duration_completed")
	add_child(can_shoot_timer)
	add_child(can_shield_timer)
	add_child(shield_duration_timer)
	time_remaining_label = main_scene.get_node("Label")
#when cooldown for shooting is over
func shoot_timeout_completed():
	can_shoot = true

#when cooldown for shield is over
func shield_timeout_completed():
	can_shield = true
	main_scene.get_node("SHIELD_ICON").texture = player_sprite_shield
	
#when shield duration expires
func shield_duration_completed():
	player_shield_collision.set_deferred("disabled", true)
	cur_sprite.texture = player_sprite_reg
	main_scene.get_node("SHIELD_ICON").texture = shield_cooldown_sprite_dark
	can_shield_timer.start()
			
#on enemy collision
func hit(body):
	if(body.identifier == "ENEMY_BULLET"):
		if(player_shield_collision.disabled == true):
			print(player_shield_collision.disabled)
			self.queue_free()	
		else:
			body.queue_free()

func update_label_time():
	if(can_shield_timer.time_left != 0):
		time_remaining_label.set_text(str("%0.1f" % can_shield_timer.time_left))
	else:
		time_remaining_label.set_text("%0.1f" % 30.0)

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
			can_shoot_timer.start()
			
	if Input.is_action_pressed("SHIELD"):
		if(can_shield == true):
			player_shield_collision.set_deferred("disabled", false)
			cur_sprite.texture = player_sprite_shield
			can_shield = false
			shield_duration_timer.start()
			
	update_label_time()
	#prevents vector addition speed increase
	vector = vector.normalized()
	move_and_collide(vector * speed * delta)
