extends Control




func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_faze_1_pressed() -> void:
	get_tree().change_scene_to_file("res://fase-1.tscn")


func _on_faze_2_pressed() -> void:
	get_tree().change_scene_to_file("res://fase_2.tscn")
