extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const ACCELERATION = 1200.0
const FRICTION = 1500.0
const AIR_CONTROL = 0.4

@export var rocket_scene: PackedScene

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var arm_pivot: Node2D = $ArmPivot
@onready var muzzle: Marker2D = $ArmPivot/Arm/Muzzle
@onready var ui_label = $"../CanvasLayer/HUD_Label"
@onready var spawn_point = get_parent().get_node("Spawn") # ✅ NOVO

# ❤️ VIDA
var max_life := 100
var life := 100

# 🚀 MUNIÇÃO
var max_ammo := 4
var ammo := max_ammo

var reload_time := 2.0
var reload_timer := 0.0
var reloading := false

# ⏱️ COOLDOWN
var shoot_cooldown := 0.3
var shoot_timer := 0.0

var max_velocity := 800.0


func _ready():
	add_to_group("player")


func _physics_process(delta):



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

	aim()

	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

	move_and_slide()

	update_ui()




func aim():
	var mouse_pos = get_global_mouse_position()
	
	arm_pivot.look_at(mouse_pos)
	
	if mouse_pos.x < global_position.x:
		arm_pivot.scale.y = -1
	else:
		arm_pivot.scale.y = 1


func shoot_rocket():

	if ammo <= 0 or reloading or shoot_timer > 0:
		return

	shoot_timer = shoot_cooldown
	ammo -= 1

	var rocket = rocket_scene.instantiate()
	get_tree().current_scene.add_child(rocket)

	rocket.global_position = muzzle.global_position

	var dir = (get_global_mouse_position() - muzzle.global_position).normalized()
	rocket.direction = dir
	rocket.player = self

	if ammo == 0:
		start_reload()

	update_ui()


func start_reload():
	reloading = true
	reload_timer = reload_time


func take_damage(amount):
	life -= amount
	
	if life <= 0:
		die()
	
	update_ui()


# ✅ NOVO SISTEMA DE MORTE
func die():

	# ❤️ vida
	life = max_life
	
	# 📍 posição
	global_position = spawn_point.global_position
	
	# 🛑 movimento
	velocity = Vector2.ZERO
	
	# 🔫 RESET TOTAL DA ARMA (CORREÇÃO DO BUG)
	reloading = false
	reload_timer = 0.0
	ammo = max_ammo
	shoot_timer = 0.0
	
	update_ui()


func apply_pickup(type, value):

	match type:

		"vida":
			life += value
			life = min(life, max_life)

		"max_vida":
			max_life += value
			life = max_life

		"max_ammo":
			max_ammo += value
			ammo = max_ammo

	update_ui()


func update_ui():
	if ui_label:
		ui_label.text = "Vida: " + str(life) + "/" + str(max_life) + "\nMunição: " + str(ammo)
