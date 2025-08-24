extends Control



func _on_btn_toggled(toggled_on: bool) -> void:
	AudioManager.play("button")
	SettingsManager.toggle_blue_light_filter(toggled_on)


func _on_btn_2_toggled(toggled_on: bool) -> void:
	AudioManager.play("button")
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED) 

func _on_btn_3_pressed() -> void:
	AudioManager.play("button")
	for file in DirAccess.get_files_at("user://"):  
		print(file)
		DirAccess.remove_absolute("user://" + str(file))
	get_tree().quit()

var is_saving : bool = false

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	AudioManager.play("menu")
	
	if !is_saving:
		is_saving = true
		print("saved !!!!")
		var file = FileAccess.open("user://volume.dat", FileAccess.WRITE)
		file.store_string(str(value))
		file.close()
		await get_tree().create_timer(1).timeout
		is_saving = false
		
func _ready() -> void:
	var volume_file = FileAccess.open("user://volume.dat", FileAccess.READ)
	if volume_file:
		$"settings/clear-data2/HSlider".set_value_no_signal(int(volume_file.get_as_text()))
