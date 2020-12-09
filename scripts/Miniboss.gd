extends "Monster.gd"

export var mode = SUMMON


var forks_postions
var forks_index = 0


func _ready():
	status = IDLE
	player_in_aggro_range = true
	Global.spawn_puffs(position)
	mode = FORKS_START
	do_forks()


func do_forks():
	if mode == FORKS_START and $TimerForks.is_stopped():
		print("do_forks")
		$AnimatedSprite.animation = "idle"
		$TimerForks.start()
		print(position)
		forks_postions = [position, position, position]


func _on_TimerForks_timeout():
	print("_on_TimerForks_timeout")
	if mode == FORKS_START:
		print("FORKS_START")
		$AnimatedSprite.animation = "idle"
		$TimerForks.wait_time = 0.5
		$TimerForks.start()
		Global.spawn_minions(forks_postions[forks_index])
		forks_index += 1
		if forks_index >= 3:
			forks_index = 0
			mode = FORKS
	elif mode == FORKS:
		print("FORKS")
		$AnimatedSprite.animation = "idle"
		mode = FORKS_END
		$TimerForks.wait_time = 1
		$TimerForks.start()
	elif mode == FORKS_END:
		print("FORKS_END")
		mode = IDLE
