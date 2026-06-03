extends Label


func _on_voltar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://selecaodfaze.tscn")
