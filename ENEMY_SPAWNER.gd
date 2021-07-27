extends Node

var MAX_ENEMIES
var cur_enemies
var state
var enemies_killed
var MAX_SPIRAL
var cur_spiral
var enemy = preload("res://ENEMY.tscn")
var add_boss = true

#states "advance" the difficulty of the game with increasing kills
#state 2 is when the boss shows up
func _on_ENEMY_death(var type):
	cur_enemies -= 1
	enemies_killed += 1
	if(type == "spiral" or type == "reverse_spiral"):
		cur_spiral -= 1
	if(enemies_killed == 10):
		state = 1
		MAX_SPIRAL = 1
		MAX_ENEMIES = 3
	if(enemies_killed == 20):
		state = 2
		MAX_SPIRAL = 0
		MAX_ENEMIES = 1
		
func _on_ENEMY_escaped(var type):
	cur_enemies -= 1
	if(type == "spiral" or type == "reverse_spiral"):
		cur_spiral -= 1		

#get a random pattern out from a small range of options
func get_enemy_pattern():
	var enemy_list = ["single", "shotgun", "spiral", "reverse_spiral", "test"]
	if(state == 0):
		return enemy_list[rand_range(0, 2)]
	elif(state == 1):
		var choice = rand_range(1, 4)
		if(enemy_list[choice] == "spiral"):
			cur_spiral += 1
			if(cur_spiral >= MAX_SPIRAL):
				choice = 1
		return enemy_list[choice]
	elif(state == 2):
		return "boss"
	
func get_enemy_cycles():
	var enemy_cycles = [10, 20, 30]
	return enemy_cycles[rand_range(0, enemy_cycles.size())]

func _ready():
	#gets new seed for different spawns each game
	randomize()
	MAX_ENEMIES = 1
	cur_enemies = 0
	state = 2
	enemies_killed = 0
	cur_spiral = 0
	MAX_SPIRAL = 0
	$Timer.wait_time = rand_range(1, 3)
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()

func _on_Timer_timeout():
	#enemy spawning
		var enemy_instance = enemy.instance()
		enemy_instance.init(get_enemy_pattern(), 0)
		var pos = Vector2()
		if(get_enemy_pattern() != "boss"):
			#spawn enemies at a random spot along the top
			pos.x = rand_range(0 + 27, OS.get_window_size().x - 27)
		else:
			pos.x = OS.get_window_size().x / 2
		pos.y = 0 - 21
		enemy_instance.position = pos
		if(get_enemy_pattern() == "boss"):
			if(add_boss == true):
				add_child(enemy_instance)
				add_boss = false
				cur_enemies += 1
		else:
			if(cur_enemies < MAX_ENEMIES):
				if(get_enemy_pattern() != "spiral"):
					add_child(enemy_instance)
					cur_enemies += 1
					$Timer.wait_time = rand_range(1, 3)
					$Timer.start()
				elif(cur_spiral < MAX_SPIRAL):
					add_child(enemy_instance)
					cur_enemies += 1
					$Timer.wait_time = rand_range(1, 3)
					$Timer.start()
	 
