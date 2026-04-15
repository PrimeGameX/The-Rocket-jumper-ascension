extends Area2D

@export var label: Label

func _on_body_entered(body):

	if not body.is_in_group("player"):
		return

	print("Fim da fase!")
	
	label.visible = true
	
	await get_tree().process_frame
	
	get_tree().paused = true
