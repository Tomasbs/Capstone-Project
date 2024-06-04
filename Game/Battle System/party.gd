extends Node2D

var players : Array = []
var index: int = 0
@onready var players_target : Array = []
var players_attacking = 1

func _ready():
	players = get_children()
	players[0].position = Vector2(200, 140)
	players[1].position = Vector2(200, 380)
	
	players[0].focus()

func _process(delta):
	pass


func _on_enemy_group_next_player():
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index - 1)
	else: 
		index = 0
		switch_focus(index, players.size()-1)

func switch_focus(x, y):
	players[x].focus()
	players[y].unfocus()


func _on_enemy_group_attacking():
	$".".players[players_attacking-1].current_states = $".".players[players_attacking].party_states.WALK_ATTACK
	
func _on_player_attacking_after():
	$".".players[players_attacking-1].current_states = $".".players[players_attacking].party_states.WALK_ATTACK
