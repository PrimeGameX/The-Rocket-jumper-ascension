extends Area2D

@export var speed := 400.0

var direction := Vector2.ZERO
var player
var exploded := false

@onready var explosion_anim: AnimatedSprite2D = $ExplosionAnim
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _physics_process(delta):

	if exploded:
		return

	var space_state = get_world_2d().direct_space_state
	
	var from = global_position
	var to = from + direction * speed * delta

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)

	if result:
		# 💥 bateu em algo
		global_position = result.position
		explode()
	else:
		# 🚀 continua andando
		global_position = to
		rotation = direction.angle()


func _on_body_entered(body):
	# fallback (caso algo falhe)
	if body != player:
		explode()


func explode():

	if exploded:
		return
	
	exploded = true

	sprite.visible = false
	
	# ✅ corrigido
	collision.set_deferred("disabled", true)

	explosion_anim.visible = true
	explosion_anim.play("explode")

	apply_explosion_force()

	await explosion_anim.animation_finished
	
	queue_free()

	if exploded:
		return
	
	exploded = true

	sprite.visible = false
	collision.disabled = true

	explosion_anim.visible = true
	explosion_anim.play("explode")

	apply_explosion_force()

	await explosion_anim.animation_finished
	
	queue_free()


func apply_explosion_force():

	if not player:
		return
	
	var dir = player.global_position - global_position
	var distance = dir.length()
	
	var max_distance = 75.0
	
	if distance < max_distance:
		var force = (max_distance - distance) / max_distance
		
		var impulse = dir.normalized() * force * 700
		impulse.y -= 200
		
		if impulse.length() > 600:
			impulse = impulse.normalized() * 600
		
		player.velocity += impulse
		
		var damage = int(force * 5)
		player.take_damage(damage)
