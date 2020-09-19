extends KinematicBody2D

var velocity
var player
var speed = 200
var player_in_attack_range = false
var player_in_aggro_range = false

var time_attack_pre = 0.1
var time_attack = 0.1
var time_attack_post = 1

enum { IDLE, FOLLOWING, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST }

var status = IDLE
var flipped = false


func _ready():
	$AnimatedSprite.play()


func _process(delta):
	if status == FOLLOWING:
		if !player_in_attack_range:
			$AnimatedSprite.flip_h = position.x > player.position.x
			flipped = $AnimatedSprite.flip_h
			velocity = Vector2()
			var offset_y = 0
			var offset_x = 40
			var precision = 5
			if !flipped:
				offset_x = offset_x * -1
				$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x)
			else:
				offset_x = offset_x
				$AreaWeapon/CollisionShape2D.position.x = abs($AreaWeapon/CollisionShape2D.position.x) * -1
			var target_x = player.position.x + offset_x
			var target_y = player.position.y + offset_y
			if abs(target_x - position.x) > precision:
				velocity.x = target_x - position.x
				velocity.y = target_y - position.y 
				velocity = velocity.normalized() * speed
				velocity = move_and_slide(velocity)


func set_player():
	player = get_tree().get_nodes_in_group("player")[0]


func _on_AreaAggro_area_entered(area):
	if area.name == "AreaPlayer":
		player_in_aggro_range = true
		if status == IDLE:
			status = FOLLOWING


func _on_AreaAggro_area_exited(area):
	if area.name == "AreaPlayer":
		player_in_aggro_range = false
		if status == FOLLOWING:
			status = IDLE
