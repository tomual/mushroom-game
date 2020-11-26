extends NinePatchRect

var player
var cost

func upgrade():
	print_debug(player.weapon)
	player.update_spores(cost * -1)
	player.weapon.level = player.weapon.level + 1
	player.weapon.attack = player.weapon.attack + 13
	update()


func open():
	update()
	visible = true


func update():
	cost = 3000 + 3000 * player.weapon.level * 0.5
	# Before
	$Before/Label.text = player.weapon.name
	if player.weapon.level > 0:
		$Before/Label.text =  $Before/Label.text + " +" + str(player.weapon.level)
	$Before/Stats.text = str(player.weapon.attack)

	# After
	$After/Label.text = player.weapon.name
	$After/Label.text =  $After/Label.text + " +" + str(player.weapon.level + 1)
	$After/Stats.text = str(player.weapon.attack + 13)
	
	if player.spores < cost:
		$ButtonUpgrade.disabled = true
	else:
		$ButtonUpgrade.disabled = false


func _on_ButtonUpgrade_pressed():
	upgrade()


func _on_ButtonCancelUpgrade_pressed():
	visible = false
