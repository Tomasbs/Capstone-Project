extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum enemies_states {IDLE, HURT, DEAD}
var current_states = enemies_states.IDLE


@export var MAX_HEALTH: float = 7

var limit_health : int = 0
var cooldown_idle: int = 0

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		
		
func idle():
	anim_tree.set("parameters/Idle/blend_position", Vector2(-1, 0))
	anim_state.travel("Idle")	
	
func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100

func _process(delta):
	match current_states:
		enemies_states.IDLE:
			idle()
		enemies_states.HURT:
			hurt()
		enemies_states.DEAD:
			death()
			
	if health <= 0:
		current_states = enemies_states.DEAD
			
func focus():
	_focus.show()
	
	
func unfocus():
	_focus.hide()
	
func take_damage(value):
	health -= value
	current_states = enemies_states.HURT
	
func hurt():
	anim_tree.set("parameters/Hurt/blend_position", Vector2(-1, 0))
	anim_state.travel("Hurt")
	
func death():
	anim_tree.set("parameters/Dead/blend_position", Vector2(-1, 0))
	anim_state.travel("Dead")
	
		
func on_states_reset():
	current_states = enemies_states.IDLE
	
func death_animation():
	$Dead.visible = true
	$AnimatedSprite2D.visible = false
	
	
	
