extends CharacterBody2D

@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var player_target : Array = []
@onready var attack_type : Array = []

@export var MAX_HEALTH: float = 7

var player_round = 0

var home_x = 200	
var home_y = 350

var dead = false

signal atack_over
signal on_hit
signal enemy_attacking
signal arrow_created
signal arrow_moving

var attacking = false
var going_back = false
var attacking_cd = false

var at_home_x = true
var at_home_y = true
var at_home = true

var at_target_x = false
var at_target_y = false
var at_target = false

enum party_states {IDLE, WALK_ATTACK, WALK_BACK, LIGHT_ATTACK, HEAVY_ATTACK, BOW_ATTACK, HURT, DEAD}
var current_states = party_states.IDLE

var player_health: float = 7:
	set(value):
		player_health = value
		_update_progress_bar()
		
func _ready():
	$Arrow.position.x = position.x
	$Arrow.position.y = 10000
		
func _process(delta):
	match current_states:
		party_states.IDLE:
			if dead == false:
				idle()
			else:
				death()
		party_states.WALK_ATTACK:
			attacking_cd = false
			walk_attack()
		party_states.WALK_BACK:
			walk_back()
		party_states.LIGHT_ATTACK:
			player_round += 1
			light_attack()
		party_states.HEAVY_ATTACK:
			player_round += 1
			heavy_attack()	
		party_states.HURT:
			take_damage(2)
		party_states.DEAD:
			death()
		party_states.BOW_ATTACK:
			bow_attack()
	
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
				if $"..".attack_type == 0:
					current_states = party_states.LIGHT_ATTACK 
				if $"..".attack_type == 1:
					current_states = party_states.HEAVY_ATTACK 
			
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
			if $"..".enemies_dead == false and player_round > 0 and attacking_cd == false:
				emit_signal("enemy_attacking")
				attacking_cd = true
			
				

func _update_progress_bar():
	progress_bar.value = (player_health/MAX_HEALTH) * 100
	
	
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
	
func heavy_attack():
	anim_tree.set("parameters/Heavy_Attack/blend_position", Vector2(1, 0))
	anim_state.travel("Heavy_Attack")	
	
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

func take_damage(value):
	anim_tree.set("parameters/Hurt/blend_position", Vector2(0, 0))
	anim_state.travel("Hurt")
	player_health -= value
	if player_health <= 0:
		dead = true
		current_states = party_states.DEAD	
	
func death():
	anim_tree.set("parameters/Death/blend_position", Vector2(0, 0))
	anim_state.travel("Death")
	
func bow_attack():
	anim_tree.set("parameters/Bow_Attack/blend_position", Vector2(0, 0))
	anim_state.travel("Bow_Attack")


func _on_arrow_created():
	$Arrow.position = $ArrowStartPosition/Marker2D.position
	emit_signal("arrow_moving")
