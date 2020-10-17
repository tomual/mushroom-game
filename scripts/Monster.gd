extends KinematicBody2D

signal apply_damage(amount)
signal give_spores(amount)

var max_hp = 20
var hp
var max_stamina = 200
var stamina

var velocity
var player
var speed = 100
var player_in_attack_range = false
var player_in_aggro_range = false
var attack_physical = 10

var time_attack_pre = 0.6
var time_attack = 0.2
var time_attack_post = 0.4

enum { IDLE, FOLLOWING, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST }

var status = IDLE
var flipped = false


func _ready():
	$AnimatedSprite.play()
	disable_weapon()
	hp = max_hp


func _process(delta):
	if status != DEAD:
		if status == FOLLOWING:
			if !player_in_attack_range:
				$AnimatedSprite.flip_h = position.x > player.position.x
				flipped = $AnimatedSprite.flip_h
				velocity = Vector2()
				var offset_y = -15
				var offset_x = 25
				var precision = 5
				if !flipped:
					offset_x = offset_x * -1
					$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x)
					$Particles2D.position.x = abs($Particles2D.position.x)
					$Particles2D.scale.x = -1
				else:
					offset_x = offset_x
					$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x) * -1
					$Particles2D.position.x = abs($Particles2D.position.x) * -1
					$Particles2D.scale.x = 1
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


func set_player(node):
	player = node


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
			$AnimatedSprite.animation = "idle"
			status = IDLE


func _on_AreaAttack_area_entered(area):
	if area.name == "AreaPlayer":
		player_in_attack_range = true
		if status == FOLLOWING:
			attack_start()


func _on_AreaAttack_area_exited(area):
	if area.name == "AreaPlayer":
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


func _on_AreaWeapon_area_entered(area):
	if area.name == "AreaPlayer":
		emit_signal("apply_damage", attack_physical)


func _on_AreaHitBox_area_entered(area):
	if area.name == "AreaPlayerWeapon":
		take_damage(player.attack)


func take_damage(amount):
	hp = hp - amount
	$Particles2D.emitting = true
	if status != DEAD and is_dead():
		die()


func is_dead():
	return hp <= 0

func die():
	$AnimatedSprite.animation = "die"
	$TimerAttack.stop()
	status = DEAD
	emit_signal("give_spores", 5)
