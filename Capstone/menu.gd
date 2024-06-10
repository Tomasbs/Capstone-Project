extends Node2D

@onready var choice = $CanvasLayer/Choice
@onready var credits = $Credits


# Called when the node enters the scene tree for the first time.
func _ready():
	choice.find_child("Play").grab_focus()
	
func _process(delta):
	if credits.visible == true:
		if Input.is_action_just_pressed("enter"):
			choice.visible = true
			credits.visible = false
			choice.find_child("Play").grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Level/level.tscn")
	
func _on_credits_pressed():
	choice.visible = false
	credits.visible = true
	

func _on_exit_pressed():
	get_tree().quit()
