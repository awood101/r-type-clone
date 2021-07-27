extends "res://MAIN.gd"
export(NodePath) var parent_path


func _ready():
	var player_instance = player.instance()
	var enemy_instance = enemy.instance()
