extends "Monster.gd"

export var attacks = [ATTACK_MINIONS]

var minions_postions
var minions_index = 0


func _ready():
	do_spawn()
	
func _process(delta):
	if status == FOLLOWING:
		do_idle()


func do_idle():
	if $TimerIdle.is_stopped():
		$AnimatedSprite.animation = "idle"
		$TimerIdle.start()

func do_minions():
	if status == MINIONS_START and $TimerMinions.is_stopped():
		print("do_minions")
		$AnimatedSprite.animation = "minions"
		$TimerMinions.start()
		print(position)
		minions_postions = [position, position, position]

func do_spawn():
	status = SPAWNING
	$AnimatedSprite.animation = "spawn"
	$Tween.interpolate_property($AnimatedSprite, "position", Vector2(0, -300), Vector2(0, 0), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$TimerSpawn.start()

func _on_TimerMinions_timeout():
	print("_on_TimerMinions_timeout")
	if status == MINIONS_START:
		print("MINIONS_START")
		$AnimatedSprite.animation = "idle"
		$TimerMinions.wait_time = 0.5
		$TimerMinions.start()
		Global.spawn_minions(minions_postions[minions_index])
		minions_index += 1
		if minions_index >= 3:
			minions_index = 0
			status = MINIONS
	elif status == MINIONS:
		print("MINIONS")
		$AnimatedSprite.animation = "idle"
		status = FOLLOWING


func do_puffs():
	if status == PUFF_START and $TimerPuffs.is_stopped():
		print("do_puffs")
		$AnimatedSprite.animation = "puff"
		$TimerPuffs.start()
		print(position)
		minions_postions = [position, position, position]


func _on_TimerPuffs_timeout():
	print("_on_TimerPuffs_timeout")
	if status == PUFF_START:
		print("PUFF_START")
		$TimerPuffs.wait_time = 0.5
		$TimerPuffs.start()
		status = PUFF
	elif status == PUFF:
		Global.spawn_puffs(position)
		$AnimatedSprite.animation = "idle"
		status = FOLLOWING


func _on_TimerIdle_timeout():
	print("_on_TimerIdle_timeout")
	if status == FOLLOWING:
		randomize()
		var rand_index = randi() % attacks.size()
		print_debug(attacks[rand_index])
		var selected = attacks[rand_index]
		if selected == ATTACK_PUFFS:
			status = PUFF_START
			do_puffs()
		elif selected == ATTACK_MINIONS:
			status = MINIONS_START
			do_minions()


func _on_TimerSpawn_timeout():
	
	status = FOLLOWING
	player_in_aggro_range = true
