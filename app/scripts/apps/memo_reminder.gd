extends Control

var item = preload("res://app/scenes/apps/memo_reminder/memo_items.tscn")

var items_count : int = 0


const items_path = "user://items.json"

func _ready() -> void:
	if !DirAccess.dir_exists_absolute("user://items"):
		DirAccess.make_dir_absolute("user://items")
	load_items_data()
	
	
	
func add_item(item_name : String):
	items_count += 1
	var current_item = item.instantiate()
	$ScrollContainer/VBoxContainer.add_child(current_item)
	current_item.connect("delete", delete_item)
	print("add")
	# current date
	var datetime = Time.get_datetime_dict_from_system()
	var day = datetime.day
	var month = datetime.month
	if day < 10:
		day = "0" + str(day)
	if month < 10:
		month = "0" + str(month)
		
	var output : String = str(day) + "/" + str(month) + "/" + str(datetime.year)
	var from = [int(datetime.day), int(datetime.month), int(datetime.year)]
	print("add2")
	current_item.set_contents(item_name, output, from)

	var data = []
	data.append({
		"output": output,
		"from": from		
	})
	var file = FileAccess.open("user://items/" + item_name + ".json", FileAccess.WRITE)
	if file == null:
		print("file == null")
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	
func add_preloaded_item(item_name, output, from):
	var current_item = item.instantiate()
	$ScrollContainer/VBoxContainer.add_child(current_item)
	current_item.connect("delete", delete_item)
	current_item.set_contents(item_name, output, from)
	
func delete_item(item_name):
	print(item_name)
	DirAccess.remove_absolute("user://items/" + item_name + ".json")
	
func load_items_data():
	for i in DirAccess.get_files_at("user://items/"):
		var file = FileAccess.open("user://items/" + i, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parsed_data = json.parse_string(json_string)
		if parsed_data == null:
			print("error parsing ", json.get_error_message())
			return
		
		#var test1 = [{"value": 1}]
		#var 
		
		var data = parsed_data[0]
		add_preloaded_item(i.rstrip(".json"), data.get("output"), data.get("from"))
		
		
	#var file = FileAccess.open(items_path, FileAccess.READ)
	#if file == null:
		#print("error loading file == null")
		#return 
	#
	#var json_string = file.get_as_text()
	#file.close()
	#
	#var json = JSON.new()
	#data = json.parse_string(json_string)
	#if data == null:
		#print("error parsing ", json.get_error_message())
		#return
	#
	#for item in data:
		#add_preloaded_item(item["name"], item["output"], item["from"])

func _on_add_pressed() -> void:
	if $input.text != "":
		add_item($input.text)
		$input.text = ""
		$input.grab_focus()

func _on_input_text_submitted(new_text: String) -> void:
	if $input.text != "":
		add_item(new_text)
		$input.text = ""
		$input.grab_focus()
