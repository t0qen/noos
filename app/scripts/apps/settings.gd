extends Control



func _on_btn_toggled(toggled_on: bool) -> void:
	AudioManager.play("button")


func _on_btn_pressed() -> void:
	AudioManager.play("button")


func _on_btn_2_toggled(toggled_on: bool) -> void:
	AudioManager.play("button")


func _on_btn_3_pressed() -> void:
	AudioManager.play("button")
	for file in DirAccess.get_files_at("user://"):  
		DirAccess.remove_absolute(file)

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	AudioManager.play("menu")
