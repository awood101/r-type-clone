extends Area2D

var spawner_pattern
var spawner_num_cycles
var spawner = load("res://BULLET_SPAWNER.tscn")
var vector = Vector2(0, 1)
var identifier = "ENEMY"
var has_spawner
var enemy_spawner_node
var boss
var hitpoints
var done_firing

signal death
signal escaped

func _ready():
	#connect signals
	enemy_spawner_node = get_parent()
	self.connect("death", enemy_spawner_node, "_on_ENEMY_death")
	self.connect("escaped", enemy_spawner_node, "_on_ENEMY_escaped")
	done_firing = false
	if(spawner_pattern == "boss"):
		hitpoints = 500
	else:
		hitpoints = 10

func _on_ENEMY_area_entered(area):
	#detects if player has shot enemy
	if(area.identifier == "PLAYER_BULLET"):
		hitpoints -= 1
		area.queue_free()
		if(hitpoints < 1):
			emit_signal("death", spawner_pattern)
			queue_free()

func _on_done_firing():
	done_firing = true

func set_position(var pos):
	self.position = pos

#initialize pattern and cycle values
func init(var pattern, var num_cycles):
	has_spawner = false
	spawner_pattern = pattern
	spawner_num_cycles = num_cycles
	if(pattern == "boss"):
		self.position.x = 200
		$ENEMY_SPRITE.texture = load("res://8.png")
	

func _process(delta):
	#move down, fire, and once finished escape
	if(self.position.y < 70):
		move_local_y(4)
	if(done_firing == false):
		if(spawner_pattern == "spiral"):
			if(self.position.y > 60):
				var a = spawner.instance()
				add_child(a)
				a.init(spawner_pattern, spawner_num_cycles)
				has_spawner = true
		elif(self.position.y > 40):
			if(has_spawner == false):
				var a = spawner.instance()
				add_child(a)
				a.init(spawner_pattern, spawner_num_cycles)
				has_spawner = true
	if(done_firing == true):
		if(spawner_pattern != "boss"):
			move_local_y(-4)
		if(global_position.y < 0):
			emit_signal("escaped", spawner_pattern)
			queue_free()
