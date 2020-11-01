extends Area2D

export var id = 0
export var item_id = 0
export var phase = 0
export var watered = 0

var main
var timer


func _ready():
	$Harvest/CollisionShape2D.disabled = true
	for member in get_tree().get_nodes_in_group("main"):
		main = member
	
	var data = main.get_mound_data(id)
	phase = data.phase
	item_id = data.item_id
	update_plant_sprite()
	
	main.connect("grow", self, "grow")
	

func _on_Mound_area_entered(area):
	if area.name == "JouroWater":
		print_debug("Watered!")
		$TimerJouro.start()


func _on_Mound_area_exited(area):
	$TimerJouro.stop()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 1
	watered = 1


func plant(item_id):
	self.item_id = item_id
	phase = 1
	update_plant_sprite()
	print_debug(item_id)


func update_plant_sprite():
	$PhaseSprite.frame = phase


func update_plant_harvest():
	if phase == 4:
		$Harvest/CollisionShape2D.disabled = false


func grow(id):
	if self.id == id:
		print_debug("grow me " + str(id))
		var data = main.get_mound_data(id)
		phase = data.phase
		update_plant_sprite()
		update_plant_harvest()
