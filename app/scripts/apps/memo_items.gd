extends Control

var from 
var last


var memo_interval = {1: 1, 2: 7, 3: 30, 4: 120}
var current_memo_interval : int = 1
var next_memo
var creation_date = []

var months = {1: 31, 2: 30, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31}


#var study_interval = {1 (premiere fois) : 2 (combien jour), 2 : 4} 
#var current_interval = 2 (will be saved)
#
#func (): # avoir le nombre de jours entre from et strudy_interval(current)
#	from + stody_interval(current) = supposed date** 31 ou 30**
#   avoir le nombre de jours entre current date et supposed date
#	.text = "dans {output} jours"
#

func _ready() -> void:
	print(calculate_next())
	
	
func _on_kill_pressed() -> void:
	queue_free()

func set_contents(item_name : String, from_value : String, from_fromated):
	$name.text = item_name
	$from.text = from_value
	from = from_fromated
	
func get_last(): # last time we had to study this
	pass
	
func calculate_next():
	var current_date = [] # if just created, else 'fromfromated'

	current_date = [29, 8, 2025]
	creation_date = [28, 8, 2025]
	
	next_memo = get_next_date(creation_date, memo_interval.get(current_memo_interval)) 
	print("next ", next_memo)
	print(compare_date(next_memo, current_date))
	while compare_date(next_memo, current_date) == true:
		print("decal")
		current_memo_interval = current_memo_interval + 1
		next_memo = get_next_date(current_date, memo_interval.get(current_memo_interval)) 
		
	return next_memo
	
func get_next_date(date, days_to_add):
	var output = [date[0] + days_to_add, date[1], date[2]]
	var i : int = 0
	while output[0] > months.get(date[1] + i): 
		output[0] = output[0] - months.get(date[1] + i) 
		output[1] = date[1] + (1 + i) 
		if output[1] > 12: # change year
			output[1] = 1
			date[1] = 1
			output[2] = output[2] + 1
		i = i + 1 
	return output
	
func compare_date(date1, date2): # return true if date2 >>
	var output : bool = false
	if date1[1] < date2[1] && date1[2] <= date2[2]:
		output = true
	if date1[1] == date2[1] && date1[0] < date2[0] && date1[2] <= date2[2]:
		output = true
	if date1[1] == date2[1] && date1[2] < date2[2]:
		output = true
	
	if date1[0] == date2[0] && date1[1] == date2[1] && date1[2] == date2[2]:
		output = true

	return output

		
		
		
		
		

		
		
		
		
		
		
		
		
		
		
	
func get_latest():
	pass
	
#func additionate_date(var ):
	
	
	
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
	
	
	
	
	
