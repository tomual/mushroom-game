extends KinematicBody2D

enum { IDLE, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST }

var velocity
var status = IDLE
var speed = 300
export var flipped = false

var time_attack_pre = 0.1
var time_attack = 0.2
var time_attack_post = 0.1


func _ready():
	disable_weapon()
	$AnimatedSprite.play()
	$AnimatedSpriteWeapon.play()


func get_input():
	if Input.is_action_pressed("fire"):
		attack_start()

	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped
		$AnimatedSpriteWeapon.flip_h = flipped
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped
		$AnimatedSpriteWeapon.flip_h = flipped
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if Input.is_action_pressed("dodge") and $TimerDodgeCoolDown.is_stopped():
		print_debug("dodge")
		status = DODGE
		$TimerDodgeCoolDown.start()


func _physics_process(delta):
	if status == IDLE:
		get_input()
		if velocity == Vector2.ZERO and status == IDLE:
			$AnimatedSprite.animation = "idle"
			$AnimatedSpriteWeapon.animation = "idle"
		elif velocity != Vector2.ZERO and status == IDLE:
			$AnimatedSprite.animation = "walk"
			$AnimatedSpriteWeapon.animation = "walk"
	if status != IDLE and status != DODGE:
		velocity = Vector2.ZERO
	if status == DODGE:
		speed = 400
		$AnimatedSprite.animation = "dodge"
		$AnimatedSpriteWeapon.animation = "dodge"
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)


func _on_TimerDodgeCoolDown_timeout():
	speed = 300
	if status == DODGE:
		status = IDLE
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSpriteWeapon.animation = "idle"


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
		status = IDLE


func attack_start():
	status = ATTACK_PRE
	$AnimatedSprite.animation = "attack"
	$AnimatedSpriteWeapon.animation = "attack"
	$TimerAttack.wait_time = time_attack_pre
	$TimerAttack.start()


func enable_weapon():
	$AreaPlayerWeapon/CollisionShape2D.disabled = false 


func disable_weapon():
	$AreaPlayerWeapon/CollisionShape2D.disabled = true 
