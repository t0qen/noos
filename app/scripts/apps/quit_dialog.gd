extends Control



func _on_yes_pressed() -> void:
	AudioManager.play("button")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_no_pressed() -> void:
	hide()
