extends Control



func change_pomo(new_value):
	$pomo.text = new_value

func change_date(new_value):
	$date.text = new_value

func change_clock(new_value):
	$clock.text = new_value
	
func change_state(new_value):
	$state.text = new_value
	
	
	
var days_label = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
var date
var day : String
var day_number
var prev_datetime

func _physics_process(delta: float) -> void:
	if visible:
		var datetime = Time.get_datetime_dict_from_system()
		if prev_datetime == datetime:
			return
		day_number = datetime.day
		if day_number < 10:
			day_number = "0" + str(day_number) 
			
		date = str(days_label[datetime.weekday]) + " " + str(day_number) 
		$date.text = date
			
			
			
			
			
			
			
			
			
			
			
