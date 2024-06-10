extends Node2D

var enemies_dead = false
var arrow_movement = false
var magic_movement = false
var players: Array = []
var index: int = 0
var attack_type

signal enemy_attacking2

func _ready():
	players = get_children()
	for i in players.size():
		players[i].position = Vector2(200, 325)
		
func _process(delta):
	if arrow_movement == true:
		if 	$Player/Arrow.position.x <= 105:
			$Player/Arrow.position.x += 150 * get_physics_process_delta_time()
		elif $Player/Arrow.position.x > 105:
			$"../Enemy_Group/Pumpkin".current_states = $"../Enemy_Group/Pumpkin".enemies_states.HURT
			$Player.player_target[0].take_damage((randi() % 2) + 1)
			$Player/Arrow.position.x = 200
			$Player/Arrow.position.y = 10000
			arrow_movement = false
			await get_tree().create_timer(1).timeout
			emit_signal("enemy_attacking2")
		
	if magic_movement == true:
		if 	$Player/Fire_Ball.position.x <= 105:
			$Player/Fire_Ball.position.x += 150 * get_physics_process_delta_time()
		elif $Player/Fire_Ball.position.x > 105:
			$"../Enemy_Group/Pumpkin".current_states = $"../Enemy_Group/Pumpkin".enemies_states.HURT
			$Player.player_target[0].take_damage((randi() % 2) + 3)
			$Player/Fire_Ball.position.x = 200
			$Player/Fire_Ball.position.y = 10000
			magic_movement = false
			await get_tree().create_timer(1).timeout
			emit_signal("enemy_attacking2")
		


func _on_enemy_group_attacking():
	if attack_type == 0 and $".."/Enemy_Group.attack_percentage < 8:
		$".".players[0].current_states = $".".players[0].party_states.WALK_ATTACK
		$".."/Enemy_Group.picking = true
	elif attack_type == 1 and $".."/Enemy_Group.attack_percentage < 6:
		$".".players[0].current_states = $".".players[0].party_states.WALK_ATTACK
		$".."/Enemy_Group.picking = true
	elif attack_type == 2 and $".."/Enemy_Group.attack_percentage < 7:
		$".".players[0].current_states = $".".players[0].party_states.BOW_ATTACK
		$".."/Enemy_Group.picking = true
	elif attack_type == 3 and $".."/Enemy_Group.attack_percentage < 5:
		$".".players[0].current_states = $".".players[0].party_states.MAGIC_ATTACK
		$".."/Enemy_Group.picking = true
	else:
		$".".players[0].current_states = $".".players[0].party_states.MISS
		$".."/Enemy_Group.picking = true

func _on_player_enemy_attacking():
	emit_signal("enemy_attacking2")


func _on_player_arrow_moving():
	arrow_movement = true
	
func _on_player_magic_moving():
	magic_movement = true
