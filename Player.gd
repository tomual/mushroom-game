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
	$AnimatedSprite.play()


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$AnimatedSprite.flip_h = velocity.x < 0
		flipped = $AnimatedSprite.flip_h
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h = velocity.x < 0
		flipped = $AnimatedSprite.flip_h
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
		if velocity == Vector2.ZERO:
			$AnimatedSprite.animation = "idle"
		else:
			$AnimatedSprite.animation = "walk"
	if status != IDLE and status != DODGE:
		velocity = Vector2.ZERO
	if status == DODGE:
		speed = 400
		$AnimatedSprite.animation = "dodge"
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
