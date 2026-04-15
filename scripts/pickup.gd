extends Area2D

@export var type := "vida"
@export var value := 50

# 🎨 CONFIG
@export var float_amplitude := 2.0
@export var float_speed := 2.0   # ajustado para ~3s ciclo

var base_y := 0.0
var time := 0.0


func _ready():
	add_to_group("pickup")
	base_y = position.y


func _process(delta):

	time += delta

	# ⬆️⬇️ flutuar suave
	position.y = base_y + sin(time * float_speed) * float_amplitude


func _on_body_entered(body):

	if not body.is_in_group("player"):
		return
	
	if body.has_method("apply_pickup"):
		body.apply_pickup(type, value)
	
	queue_free()
