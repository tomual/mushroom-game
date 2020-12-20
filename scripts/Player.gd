extends KinematicBody2D

signal update_health(hp, max_hp)
signal update_stamina(stamina, max_stamina)
signal update_spores(spores)
signal die()
signal updatePlayer(position, current_animation)

enum { IDLE, BUSY, DODGE, DEAD, ATTACK_PRE, ATTACK, ATTACK_POST, DYING }

var max_hp = 200
var hp
var max_stamina = 200
var stamina
var attack = 10
var spores = 70000

var velocity
var status = IDLE
var speed = 200
var is_in_range_interactable = false
export var flipped = false
var mound_in_range

var time_attack_pre = 0.1
var time_attack = 0.2
var time_attack_post = 0.1

# Multiplayer
export var peerActive = false
export var peerid = -1
export var skinID = 1

var weapon = {
	"name": "Doorknob",
	"level": 0,
	"attack": 15,
	"charges": [
		{"type": "Strength", "value": 0.05},
		{"type": "Strength", "value": 100},
		{"type": null, "value": null},
	]
}


export var inventory = [
	[-1, 0],
	[-1, 0],
	[-1, 0],
	[-1, 0],
	[-1, 0],
	[-1, 0],
	[-1, 0],
	[-1, 0],
]

func _ready():
	disable_weapon()
	$AnimatedSprite.play()
	$AnimatedSpriteWeapon.play()
	
	if !peerActive:
		return

	for member in get_tree().get_nodes_in_group("enemy"):
		member.connect("apply_damage", self, "take_damage")
		member.connect("give_spores", self, "update_spores")
		member.set_player(self)
	
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("drop", self, "drop")
		member.connect("interactable_in_range", self, "set_is_in_range_interactable")
		member.set_player(self)
		
	HUD.set_player(self)
	Global.set_player(self)
	
	hp = max_hp
	stamina = max_stamina
	emit_signal("update_health", hp, max_hp)
	emit_signal("update_stamina", stamina, max_stamina)
	emit_signal("update_spores", spores)
	$TimerHealStamina.start()
	$Camera2D.current = true


func set_listen_interactable(node):
	node.connect("drop", self, "drop")
	node.connect("interactable_in_range", self, "set_is_in_range_interactable")


func get_input():
	# Attack
	if status != BUSY and Input.is_action_pressed("fire") and stamina > 40:
		attack_start()

	# Move
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped
		$AnimatedSpriteWeapon.flip_h = flipped
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		flipped = velocity.x < 0
		$AnimatedSprite.flip_h = flipped
		$AnimatedSpriteWeapon.flip_h = flipped
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	# Dodge
	if !is_in_range_interactable and Input.is_action_pressed("dodge") and $TimerDodgeCoolDown.is_stopped() and stamina > 60:
		print_debug("dodge")
		status = DODGE
		stamina = stamina - 60
		emit_signal("update_stamina", stamina, max_stamina)
		$TimerDodgeCoolDown.start()


func _physics_process(delta):
	if peerActive == true:
		if can_move():
			get_input()
		if !is_attacking() and !is_dead() and status != DODGE:
			if velocity == Vector2.ZERO:
				play_animation("idle")
			else:
				play_animation("walk")
		if !can_move() and status != DODGE:
			velocity = Vector2.ZERO
		if status == DODGE:
			speed = 200
			play_animation("dodge")

		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
		
		if flipped:
			$AreaPlayerWeapon/CollisionShape2D.position.x = abs($AreaPlayerWeapon/CollisionShape2D.position.x) * -1
		else:
			$AreaPlayerWeapon/CollisionShape2D.position.x = abs($AreaPlayerWeapon/CollisionShape2D.position.x)
		
		emit_signal("updatePlayer", self.position, $AnimatedSprite.animation, flipped)


func can_move():
	return (status == IDLE or status == BUSY) and status != DYING and status != DEAD and !HUD.is_window_open()

func client_play(animation, flip):
	print_debug(animation)
	$AnimatedSprite.animation = animation
	$AnimatedSprite.flip_h = flip
	$AnimatedSpriteWeapon.animation = animation
	$AnimatedSpriteWeapon.flip_h = flip

func play_animation(animation):
	$AnimatedSprite.animation = animation
	$AnimatedSpriteWeapon.animation = animation

func _on_TimerDodgeCoolDown_timeout():
	speed = 200
	if status == DODGE:
		status = IDLE
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSpriteWeapon.animation = "idle"


