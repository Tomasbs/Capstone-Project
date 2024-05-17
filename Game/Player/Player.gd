extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

signal atack_over
signal on_hit
signal attacking_after

var home_x = 200	
var home_y = 140

var attacking = false
var going_back = false

var at_home_x = true
var at_home_y = true
var at_home = true

var at_target_x = false
var at_target_y = false
var at_target = false

enum party_states {IDLE, WALK_ATTACK, WALK_BACK, ATTACK}
var current_states = party_states.IDLE

@export var MAX_HEALTH: float = 7

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		
func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func _ready():
	pass

func _process(delta):
	match current_states:
		party_states.IDLE:
			idle()
		party_states.WALK_ATTACK:
			walk_attack()
		party_states.WALK_BACK:
			walk_back()
		party_states.ATTACK:
			attack()
	if attacking == true and at_target == false:
		if at_target_x == false:		
			$".".position.x +=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > $"..".players_target[$"..".players_attacking].position.y:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < $"..".players_target[$"..".players_attacking].position.y:
				$".".position.y += 150 * get_physics_process_delta_time()
		
	if $"..".players_target.size() > 0:
		if going_back == false:
			if $".".position.x >= $"..".players_target[$"..".players_attacking].position.x - 150:
				at_target_x = true
			if $".".position.y == $"..".players_target[$"..".players_attacking].position.y - 20:
				at_target_y = true
			if at_target_x == true and at_target_y == true:
				at_target = true
				current_states = party_states.ATTACK 
			
	if going_back == true and at_home == false:
		if at_home_x == false:		
			$".".position.x -=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > home_y:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < home_y:
				$".".position.y += 150 * get_physics_process_delta_time()
	
	if $"..".players_target.size() == 0:
		if attacking == false:
			if $".".position.x == home_x:
				at_home_x = true
			if $".".position.y == home_y:
				at_home_y = true
			if at_home_x == true and at_home_y == true:
				at_home = true
				$"..".next = true
				current_states = party_states.IDLE
	

'''func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("left"):
		$".".position += direction * 350 * delta
		move_and_slide()
		$Sprite2D.flip_h = true
		$AnimationPlayer.play("Run")
		
	elif Input.is_action_pressed("right"):
		$".".position += direction * 350 * delta
		move_and_slide()
		$Sprite2D.flip_h = false
		$AnimationPlayer.play("Run")
	
	elif Input.is_action_pressed("up"):
		$".".position += direction * 350 * delta
		move_and_slide()
		$AnimationPlayer.play("Run")
	elif Input.is_action_pressed("down"):
		$".".position += direction * 350 * delta
		move_and_slide()
		$AnimationPlayer.play("Run")
		
	else:
		$AnimationPlayer.play("Idle")
		'''


func focus():
	_focus.show()
 
func unfocus():
	_focus.hide()
	
func idle():
	anim_tree.set("parameters/Idle/blend_position", Vector2(1, 0))
	anim_state.travel("Idle")	
	
func walk_attack():
	going_back = false
	at_home = false
	at_home_x = false
	at_home_y = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")
	attacking = true
	
func attack():
	anim_tree.set("parameters/Attack/blend_position", Vector2(1, 0))
	anim_state.travel("Attack")	
	
func _on_atack_over():
	current_states = party_states.WALK_BACK

func _on_on_hit():
	$"..".players_target[$"..".players_attacking].take_damage(1)
	
func walk_back():
	at_target = false
	at_target_x = false
	at_target_y = false
	attacking = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")
	going_back = true
	if $"..".players_attacking == len($"..".players) - 1:
		$"..".players_target.clear()
		$"..".players_attacking = 0
	else:
		$"..".players_attacking += 1
		emit_signal("attacking_after")
	
	


