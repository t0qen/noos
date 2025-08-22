extends Node

@onready var break_finished: AudioStreamPlayer = $break_finished
@onready var button: AudioStreamPlayer = $button
@onready var menu: AudioStreamPlayer = $menu
@onready var work_finished: AudioStreamPlayer = $work_finished

func play(input : String):
	match input:
		"break":
			break_finished.play()
		"button":
			button.play()
		"menu":
			menu.play()
		"work":
			work_finished.play()
			
