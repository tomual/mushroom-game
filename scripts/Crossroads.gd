extends "Map.gd"


func _on_TimerCheck_timeout():
	var enemy_count = 0
	for member in get_tree().get_nodes_in_group("enemy"):
		if member.status != 4:
			enemy_count = enemy_count + 1
			print(enemy_count)
			print(member.status)
	if enemy_count == 0:
		summon_miniboss()
		$TimerCheck.stop()


func summon_miniboss():
	print("summon_miniboss")
	var scene = load("res://scenes/Miniboss.tscn")
	var miniboss = scene.instance()
	miniboss.player = player
	miniboss.position = Vector2(100, 100)
	$YSort.add_child(miniboss)

