extends KinematicBody2D

const DIR_B = "b"
const DIR_T = "t"
const DIR_L = "l"
const DIR_R = "r"

enum { IDLE, BUSY, DODGE, DEAD }

var velocity
var status = IDLE
var speed = 300
var hp = 10
var screen_size
export var facing = DIR_T
export var flipped = false

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()
	
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("pickup", self, "pickup")
		member.connect("drop", self, "drop")
		member.set_player()
	
	for member in get_tree().get_nodes_in_group("enemy"):
		member.set_player()
	
	
	for member in get_tree().get_nodes_in_group("spawn"):
		position = member.position
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.connect("player_set_busy", self, "set_busy")
		member.connect("player_set_idle", self, "set_idle")

#
#func _physics_process(delta):
#	if (can_move()):
#		velocity = Vector2()
#		if Input.is_action_pressed("ui_right"):
#			velocity.x += 1
#		if Input.is_action_pressed("ui_left"):
#			velocity.x -= 1
#		if Input.is_action_pressed("ui_down"):
#			velocity.y += 1
#			facing = DIR_B
#		if Input.is_action_pressed("ui_up"):
#			velocity.y -= 1
#			facing = DIR_T
#		$AnimatedSprite.animation = str(facing, "_walk")
#
#		velocity = velocity.normalized() * speed
#		velocity = move_and_slide(velocity)
##			$AnimatedSprite.animation = str(facing, "_idle")
#
##		position += velocity * delta
##		position.x = clamp(position.x, 30, screen_size.x - 30)
##		position.y = clamp(position.y, 75, screen_size.y - 45)

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
		facing = DIR_B
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		facing = DIR_T
	if Input.is_action_pressed("dodge") and $TimerDodgeCoolDown.is_stopped():
		print_debug("dodge")
		status = DODGE
		$TimerDodgeCoolDown.start()

func _physics_process(delta):
	if status == IDLE:
		get_input()
		if velocity == Vector2.ZERO:
			$AnimatedSprite.animation = str(facing, "_idle")
		else:
			$AnimatedSprite.animation = str(facing, "_walk")
	if status == BUSY:
		velocity = Vector2.ZERO
	if status == DODGE:
		speed = 400
		$AnimatedSprite.animation = "dodge"
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

func can_move():
	return hp > 0


func pickup(node):
	print_debug("pickup")


func drop(node):
	print_debug("drop")


func set_busy():
	status = BUSY


func set_idle():
	status = IDLE


func _on_TimerDodgeCoolDown_timeout():
	speed = 300
	if status == DODGE:
		status = IDLE
	else:
		$AnimatedSprite.animation = str(facing, "_idle")
