extends Node2D

var player = load("res://PLAYER.tscn")
var enemy = load("res://ENEMY.tscn")
var enemy_spawner = load("res://ENEMY_SPAWNER.tscn")
var player_instance
var enemy_list
var enemy_count
var enemy_cycles
var enemy_instance
var testposx
var bullet_texture
var counter


func _ready():
	testposx = 30
	counter = 0
	player_instance = player.instance()
	var enemy_spawner_instance = enemy_spawner.instance()
	add_child(player_instance)
	add_child(enemy_spawner_instance)

func _on_PLAYER_createPlayerBullet(playerBullet, playerPosition):
	var a = playerBullet.instance()
	add_child(a)
	a.position.y = playerPosition.y - 5
	a.position.x = playerPosition.x
	var b = playerBullet.instance()
	add_child(b)
	b.position.y = playerPosition.y - 5
	b.position.x = playerPosition.x - 15
	var c = playerBullet.instance()
	add_child(c)
	c.position.y = playerPosition.y - 5
	c.position.x = playerPosition.x + 15

func _on_BULLET_SPAWNER_spawn_bullet(enemy_bullet, direction, location, bullet_texture):
	var a = enemy_bullet.instance()
	add_child(a)
	a.start(location, direction, bullet_texture)
	
func _process(_delta):
	if Input.is_action_pressed("RESET"):
		get_tree().reload_current_scene()
	
