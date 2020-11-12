extends NinePatchRect

var player
var hud
var cost

func _ready():
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member


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
	$Weapon.text = player.weapon.name
	if player.weapon.level > 0:
		$Weapon.text =  $Weapon.text + " +" + str(player.weapon.level)
	$AttackBefore.text = "Attack: " + str(player.weapon.attack)
	$AttackAfter.text = "Attack: " + str(player.weapon.attack + 13)
	$ButtonUpgrade.text = "Upgrade (" + str(cost) + ")"
	if player.spores < cost:
		$ButtonUpgrade.disabled = true
	else:
		$ButtonUpgrade.disabled = false


func _on_ButtonUpgrade_pressed():
	var upgrade
	for member in get_tree().get_nodes_in_group("upgrade"):
		upgrade = member
	upgrade.upgrade()


func _on_ButtonCancelUpgrade_pressed():
	visible = false
