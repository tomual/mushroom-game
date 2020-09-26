extends KinematicBody2D

signal update_health(hp, max_hp)
signal update_stamina(stamina, max_stamina)

enum { IDLE, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST }

var max_hp = 200
var hp
var max_stamina = 200
var stamina

var velocity
var status = IDLE
var speed = 200
var is_in_range_interactable = false
export var flipped = false

var time_attack_pre = 0.1
var time_attack = 0.2
var time_attack_post = 0.1

func _ready():
	disable_weapon()
	$AnimatedSprite.play()
	$AnimatedSpriteWeapon.play()
	
	for member in get_tree().get_nodes_in_group("enemy"):
		member.connect("apply_damage", self, "take_damage")
		member.set_player()
	
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("pickup", self, "pickup")
		member.connect("drop", self, "drop")
		member.connect("interactable_in_range", self, "set_is_in_range_interactable")
		member.set_player()
		
	for member in get_tree().get_nodes_in_group("hud"):
		member.set_player()
		member.connect("player_set_busy", self, "set_busy")
		member.connect("player_set_idle", self, "set_idle")
	
	hp = max_hp
	emit_signal("update_health", hp, max_hp)


func get_input():
	# Attack
	if status != BUSY and Input.is_action_pressed("fire"):
		attack_start()

	# Move
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

	# Dodge
	if !is_in_range_interactable and Input.is_action_pressed("dodge") and $TimerDodgeCoolDown.is_stopped():
		print_debug("dodge")
		status = DODGE
		$TimerDodgeCoolDown.start()


func _physics_process(delta):
	if can_move():
		get_input()
		if !is_attacking():
			if velocity == Vector2.ZERO:
				$AnimatedSprite.animation = "idle"
				$AnimatedSpriteWeapon.animation = "idle"
			elif velocity != Vector2.ZERO:
				$AnimatedSprite.animation = "walk"
				$AnimatedSpriteWeapon.animation = "walk"
	if !can_move() and status != DODGE:
		velocity = Vector2.ZERO
	if status == DODGE:
		speed = 200
		$AnimatedSprite.animation = "dodge"
		$AnimatedSpriteWeapon.animation = "dodge"
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	
	if flipped:
		$AreaPlayerWeapon/CollisionShape2D.position.x = abs($AreaPlayerWeapon/CollisionShape2D.position.x) * -1
	else:
		$AreaPlayerWeapon/CollisionShape2D.position.x = abs($AreaPlayerWeapon/CollisionShape2D.position.x)


func can_move():
	return status == IDLE or status == BUSY


func _on_TimerDodgeCoolDown_timeout():
	speed = 200
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


func set_is_in_range_interactable(is_in_range):
	print_debug("set_is_in_range_interactable")
	is_in_range_interactable = is_in_range


func pickup(node):
	set_busy()
	$AnimatedSpriteWeapon.hide()


func drop(node):
	set_idle()
	$AnimatedSpriteWeapon.show()


func set_busy():
	status = BUSY


func set_idle():
	status = IDLE


func take_damage(amount):
	hp = hp - amount
	emit_signal("update_health", hp, max_hp)

func is_attacking():
	return status == ATTACK || status == ATTACK_POST || status == ATTACK_PRE
