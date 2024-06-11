extends Node2D

func _ready():
	$AudioStreamPlayer.play()

func _process(delta):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://Level/level.tscn")
