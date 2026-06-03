extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://selecaodfaze.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_opções_pressed() -> void:
	get_tree().change_scene_to_file("res://opções_menu.tscn")
