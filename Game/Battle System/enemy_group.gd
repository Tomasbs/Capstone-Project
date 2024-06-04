extends Node2D

var enemies : Array = []
var action_queue: Array = []
var is_battling: bool = false
var index : int = 0

signal next_player
signal attacking
@onready var choice = $"../CanvasLayer/Choice1"

func _ready():
	enemies = get_children()
	enemies[0].position = Vector2(1000, 225)
	enemies[1].position = Vector2(800,450)
	
	show_choice()
	
func _process(_delta):
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
			$".."/Party.players_target.push_back(enemies[index])
			emit_signal("next_player")
		
	if action_queue.size() == enemies.size() and not is_battling:
		is_battling = true
		emit_signal("attacking")
		_action(action_queue)
		
		
func _action(stack):
	action_queue.clear()
	is_battling = false
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


func _on_button_pressed():
	choice.hide()
	_start_choosing()
	
