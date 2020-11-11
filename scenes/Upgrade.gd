extends NinePatchRect

var player
var hud

func _ready():
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member


func upgrade():
	print_debug(player.weapon)
	player.weapon.level = player.weapon.level + 1
	player.weapon.attack = player.weapon.attack + 13
	update()


func open():
	visible = true


func update():
	$Weapon.text = player.weapon.name + " +" + str(player.weapon.level)
	$AttackBefore.text = "Attack: " + str(player.weapon.attack)
	$AttackAfter.text = "Attack: " + str(player.weapon.attack + 13)


func _on_ButtonUpgrade_pressed():
	var upgrade
	for member in get_tree().get_nodes_in_group("upgrade"):
		upgrade = member
	upgrade.upgrade()


func _on_ButtonCancelUpgrade_pressed():
	visible = false
