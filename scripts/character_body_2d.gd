extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		
		# Flip do sprite
		animation.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 🎬 Animações (ordem IMPORTANTE)
	if not is_on_floor():
		if animation.animation != "pulo":
			animation.play("pulo")

	elif direction != 0:
		if animation.animation != "caminha":
			animation.play("caminha")

	else:
		if animation.animation != "parado":
			animation.play("parado")

	move_and_slide()
