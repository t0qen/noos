extends Control

@onready var notes: TextEdit = $notes

var global_font_size : int = 30
var current_font_size : int = global_font_size

func _on_notes_text_changed() -> void:
	var file = FileAccess.open("user://note_contents.dat", FileAccess.WRITE)
	file.store_string(notes.text)
	file.close()
	

func _ready() -> void:
	var file = FileAccess.open("user://note_contents.dat", FileAccess.READ)
	if file:
		notes.text = file.get_as_text()
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("decrease_font"):
		current_font_size -= 1
		notes.add_theme_font_size_override("font_size", current_font_size)
	if Input.is_action_just_pressed("increase_font"):
		current_font_size += 1
		notes.add_theme_font_size_override("font_size", current_font_size)
	if Input.is_action_just_pressed("reset_font_size"):
		notes.add_theme_font_size_override("font_size", global_font_size)
		current_font_size = global_font_size
