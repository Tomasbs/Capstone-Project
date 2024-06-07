extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var player_target : Array = []

@export var MAX_HEALTH: float = 7

var home_x = 200	
var home_y = 350

signal atack_over
signal on_hit
signal enemy_attacking

var attacking = false
var going_back = false

var at_home_x = true
var at_home_y = true
var at_home = true

var at_target_x = false
var at_target_y = false
var at_target = false

enum party_states {IDLE, WALK_ATTACK, WALK_BACK, LIGHT_ATTACK}
var current_states = party_states.IDLE

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		
func _process(delta):
	print(at_target_y)
	match current_states:
		party_states.IDLE:
			idle()
		party_states.WALK_ATTACK:
			walk_attack()
		party_states.WALK_BACK:
			walk_back()
		party_states.LIGHT_ATTACK:
			light_attack()
			
	if attacking == true and at_target == false:
		if at_target_x == false:		
			$".".position.x +=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > player_target[0].position.y:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < player_target[0].position.y:
				$".".position.y += 150 * get_physics_process_delta_time()
		
	if player_target.size() > 0:
		if going_back == false:
			if $".".position.x >= player_target[0].position.x - 190:
				at_target_x = true
			if $".".position.y == player_target[0].position.y:
				at_target_y = true
			if at_target_x == true and at_target_y == true:
				at_target = true
				current_states = party_states.LIGHT_ATTACK 
			
	if going_back == true and at_home == false:
		if at_home_x == false:		
			$".".position.x -=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > home_y:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < home_y:
				$".".position.y += 150 * get_physics_process_delta_time()
	
	if attacking == false:
		if $".".position.x == home_x:
			at_home_x = true
		if $".".position.y == home_y:
			at_home_y = true
		if at_home_x == true and at_home_y == true:
			at_home = true
			current_states = party_states.IDLE
			if $".."/Enemy_Group/Pumpkin.health > 0:
				emit_signal("enemy_attacking")

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func focus():
	_focus.show()
 
func unfocus():
	_focus.hide()
	
func idle():
	anim_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func walk_attack():
	going_back = false
	at_home = false
	at_home_x = false
	at_home_y = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")
	attacking = true
	
func light_attack():
	anim_tree.set("parameters/Light_Attack/blend_position", Vector2(1, 0))
	anim_state.travel("Light_Attack")	
	
func _on_atack_over():
	current_states = party_states.WALK_BACK
	
func _on_on_hit():
	player_target[0].take_damage(1)
	
func walk_back():
	at_target = false
	at_target_x = false
	at_target_y = false
	attacking = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")
	going_back = true
