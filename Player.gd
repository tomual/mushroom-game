extends Area2D

const DIR_B = "b"
const DIR_T = "t"
const DIR_L = "l"
const DIR_R = "r"

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
			flipped = $AnimatedSprite.flip_h
		else:
			$AnimatedSprite.animation = str(facing, "_idle")

		position += velocity * delta
#		position.x = clamp(position.x, 30, screen_size.x - 30)
#		position.y = clamp(position.y, 75, screen_size.y - 45)


func can_move():
	return hp > 0


func pickup(node):
	print_debug("pickup")


func drop(node):
	print_debug("drop")
