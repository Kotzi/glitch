extends Node2D

signal player_entered_hole

onready var hole_scene = preload("res://Hole.tscn")
onready var screen_width = int(get_viewport().size.x)
onready var screen_height = int(get_viewport().size.y)

var recently_added_holes = []

func _ready():
	randomize()
	
	$KinematicBody2D.connect("player_entered_hole", self, "on_player_entered_hole")
	
	var timer = Timer.new()

	timer.one_shot = false
	timer.wait_time = 1.5
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_HolesCreationTimer_timeout")

func _on_HolesCreationTimer_timeout():
	var count = randi() % 4 + 3
	for i in range(0, count):
		var x = randi()%screen_width
		var y = randi()%screen_height
		var hole = hole_scene.instance()
		hole.position = Vector2(x,y)
		$HolesContainer.add_child(hole)
		
		recently_added_holes.append(hole)
	
	var timer = Timer.new()

	timer.one_shot = true
	timer.wait_time = 1
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_HolesActivationTimer_timeout")

func _on_HolesActivationTimer_timeout():
	for hole in self.recently_added_holes:
		hole.activate()

	self.recently_added_holes.clear()
	
func on_player_entered_hole():

	emit_signal("player_entered_hole")