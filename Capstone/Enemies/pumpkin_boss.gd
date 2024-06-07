extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum enemies_states {IDLE, HURT, DEAD}
var current_states = enemies_states.IDLE

var attacking = false
var attack_type : int = -1

@export var MAX_HEALTH: float = 7

@onready var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()

func _process(delta):
	match current_states:
		enemies_states.IDLE:
			idle()
		enemies_states.HURT:
			hurt()
	if attacking == true:
		attack_type = randi() % 2
			
			

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func focus():
	_focus.show()
 
func unfocus():
	_focus.hide()
	
func take_damage(value):
	health -= value
	current_states = enemies_states.HURT
	
func idle():
	anim_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func hurt():
	anim_tree.set("parameters/Hurt/blend_position", Vector2(0, 0))
	anim_state.travel("Hurt")

func on_states_reset():
	current_states = enemies_states.IDLE
