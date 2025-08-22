extends Control

@onready var work_input: LineEdit = $work_input
@onready var break_input: LineEdit = $break_input

@export var base_work_duration : int = 25
@export var base_break_duration : int = 5

var current_work_duration : int = base_work_duration
var current_break_duration : int = base_break_duration

@onready var timer: Timer = $timer

signal start_pomo()
signal stop_pomo()
signal toggle_pomo()

signal work_duration_changed(new_value : int)
signal break_duration_changed(new_value : int)

func _ready() -> void:
	# TODO improve this section
	var work_file = FileAccess.open("user://work_duration.dat", FileAccess.READ)
	var break_file = FileAccess.open("user://break_duration.dat", FileAccess.READ)
	if work_file:
		work_input.text = work_file.get_as_text()
	else:
		work_input.text = str(base_work_duration)
		break_input.text = str(base_break_duration)
		
	if break_file:
		break_input.text = break_file.get_as_text()
	else:
		work_input.text = str(base_work_duration)
		break_input.text = str(base_break_duration)
	
	
	
func _on_start_pressed() -> void:
	AudioManager.play("button")
	start_pomo.emit()
	
func _on_stop_pressed() -> void:
	AudioManager.play("button")
	stop_pomo.emit()
	
func _on_toggle_pressed() -> void:
	AudioManager.play("button")
	toggle_pomo.emit()

func _on_work_input_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		AudioManager.play("button")
		work_input.placeholder_text = "work duration"
		current_work_duration = int(new_text)
		work_duration_changed.emit(int(new_text))
		
		var file = FileAccess.open("user://work_duration.dat", FileAccess.WRITE)
		file.store_string(str(new_text))
		file.close()
		
	else:
		work_input.text = ""
		work_input.placeholder_text = "error"
		await get_tree().create_timer(1.5).timeout
		work_input.text = str(current_work_duration)

func _on_break_input_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		AudioManager.play("button")
		break_input.placeholder_text = "break duration"
		current_break_duration = int(new_text)
		break_duration_changed.emit(int(new_text))
		
		var file = FileAccess.open("user://break_duration.dat", FileAccess.WRITE)
		file.store_string(str(new_text))
		file.close()
		
	else:
		break_input.text = ""
		break_input.placeholder_text = "error"
		await get_tree().create_timer(1.5).timeout
		break_input.text = str(current_break_duration)


	
	
	
	
	
