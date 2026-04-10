extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

const ACCELERATION = 1200.0
const FRICTION = 1500.0
const AIR_CONTROL = 0.4

@export var rocket_scene: PackedScene

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui_label: Label = get_tree().get_first_node_in_group("ui")

# ❤️ VIDA
var health := 9999

# 🔫 MUNIÇÃO
var max_ammo := 4
var ammo := max_ammo

var reload_time := 2.0
var reload_timer := 0.0
var reloading := false

# ⏱️ COOLDOWN
var shoot_cooldown := 0.3
var shoot_timer := 0.0

var max_velocity := 700.0

func _physics_process(delta: float) -> void:

	shoot_timer -= delta
	
	if reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			ammo = max_ammo
			reloading = false

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("shoot"):
		shoot_rocket()

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		var accel = ACCELERATION
		
		if not is_on_floor():
			accel *= AIR_CONTROL
		
		velocity.x = move_toward(velocity.x, direction * SPEED, accel * delta)
		animation.flip_h = direction < 0
	
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	if not is_on_floor():
		if animation.animation != "pulo":
			animation.play("pulo")

	elif abs(velocity.x) > 10:
		if animation.animation != "caminha":
			animation.play("caminha")

	else:
		if animation.animation != "parado":
			animation.play("parado")

	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

	move_and_slide()

	update_ui()


func shoot_rocket():

	if ammo <= 0 or reloading or shoot_timer > 0:
		return

	shoot_timer = shoot_cooldown
	ammo -= 1

	var rocket = rocket_scene.instantiate()
	get_tree().current_scene.add_child(rocket)

	rocket.global_position = global_position

	var dir = global_position.direction_to(get_global_mouse_position())
	rocket.direction = dir
	rocket.player = self

	if ammo == 0:
		start_reload()

	update_ui()


func start_reload():
	reloading = true
	reload_timer = reload_time


func take_damage(amount):
	health -= amount
	
	if health <= 0:
		die()
	
	update_ui()


func die():
	queue_free()


func update_ui():
	if ui_label:
		ui_label.text = "Vida: " + str(health) + "\nMunição: " + str(ammo)
