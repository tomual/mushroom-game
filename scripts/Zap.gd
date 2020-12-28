extends NinePatchRect

var player
var cost
var random

var stats = [
	"Strength",
	"Dexterity",
	"Intelligence",
	"Luck",
	"Vitality",
	"Stamina",
]

func _ready():
	random = RandomNumberGenerator.new()


func zap():
	player.update_spores(cost * -1)
	for i in range(0, player.weapon.charges.size()):
		if player.weapon.charges[i].type != null:
			var type = stats[random.randi() % stats.size()]
			var value = random.randi_range(10, 200)
			if random.randi_range(1, 100) < 50:
				value = random.randf_range(0, 1)
			player.weapon.charges[i] = {"type": type, "value": stepify(value, 0.01)}
	update()


func open():
	update()
	visible = true


func update():
	if !player.weapon:
		return
	cost = 3000 + 3000 * player.weapon.level * 0.5
	$StatPanel/Label.text = player.weapon.name
	if player.weapon.level > 0:
		$StatPanel/Label.text = $StatPanel/Label.text + " +" + str(player.weapon.level)
	$StatPanel/Stats.text = str(player.weapon.attack) + "\n"
	$StatPanel/StatsLabels.text = "Attack\n"
	
	for charge in player.weapon.charges:
		if charge.type != null:
			print_debug(charge)
			var stat = str(charge.value)
			if charge.value < 1:
				stat = str(charge.value * 100) + "%"
			$StatPanel/Stats.text = $StatPanel/Stats.text + "\n+" + stat
			$StatPanel/StatsLabels.text = $StatPanel/StatsLabels.text + "\n" + charge.type

	if player.spores < cost:
		$ButtonZap.disabled = true
	else:
		$ButtonZap.disabled = false


func _on_ButtonZap_pressed():
	zap()


func _on_ButtonCancelZap_pressed():
	visible = false
