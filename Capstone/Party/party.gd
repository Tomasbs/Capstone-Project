extends Node2D

var players: Array = []
var index: int = 0

var arrow_movement = false
var attack_type = 0

signal enemy_attacking2
signal enemy_arrow_attacking

var enemies_dead = false

func _ready():
	players = get_children()
	for i in players.size():
		players[i].position = Vector2(200, 325)
		
func _process(delta):
	if arrow_movement == true:
		if 	$Player/Arrow.position.x <= 120:
			$Player/Arrow.position.x += 150 * get_physics_process_delta_time()
		elif 	$Player/Arrow.position.x > 120:
			$Player.player_target[0].take_damage(1)
			$"../Enemy_Group/Pumpkin".current_states = $"../Enemy_Group/Pumpkin".enemies_states.HURT
			$Player/Arrow.position.x = position.x
			$Player/Arrow.position.y = 10000
			arrow_movement = false
			emit_signal("enemy_arrow_attacking")
			


func _on_enemy_group_attacking():
	if attack_type == 0 or attack_type == 1:
		$".".players[0].current_states = $".".players[0].party_states.WALK_ATTACK
	if attack_type == 2:
		$".".players[0].current_states = $".".players[0].party_states.BOW_ATTACK


func _on_player_enemy_attacking():
	emit_signal("enemy_attacking2")


func _on_enemy_group_enemies_defeated():
	enemies_dead = true


func _on_player_arrow_moving():
	arrow_movement = true
