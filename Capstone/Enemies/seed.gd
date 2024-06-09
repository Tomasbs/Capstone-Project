extends CharacterBody2D


func _process(delta):
	#if $".".position != $".."/Player.position:
	#	$".".position.x +=  250 * get_physics_process_delta_time()
	pass
