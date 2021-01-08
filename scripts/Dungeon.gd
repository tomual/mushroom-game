extends "Map.gd"

var phase = 1

func _ready():
	pass


func _on_TimerCheck_timeout():
	var enemy_count = 0
	for member in get_tree().get_nodes_in_group("enemy"):
		if member.status != 4:
			enemy_count = enemy_count + 1
			print(enemy_count)
			print(member.status)
	if enemy_count == 0:
		if phase == 1:
			print("switch phase from " + str(phase))
			summon_miniboss()
			phase = 2
			$TimerCheck.stop()
			$TimerCheck.wait_time = 5
			$TimerCheck.start()
		elif phase == 2:
			summon_boss()
			phase = 3



func summon_miniboss():
	print("summon_miniboss")
	var scene = load("res://scenes/Miniboss.tscn")
	var miniboss = scene.instance()
	miniboss.player = player
	miniboss.position = Vector2(100, 100)
	$YSort.add_child(miniboss)


func summon_boss():
	print("summon_boss")
	var scene = load("res://scenes/Boss.tscn")
	var boss = scene.instance()
	boss.player = player
	boss.position = Vector2(462, 95)
	$YSort.add_child(boss)
