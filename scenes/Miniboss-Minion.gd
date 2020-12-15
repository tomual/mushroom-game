extends Area2D


enum {SPIN, MOVE}
export var speed = 400
export(Vector2) var playerPosition
var target_angle = 0
var turn_speed = deg2rad(30)
var mode


func _process(delta):
	if mode == SPIN:
		var dir = get_angle_to(playerPosition)
		if abs(dir) < turn_speed: #to close for full turn_speed
			rotation += dir #this is just a look_at
		else:
			if dir>0: rotation += turn_speed #clockwise
			if dir<0: rotation -= turn_speed #anit - clockwise
	elif mode == MOVE:
		var target_y = extrapolate([playerPosition, position], -100)
		var position_difference = Vector2(-100, target_y) - position
		var smoothed_velocity = position_difference * 2 * delta
		position += smoothed_velocity


func extrapolate(points, x):
	var y = points[0].y + (x - points[0].x) / (points[1].x - points[0].x) * (points[1].y - points[0].y)
	return y


func start():
	print_debug("start!")
	print_debug(playerPosition)
	mode = SPIN
	$Timer.start()


func _on_Timer_timeout():
	mode = MOVE
