extends Control

var item = preload("res://app/scenes/apps/memo_reminder/memo_items.tscn")

var items_count : int = 0

func add_item(name : String):
	items_count += 1
	var current_item = item.instantiate()
	$ScrollContainer/VBoxContainer.add_child(current_item)
	
	
	# current date
	var datetime = Time.get_datetime_dict_from_system()
	var output : String = str(datetime.day) + "/" + str(datetime.month) + "/" + str(datetime.year)
		
	current_item.set_contents(name, output, [datetime.day, datetime.month, datetime.year])

func _on_add_pressed() -> void:
	if $input.text != "":
		add_item($input.text)
		$input.text = ""

func _on_input_text_submitted(new_text: String) -> void:
	if $input.text != "":
		add_item(new_text)
		$input.text = ""
