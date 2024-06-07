extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var animation_player = $AnimationPlayer

@export var MAX_HEALTH: float = 7

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func focus():
	_focus.show()
 
func unfocus():
	_focus.hide()
