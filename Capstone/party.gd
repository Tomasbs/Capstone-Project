extends Node2D

var players: Array = []
var index: int = 0

signal enemy_attacking2

func _ready():
	players = get_children()
	for i in players.size():
		players[i].position = Vector2(200, 325)
		


func _on_enemy_group_attacking():
	$".".players[0].current_states = $".".players[0].party_states.WALK_ATTACK


func _on_player_enemy_attacking():
	emit_signal("enemy_attacking2")
