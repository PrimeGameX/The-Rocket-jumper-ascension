extends Area2D

@export var speed := 600.0

var direction := Vector2.ZERO
var player
var exploded := false

func _process(delta):
	position += direction * speed * delta
	rotation = direction.angle()


func _on_body_entered(body):
	if body == player:
		return
	explode()


func explode():

	if exploded:
		return
	
	exploded = true

	apply_explosion_force()
	queue_free()


func apply_explosion_force():

	if not player:
		return
	
	var dir = player.global_position - global_position
	var distance = dir.length()
	
	var max_distance = 150.0
	
	if distance < max_distance:
		var force = (max_distance - distance) / max_distance
		
		# 🚀 força controlada
		var impulse = dir.normalized() * force * 500
		impulse.y -= 120
		
		# 🚫 limite de impulso
		if impulse.length() > 600:
			impulse = impulse.normalized() * 600
		
		player.velocity += impulse
		
		# 💀 dano
		var damage = int(force * 25)
		player.take_damage(damage)
