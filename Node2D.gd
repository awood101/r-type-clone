extends Node2D
var enemy_bullet = preload("res://ENEMY_BULLET.tscn")
var player
var direction
var timer
var can_shoot = true
#holds key:value pairs for each named attack
# "attack name": {[rotation per shot, number of shots per full attack cycle, x vector, y vector, secondary rotation,  time between shots, return to original position before firing)}
var pattern_dict = {"spiral": [PI/10, 20, 1, 0, PI/50, 0.1, 0], "reverse_spiral": [-PI/10, 20, 1, 0, -PI/50, 0.2, 0], "shotgun":[PI/20, 3, 2, 0, 0, 0.5, 1], "single":[0, 1, 0, 1, 0, 0.5, 0], "test":[rand_range(-PI/100, PI/100), 1, 0, 1, 0, 0.1, 0], "boss":[rand_range(0, PI), rand_range(1, 5), 0, 1, 0, 0.2, 0]}
var cur_pattern_array = []
var cur_pattern
var pattern_rotation
var pattern_num_shots
var pattern_x_vector
var pattern_y_vector
var pattern_secondary_rotation
var pattern_cycles
var pattern_shots_before_rotate
var pattern_time_between_shots
var pattern_rotate_to_original
var original_rotation
var main_scene
var parent
var sent_signal
var bullet_texture
signal spawn_bullet()
signal done_firing()


func _ready():
	main_scene = get_parent().get_parent().get_parent()
	parent = get_parent()
	player = get_tree().get_nodes_in_group("PLAYER")[0]
	sent_signal = false
	self.connect("spawn_bullet", main_scene, "_on_BULLET_SPAWNER_spawn_bullet")
	self.connect("done_firing", parent, "_on_done_firing")
	position = get_parent().global_position
	
func create_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(pattern_time_between_shots)
	timer.connect("timeout", self, "timeoutCompleted")
	add_child(timer)
	timer.start()
		
#assigns values to appropriate variables based on the desired pattern to be fired
func init(pattern, var numCycles):
	randomize()
	bullet_texture = randi()%3 + 1
	cur_pattern = pattern
	cur_pattern_array = pattern_dict.get(pattern)
	pattern_rotation = cur_pattern_array[0]
	pattern_num_shots = cur_pattern_array[1]
	pattern_x_vector = cur_pattern_array[2]
	pattern_y_vector = cur_pattern_array[3]
	pattern_secondary_rotation = cur_pattern_array[4]
	#pattern_shots_before_rotate = cur_pattern_array[5]
	pattern_cycles = numCycles
	pattern_time_between_shots = cur_pattern_array[5]
	pattern_rotate_to_original = cur_pattern_array[6]
	original_rotation = global_rotation
	create_timer()
	


func timeoutCompleted():
	can_shoot = true

#fires the given pattern
func fire():
	can_shoot = false
	for i in range(0, pattern_num_shots):
		rotate(pattern_rotation)
		direction = Vector2(pattern_x_vector, pattern_y_vector).rotated(global_rotation)
		# super janky but it sort of works!
		if(cur_pattern == "shotgun"):
			direction = player.position - position
			direction = direction.normalized()
			direction = direction * 2
			emit_signal("spawn_bullet", enemy_bullet, direction, position, bullet_texture)
			direction = player.position - position + position/2
			direction = direction.normalized()
			direction = direction * 2
			emit_signal("spawn_bullet", enemy_bullet, direction, position, bullet_texture)
			direction = player.position - position - position/2
			direction = direction.normalized()
			direction = direction * 2
			emit_signal("spawn_bullet", enemy_bullet, direction, position, bullet_texture)

		#for j in range(0, pattern_shots_before_rotate):
		else:
			emit_signal("spawn_bullet", enemy_bullet, direction, position, bullet_texture)
		if(cur_pattern != "spiral"):
			if(cur_pattern != "reverse_spiral"):
				if(pattern_secondary_rotation != 0):
					rotate(pattern_secondary_rotation)
				if(pattern_rotate_to_original == 1):
					rotation = original_rotation
	if(pattern_secondary_rotation != 0):
		rotate(pattern_secondary_rotation)
	if(pattern_rotate_to_original == 1):
		rotation = original_rotation
		
var fire_cooldown = true
func _on_Timer_timeout():
	fire_cooldown = true

#check each frame to see if there is another cycle to the selected pattern
func _process(delta):
	#update position to be in line with enemy that owns this spawner
	position = get_parent().global_position
	if(pattern_cycles > 0):
		if(can_shoot == true):
			pattern_cycles -= 1
			#restart timer to delay time between next set of shots
			timer.start()
			fire()
	#once no more shots are to be fired, get rid of spawner
	
	#TESTING
	if(pattern_cycles == 0):
		if(cur_pattern == "boss"):
			#if(fire_cooldown == true):
				fire_cooldown = false
				init("boss", 5);
				randomize()
				pattern_rotation = rand_range(PI/2, 2*PI)
				pattern_num_shots = rand_range(10, 21)
				pattern_y_vector = rand_range(1, 3)
				$Timer.wait_time = 1
				$Timer.connect("timeout", self, "_on_Timer_timeout")
				$Timer.start()
		if(sent_signal == false):
			emit_signal("done_firing")
			sent_signal = true
	
		
		#if(temp == true):
			#self.init("reverse_spiral", 4)
			#temp = false
		#elif(temp == false):
			#self.init("spiral", 4)
			#temp = true
			#queue_free()
