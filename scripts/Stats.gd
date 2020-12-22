extends NinePatchRect

var player
var cost = 0

var stats = {
	"str": 0,
	"dex": 0,
	"int": 0,
	"luk": 0,
	"emp": 0,
	"for": 0,
	"avo": 0,
	"han": 0
}


func open():
	update()
	visible = true


func load_player():
	print("update")
	for key in stats.keys():
		stats[key] = player.stats[key]
	update()


func update():
	print("update")
	var stats_text = ""
	for key in stats.keys():
		stats_text = stats_text + str(stats[key]) + "\n"
		if stats[key] <= 0:
			stats[key] = 0
			get_node("After/ButtonM" + key).disabled = true
		elif stats[key] <= player.stats[key]:
			stats[key] = player.stats[key]
			get_node("After/ButtonM" + key).disabled = true
		else:
			get_node("After/ButtonM" + key).disabled = false
		if cost + 1000 >= player.spores:
			get_node("After/ButtonP" + key).disabled = true
	$After/LabelStats.text = stats_text
	$After/LabelCost.text = "Cost:" + str(cost)


func confirm():
	print("confirm")
	player.stats = stats
	player.update_spores(cost * -1)
	cost = 0
	update()


func _on_ButtonCancelStats_pressed():
	visible = false


func _on_ButtonConfirm_pressed():
	confirm()


func change_stat(amount, stat):
	print("change_stat")
	print(amount)
	print(stat)
	stats[stat] = stats[stat] + amount
	if amount > 0:
		cost = cost + 1000
	else:
		cost = cost - 1000
	update()
