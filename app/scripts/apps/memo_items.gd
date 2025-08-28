extends Control

var from 
var last


var memo_interval = {1: 1, 2: 7, 3: 30, 4: 120}
var current_memo_interval : int = 1
var next_memo


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
	print('beghan')
	var date = [get_current_day(), get_current_month(), get_current_year()]
	print(date)
	next_memo = get_next_date(date, 134) 
	print(next_memo)

func _on_kill_pressed() -> void:
	queue_free()

func set_contents(name : String, from_value : String, from_fromated):
	$name.text = name
	$from.text = from_value
	from = from_fromated
	
func get_last(): # last time we had to study this
	pass
	
func calculate_next():
	var date = [get_current_day(), get_current_month()]
	next_memo = get_next_date(date, memo_interval.get(current_memo_interval)) 
	
	
func get_next_date(date, days_to_add):
	var output = [date[0] + days_to_add, date[1], date[2]]
	#if output[0] > months.get(date[1]):
		#print(months.get(date[1]))
		#output[0] = output[0] - months.get(date[1])
		

	var i : int = 0
	while output[0] > months.get(date[1] + i): # 65 > 31 + 0 # 34 > 30
		print("------------------------------")
		print("i ", i)
		print("[0]before ", output[0])
		
		output[0] = output[0] - months.get(date[1] + i) # 65 - 31 + 0 = 34 [34, ] # 34 - 30 = 3
		print("[0]after ", output[0])
		print("[1]after ", date[1])
		output[1] = date[1] + (1 + i) # [34, 9] # [3, 10]
		if output[1] > 12:
			output[1] = 1
			date[1] = 1
			output[2] = output[2] + 1
		print("[1]after ", output[1])
		i = i + 1 # 2
		
		
			
		print(output)	
		print("------------------------------")

	
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
	
	
	
	
	
	
