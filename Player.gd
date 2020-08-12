extends Area2D

const DIR_B = "b"
const DIR_T = "t"
const DIR_L = "l"
const DIR_R = "r"

var speed = 200
var hp = 10
var screen_size
var facing

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()


func _process(delta):
	if (can_move()):
		var velocity = Vector2()
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
			facing = DIR_B
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
			facing = DIR_T
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.animation = str(facing, "_walk")
			$AnimatedSprite.flip_h = velocity.x < 0
		else:
			$AnimatedSprite.animation = str(facing, "_idle")
	
		position += velocity * delta
		position.x = clamp(position.x, 30, screen_size.x - 30)
		position.y = clamp(position.y, 75, screen_size.y - 45)


func can_move():
	return hp > 0
