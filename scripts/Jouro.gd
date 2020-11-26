extends "Interactable.gd"

func _ready():
	type = HOLD


func use():
	.use()
	$Particles2D.emitting = true
	$Timer.start()


func _process(delta):
	._process(delta)
	var offset_x_particles = 13
	var offset_x_water_collider = 24
	var flipped = false
	if player:
		if player.flipped:
			flipped = true
	if flipped:
		offset_x_particles = -13
		offset_x_water_collider = -24
	$JouroWater/CollisionShape2D.position = Vector2(offset_x_water_collider, 0)
	$Particles2D.position = Vector2(offset_x_particles, 0)
	if !flipped:
		$Particles2D.scale.x = -1
	if flipped:
		$Particles2D.scale.x = 1


func _on_Timer_timeout():
	$Particles2D.emitting = false
