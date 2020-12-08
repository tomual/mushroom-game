extends Area2D

export var speed = 100
export(Vector2) var target

func _process(delta):
	var position_difference = target - position
	var velocity = position_difference.normalized() * speed
	position += velocity * delta
	