func _on_TimerAttack_timeout():
	if status == ATTACK_PRE:
		status = ATTACK
		enable_weapon()
		$TimerAttack.wait_time = time_attack
		$TimerAttack.start()
	elif status == ATTACK:
		status = ATTACK_POST
		disable_weapon()
		$TimerAttack.wait_time = time_attack_post
		$TimerAttack.start()
	else:
		status = IDLE


func attack_start():
	status = ATTACK_PRE
	stamina = stamina - 40
	emit_signal("update_stamina", stamina, max_stamina)
	$AnimatedSprite.animation = "attack"
	$AnimatedSpriteWeapon.animation = "attack"
	$TimerAttack.wait_time = time_attack_pre
	$TimerAttack.start()


func enable_weapon():
	$AreaPlayerWeapon/CollisionShape2D.disabled = false 


func disable_weapon():
	$AreaPlayerWeapon/CollisionShape2D.disabled = true 


func set_is_in_range_interactable(is_in_range):
	print_debug("set_is_in_range_interactable")
	is_in_range_interactable = is_in_range


func pickup(item_id, item_quantity):
	$TimerDodgeCoolDown.start()
	for i in range(inventory.size()):
		if inventory[i][0] == item_id:
			if inventory[i][1] + item_quantity < 100:
				inventory[i] = [item_id, inventory[i][1] + item_quantity]
				HUD.update_inventory()
				return true	
			else:
				# Too many items
				return false

	for i in range(inventory.size()):
		if inventory[i][0] == -1:
			inventory[i] = [item_id, item_quantity]
			HUD.update_inventory()
			return true	
	return false


func drop(node):
	set_idle()
	$AnimatedSpriteWeapon.show()


func set_busy():
	status = BUSY
	print("set_busy")


func set_idle():
	status = IDLE


func update_spores(amount):
	spores = spores + amount
	emit_signal("update_spores", spores)
	

func take_damage(amount):
	if !is_dead():
		hp = hp - amount
		emit_signal("update_health", hp, max_hp)
		if is_dead():
			$TimerDie.start()
			$TimerAttack.stop()
			$TimerDodgeCoolDown.stop()
			
			status = DYING
			$AnimatedSprite.animation = 'idle'
			$AnimatedSpriteWeapon.animation = "idle"


func is_dead():
	return hp <= 0


func die():
	status = DEAD
	$AnimatedSpriteWeapon.visible = false
	$AnimatedSprite.animation = 'die'
	emit_signal("die")


func is_attacking():
	return status == ATTACK || status == ATTACK_POST || status == ATTACK_PRE


func _on_TimerDie_timeout():
	if status == DEAD:
		get_tree().reload_current_scene()
	else:
		die()
		$TimerDie.wait_time = 5
		$TimerDie.start()


func _on_TimerHealStamina_timeout():
	if stamina < max_stamina:
		stamina = stamina + 3
		emit_signal("update_stamina", stamina, max_stamina)


func apply_buff(buff):
	var dictionary_buffs = Global.dictionary_buffs
	callv(dictionary_buffs[buff.type], [buff])


func buff_stamina_heal(buff):
	stamina = stamina + buff.effect
	emit_signal("update_stamina", stamina, max_stamina)


func use_item(slot):
	print_debug(slot)
	var dictionary_item = Global.dictionary_item
	if dictionary_item[inventory[slot][0]].use.type == "buff":
		apply_buff(dictionary_item[inventory[slot][0]].use)
		inventory[slot][1] = inventory[slot][1] - 1
	elif dictionary_item[inventory[slot][0]].use.type == "plant":
		if plant(inventory[slot][0]):
			inventory[slot][1] = inventory[slot][1] - 1
	if inventory[slot][1] <= 0:
		inventory[slot] = [-1, 0]
	HUD.update_inventory()


func plant(item_id):
	print_debug(item_id)
	if mound_in_range:
		print_debug("can plant")
		mound_in_range.plant(item_id)
		return true
	else:
		print_debug("can't plant")
		return false


func hold(node):
	set_busy()
	$AnimatedSpriteWeapon.hide()


func _on_AreaPlayer_area_entered(area):
	if "Mound" in area.name:
		print_debug("Yeah mound")
		mound_in_range = area


func _on_AreaPlayer_area_exited(area):
	if "Mound" in area.name:
		print_debug("Nah mound")
		mound_in_range = null


func roll_damage():
	return attack + weapon.attack
