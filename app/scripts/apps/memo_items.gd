extends Control

var from = []
var last


var memo_interval = {1: 1, 2: 3, 3: 7, 4: 14, 5: 31, 6: 93, 7: 186}
var current_memo_interval : int = 1
var next_memo
var creation_date = []

var months = {0: -1, 1: 31, 2: 30, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31}

signal delete(item_name)

func _ready() -> void:
	pass
	#load_creation_date()
	
	
#func load_creation_date():
	#var file = FileAccess.open("user://items/" + $name.text + ".json", FileAccess.READ)
	#var json_string = file.get_as_text()
	#file.close()
	#var json = JSON.new()
	#var parsed_data = json.parse_string(json_string)
	#if parsed_data == null:
		#print("error parsing ", json.get_error_message())
		#return
	#var data = parsed_data[0]
	#add_preloaded_item(i.rstrip(".json"), data.get("output"), data.get("from"))
		
func _on_kill_pressed() -> void:
	delete.emit($name.text)
	queue_free()

func set_contents(item_name : String, from_value : String, from_fromated):
	$name.text = item_name
	$from.text = from_value
	from = from_fromated
	calculate_next()
	
func get_last(): # last time we had to study this
	pass
	
func calculate_next():
	var current_date = [] 

	current_date = get_current_date()
	print(current_date)
	creation_date = from
	
	next_memo = get_next_date(creation_date, memo_interval.get(current_memo_interval)) 
	
	
	print("next before ", next_memo)
	print("size ", memo_interval.values().size())
	var prev_memo = next_memo
	if compare_date(prev_memo, current_date) == 2:
		print("same")
		change_next_label(next_memo, 0)
	else:
		while compare_date(next_memo, current_date) != 0:
			
			print("decal")
			current_memo_interval = current_memo_interval + 1
			if current_memo_interval > memo_interval.values().size():
				print("FINISHED")
				return
			print("to add ",  memo_interval.get(current_memo_interval))
			next_memo = get_next_date(prev_memo, memo_interval.get(current_memo_interval)) 
			prev_memo = next_memo
			print("prev ", prev_memo)
			print("next ", next_memo)
			
		change_next_label(next_memo, memo_interval.get(current_memo_interval))
		
	print("finished loo")
	
	print(memo_interval.get(current_memo_interval))
	
	return next_memo
	
func get_next_date(date, days_to_add):
	print("to add2 ", days_to_add)
	var formated_date = [int(date[0]), int(date[1]), int(date[2])]
	var output = [formated_date[0] + days_to_add, formated_date[1], formated_date[2]]
	print("output ", output)
	var i : int = 0
	while output[0] > months.get(formated_date[1] + i): 
		print("adjusting")
		output[0] = output[0] - months.get(formated_date[1] + i) 
		output[1] = formated_date[1] + (1 + i) 
		if output[1] > 12: # change year
			output[1] = 1
			formated_date[1] = 1
			output[2] = output[2] + 1
		i = i + 1 
	return output
	
func compare_date(date1, date2): # return true if date2 >>
	if date1[2] < date2[2]:
		return 1
	elif date1[2] > date2[2]:
		return 0
	
	if date1[1] < date2[1]:
		return 1
	elif date1[1] > date2[1]:
		return 0
		
	if date1[0] < date2[0]:
		return 1
	elif date1[0] > date2[0]:
		return 0
	
	return 2 # les deux dates sont égales
	
func change_next_label(date, days_to_add):
	$next.add_theme_color_override("font_color", Color(0, 0, 0, 1)
)
	print("to ADDDDDDDD ", days_to_add)
	if days_to_add > 1:
		var day = date[0]
		var month = date[1]

		if day < 10:
			day = "0" + str(day)
		if month < 10:
			month = "0" + str(month)
			
		$next.text = "dans " + str(days_to_add) + " jours, le " + str(day) + "/" + str(month) + "/" + str(date[2])
	else:
		if days_to_add == 0:
			$next.text = "aujourd'hui"
			$next.add_theme_color_override("font_color", Color(0.498039, 1, 0, 1))
		else:
			$next.text = "demain"	
	
	
	
func get_current_month():
	var datetime = Time.get_datetime_dict_from_system()
	return datetime.month
	
func get_current_day():
	var datetime = Time.get_datetime_dict_from_system()
	return datetime.day
	
func get_current_year():
	var datetime = Time.get_datetime_dict_from_system()
	return datetime.year
	
func get_current_date():
	return [get_current_day(), get_current_month(), get_current_year()]
	
	
	
	
	
