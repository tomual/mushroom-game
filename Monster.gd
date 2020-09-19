extends KinematicBody2D

var velocity
var player
var speed = 200
var player_in_attack_range = false
var player_in_aggro_range = false

var time_attack_pre = 0.6
var time_attack = 0.2
var time_attack_post = 0.4

enum { IDLE, FOLLOWING, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST }

var status = IDLE
var flipped = false


func _ready():
	$AnimatedSprite.play()
	disable_weapon()


func _process(delta):
	if status == FOLLOWING:
		if !player_in_attack_range:
			$AnimatedSprite.flip_h = position.x > player.position.x
			flipped = $AnimatedSprite.flip_h
			velocity = Vector2()
			var offset_y = 0
			var offset_x = 30
			var precision = 5
			if !flipped:
				offset_x = offset_x * -1
				$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x)
			else:
				offset_x = offset_x
				$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x) * -1
			var target_x = player.position.x + offset_x
			var target_y = player.position.y + offset_y
			if abs(target_x - position.x) > precision or abs(target_y - position.y ) > precision:
				velocity.x = target_x - position.x
				velocity.y = target_y - position.y 
				velocity = velocity.normalized() * speed
				velocity = move_and_slide(velocity)
				$AnimatedSprite.animation = "walk aggro"
		else:
			attack_start()


func enable_weapon():
	$AreaWeapon/CollisionShape2D.disabled = false 


func disable_weapon():
	$AreaWeapon/CollisionShape2D.disabled = true 


func set_player():
	player = get_tree().get_nodes_in_group("player")[0]


func attack_start():
	print_debug("attack_start")
	status = ATTACK_PRE
	$AnimatedSprite.animation = "attack"
	$AnimatedSprite.frame = 0
	$TimerAttack.stop()
	$TimerAttack.wait_time = time_attack_pre
	$TimerAttack.start()


func _on_AreaAggro_area_entered(area):
	if area.name == "AreaPlayer":
		player_in_aggro_range = true
		if status == IDLE:
			status = FOLLOWING


func _on_AreaAggro_area_exited(area):
	if area.name == "AreaPlayer":
		player_in_aggro_range = false
		if status == FOLLOWING:
			status = IDLE


func _on_AreaAttack_area_entered(area):
	var name = area.get_parent().name
	if name == "Player":
		player_in_attack_range = true
		print_debug("_on_AreaAttack_area_entered")
		if status == FOLLOWING:
			attack_start()


func _on_AreaAttack_area_exited(area):
	var name = area.get_parent().name
	if name == "Player":
		print_debug("_on_AreaAttack_area_exited")
		player_in_attack_range = false


func _on_TimerAttack_timeout():
	if status == ATTACK_PRE:
		status = ATTACK
		enable_weapon()
		$TimerAttack.wait_time = time_attack
		$TimerAttack.start()
	elif status == ATTACK:
		status = ATTACK_POST
		disable_weapon()
		$TimerAttack.wait_time = time_attack_post
		$TimerAttack.start()
	else:
		if player_in_aggro_range:
			status = FOLLOWING
		else:
			status = IDLE
			$AnimatedSprite.animation = "idle"
