extends Control

func configure(time):
	$CenterContainer/VBoxContainer/Time.text = time

func _on_Restart_pressed():
	var main_scene = preload("res://MainMenu.tscn")
	get_tree().change_scene_to(main_scene)