extends KinematicBody2D

var velocity
var player
var speed = 200
var player_in_attack_range = false

enum { IDLE, FOLLOWING, BUSY, DODGE, DEAD }

var status = IDLE
var flipped = false


func _ready():
	pass 


func _process(delta):
	if status == FOLLOWING and !player_in_attack_range:
		$AnimatedSprite.flip_h = position.x < player.position.x
		flipped = $AnimatedSprite.flip_h
		velocity = Vector2()
		var offset_y = 0
		var offset_x = 80
		if flipped:
			offset_x = offset_x * -1
		velocity.x = (player.position.x + offset_x) - position.x
		velocity.y = (player.position.y + offset_y) - position.y 
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)


func set_player():
	player = get_tree().get_nodes_in_group("player")[0]


func _on_AreaAggro_area_entered(area):
	var name = area.get_parent().name
	status = FOLLOWING


func _on_AreaAggro_area_exited(area):
	var name = area.get_parent().name
	status = IDLE


func _on_AreaAttack_area_entered(area):
	player_in_attack_range = true


func _on_AreaAttack_area_exited(area):
	player_in_attack_range = false
