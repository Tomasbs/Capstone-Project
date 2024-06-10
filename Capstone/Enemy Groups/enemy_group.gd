extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

var enemies_attacking = 0
var overall_hp = 7
var seed_movement = false

var picking = false

var attack_percentage = 0

signal next_player
signal attacking
signal enemies_defeated
@onready var choice = $"../CanvasLayer/Choice"
@onready var choice_2 = $"../CanvasLayer/Choice2"

func _ready():
	$"../CanvasLayer/Choice2".visible = false
	choice.find_child("Attack").grab_focus()
	for i in len(enemies):
		overall_hp += enemies[i].hp
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(900, 335)
		
func _process(delta):
	if overall_hp < 0:
		emit_signal("enemies_defeated")
	
	if not choice.visible and not choice_2.visible:
		if Input.is_action_just_pressed("up"):
			if index > 0:
				index -= 1
				switch_focus(index, index+1)
		if Input.is_action_just_pressed("down"):
			if index < enemies.size() - 1:
				index += 1
				switch_focus(index, index-1)
		if Input.is_action_just_pressed("enter"):
			action_queue.push_back(index)
			if len($"../Party/Player".player_target) == 0:
				$"../Party/Player".player_target.push_back(enemies[index])
			else:
				$"../Party/Player".player_target[0] = enemies[index]
			emit_signal("next_player")
			
		if action_queue.size() == enemies.size() and not is_battling:
			is_battling = true
			emit_signal("attacking")
			_action(action_queue)
			
	if seed_movement == true:
		if 	$Pumpkin/Seed.position.x >= -110:
			$Pumpkin/Seed.position.x -= 150 * get_physics_process_delta_time()
		elif 	$Pumpkin/Seed.position.x < -110:
			$"../Party/Player".current_states = $"../Party/Player".party_states.HURT
			$Pumpkin/Seed.position.x = position.x
			$Pumpkin/Seed.position.y = 10000
			seed_movement = false
			if picking == true:
				show_choice()
				picking = false
	
		
		
func _action(stack):
	action_queue.clear()
	is_battling = false
	for i in enemies:
		i.unfocus()
				
func switch_focus(x, y):
	enemies[x].focus()
	enemies[y].unfocus()
		
func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()
	
func _reset_focus():
	index = 0
	for enemy in enemies:
		enemy.unfocus()

func _start_choosing():
	_reset_focus()
	enemies[0].focus()		


func _on_attack_pressed():
	choice.hide()
	choice_2.show()
	choice_2.find_child("Light_Attack").grab_focus()
	

func _on_party_enemy_attacking_2():
	$".".enemies[enemies_attacking].attacking = true
	$".".enemies[enemies_attacking].randomizer = true
	
func _on_pumpkin_attack_hit_connection():
	$"../Party/Player".current_states = $"../Party/Player".party_states.HURT

func _on_pumpkin_seed_moving():
	seed_movement = true


func _on_light_attack_pressed():
	choice2_hide()
	attack_percentage = randi() % 9
	$".."/Party.attack_type = 0
	_start_choosing()

func _on_magic_attack_pressed():
	#choice_2.hide()
	#$"../CanvasLayer/Choice2".visible = false
	choice2_hide()
	attack_percentage = randi() % 9
	$".."/Party.attack_type = 3
	_start_choosing()


func _on_bow_attack_pressed():
	choice2_hide()
	attack_percentage = randi() % 9
	$".."/Party.attack_type = 2
	_start_choosing()


func _on_heavy_attack_pressed():
	choice2_hide()
	attack_percentage = randi() % 9
	$".."/Party.attack_type = 1
	_start_choosing()

func _on_party_enemy_arrow_attacking():
	$".".enemies[enemies_attacking].attacking = true
	$".".enemies[enemies_attacking].randomizer = true
	
func choice2_hide():
	choice_2.visible = false
	#$"../CanvasLayer/Choice2".visible = false
	

