extends CharacterBody2D

var seed_scene: PackedScene = preload("res://Enemies/seed.tscn")

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum enemies_states {IDLE, HURT, DEATH, PHYS_ATTACK, SEED_ATTACK, WALK_ATTACK, WALK_BACK}
var current_states = enemies_states.IDLE

signal attack_over
signal attack_hit
signal attack_hit_connection
signal seed_created
signal seed_moving

var phys_attacking = false
var enemy_going_back = false
var randomizer = false

var at_home_x = true
var at_home_y = true
var at_home = true

var dead = false

var home_x = 900	
var home_y = 355

var at_target_x = false
var at_target_y = false
var at_target = false

var attacking = false
var attack_type : int = -1
var hp = 0

@export var MAX_HEALTH: float = 7

var enemy_health: float = 7:
	set(value):
		enemy_health = value
		_update_progress_bar()
	
func _ready():
	$Seed.position.y = 10000

func _process(delta):
	hp = enemy_health
	match current_states:
		enemies_states.IDLE:
			idle()
		enemies_states.HURT:
			hurt()
		enemies_states.SEED_ATTACK:
			seed_attack()
		enemies_states.PHYS_ATTACK:
			phys_attack()
		enemies_states.WALK_ATTACK:
			walk_attack()
		enemies_states.WALK_BACK:
			walk_back()
		enemies_states.DEATH:
			death()
			
	if enemy_health <= 0:
		dead = true
		current_states = enemies_states.DEATH		
			
	if attacking == true and randomizer == true and dead == false:
		attack_type = randi() % 2
		randomizer = false
	if attack_type == 0:
		print("HHH")
		current_states = enemies_states.WALK_ATTACK	
	if attack_type == 1:	
		current_states = enemies_states.SEED_ATTACK	
		
	if phys_attacking == true and at_target == false:
		if at_target_x == false:			
			$".".position.x -=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > home_y - 5:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < home_y - 5:
				$".".position.y += 150 * get_physics_process_delta_time()
	
	if enemy_going_back == false:
		if $".".position.x <= home_x - 500:
			at_target_x = true
		if $".".position.y == home_y - 5:
			at_target_y = true
		if at_target_x == true and at_target_y == true:
			at_target = true
			current_states = enemies_states.PHYS_ATTACK 
			
	if enemy_going_back == true and at_home == false:
		if at_home_x == false:
			position.x +=  250 * get_physics_process_delta_time()
		if at_target_y == false:
			if 	$".".position.y > home_y:
				$".".position.y -= 150 * get_physics_process_delta_time()
			elif 	$".".position.y < home_y:
				$".".position.y += 150 * get_physics_process_delta_time()
			
	if attacking == false and phys_attacking == false:
		if $".".position.x == home_x:
			at_home_x = true
		if $".".position.y == home_y:
			at_home_y = true
		if at_home_x == true and at_home_y == true:
			at_home = true
			current_states = enemies_states.IDLE
			
	

func _update_progress_bar():
	progress_bar.value = (enemy_health/MAX_HEALTH) * 100
	
func focus():
	_focus.show()
 
func unfocus():
	_focus.hide()
	
func take_damage(value):
	enemy_health -= value
	current_states = enemies_states.HURT
	
func idle():
	anim_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func hurt():
	anim_tree.set("parameters/Hurt/blend_position", Vector2(0, 0))
	anim_state.travel("Hurt")
	
func seed_attack():
	anim_tree.set("parameters/Seed_Attack/blend_position", Vector2(0, 0))
	anim_state.travel("Seed_Attack")

func on_states_reset():
	attacking = false
	attack_type = 2
	current_states = enemies_states.IDLE


func _on_seed_created():
	$Seed.position = $SeedStartPosition/Marker2D.position
	emit_signal("seed_moving")
	
func phys_attack():
	anim_tree.set("parameters/Physical_Attack/blend_position", Vector2(0, 0))
	anim_state.travel("Physical_Attack")

func walk_attack():
	enemy_going_back = false
	at_home = false
	at_home_x = false
	at_home_y = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")
	phys_attacking = true
	
func walk_back():
	attack_type = 2
	at_target = false
	at_target_x = false
	at_target_y = false
	phys_attacking = false
	attacking = false
	anim_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")
	enemy_going_back = true
	$"..".show_choice()
	
	
func _on_attack_hit():
	emit_signal("attack_hit_connection")

func _on_attack_over():
	current_states = enemies_states.WALK_BACK
	
func death():
	anim_tree.set("parameters/Death/blend_position", Vector2(-1, 0))
	anim_state.travel("Death")
