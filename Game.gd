extends Node2D

var seconds = 0
var timer = null

func format_time(time):
	var digits = []
	
	var minutes = "%02d" % [time / 60]
	digits.append(minutes)

	var seconds = "%02d" % [int(ceil(time)) % 60]
	digits.append(seconds)
	
	var formatted = String()
	var colon = ":"

	for digit in digits:
		formatted += digit + colon
	
	if not formatted.empty():
		formatted = formatted.rstrip(colon)
	
	return formatted

func _ready():
	$Node2D.connect("player_died", self, "on_player_died")
	
	timer = Timer.new()

	timer.one_shot = false
	timer.wait_time = 1
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _on_Timer_timeout():
	seconds += 1
	
	$Control.update_text(format_time(seconds))
	
func on_player_died():
	timer.stop()
	
	var parent = self.get_parent()
	var gameOver = load("res://GameOver.tscn").instance()
	gameOver.configure(format_time(seconds))
	
	parent.add_child(gameOver)
	
	get_tree().set_current_scene(gameOver)
	
	parent.remove_child(self)