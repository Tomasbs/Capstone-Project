extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

signal next_player
@onready var choice = $"../CanvasLayer/Choice"

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(900, 185)
		
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
			emit_signal("next_player")
			
		if action_queue.size() == enemies.size() and not is_battling:
			is_battling = true
			emit_signal("attacking")
			_action(action_queue)
		
func _action(stack):
	for i in stack:
		enemies[i].take_damage(1)
		await get_tree().create_timer(1).timeout
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