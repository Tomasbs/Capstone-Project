extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

var enemies_attacking = 0

signal next_player
signal attacking
@onready var choice = $"../CanvasLayer/Choice"

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(900, 335)
		
	show_choice()
		
func _process(delta):
	if not choice.visible:
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
			if len($".."/Party/Player.player_target) == 0:
				$".."/Party/Player.player_target.push_back(enemies[index])
			else:
				$".."/Party/Player.player_target[0] = enemies[index]
			emit_signal("next_player")
			
		if action_queue.size() == enemies.size() and not is_battling:
			is_battling = true
			emit_signal("attacking")
			_action(action_queue)
		
func _action(stack):
	action_queue.clear()
	is_battling = false
	for i in enemies:
		i.unfocus()
	show_choice()
				
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
	_start_choosing()


func _on_party_enemy_attacking_2():
	$".".enemies[enemies_attacking].attacking = true
	

		
