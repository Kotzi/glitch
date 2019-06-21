extends Node2D

signal player_entered_hole

onready var hole_scene = preload("res://Hole.tscn")
onready var screen_scale = get_canvas_transform().get_scale()
onready var screen_size = get_viewport_rect().size / self.screen_scale
onready var min_pos = (-(get_canvas_transform().get_origin() / self.screen_scale))
onready var max_pos = self.min_pos + self.screen_size
onready var camera_dx = (0.25 * screen_size.x)
onready var camera_dy = (0.25 * screen_size.y)

var camera_movement = randi() % 4

var recently_added_holes = []

func _ready():
	$KinematicBody2D.connect("player_entered_hole", self, "on_player_entered_hole")
	
	var timer = Timer.new()

	timer.one_shot = false
	timer.wait_time = 1.8
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_HolesCreationTimer_timeout")
	
	var cameraTimer = Timer.new()

	cameraTimer.one_shot = false
	cameraTimer.wait_time = 3.8
	cameraTimer.autostart = true
	add_child(cameraTimer)
	cameraTimer.connect("timeout", self, "_on_CameraTimer_timeout")

func _on_CameraTimer_timeout():
	$CameraMovementSFXPlayer.play()
	
	match(camera_movement):
		0:
			match (randi() % 3):
				0: 
					$Camera2D.position.y += camera_dy
					self.min_pos.y += camera_dy
					self.max_pos.y += camera_dy
				1: 
					var movement = Vector2(camera_dx, camera_dy)
					$Camera2D.position += movement
					self.min_pos += movement
					self.max_pos += movement
				2: 
					$Camera2D.position.x += camera_dx
					self.min_pos.x += camera_dx
					self.max_pos.x += camera_dx
		1:
			match (randi() % 3):
				0: 
					$Camera2D.position.x += camera_dx
					self.min_pos.x += camera_dx
					self.max_pos.x += camera_dx
				1: 
					var movement = Vector2(camera_dx, -camera_dy)
					$Camera2D.position += movement
					self.min_pos += movement
					self.max_pos += movement
				2: 
					$Camera2D.position.y -= camera_dy
					self.min_pos.y -= camera_dy
					self.max_pos.y -= camera_dy
		2:
			match (randi() % 3):
				0: 
					$Camera2D.position.y -= camera_dy
					self.min_pos.y -= camera_dy
					self.max_pos.y -= camera_dy
				1: 
					var movement = Vector2(camera_dx, camera_dy)
					$Camera2D.position -= movement
					self.min_pos -= movement
					self.max_pos -= movement
				2: 
					$Camera2D.position.x -= camera_dx
					self.min_pos.x -= camera_dx
					self.max_pos.x -= camera_dx
		3:
			match (randi() % 3):
				0: 
					$Camera2D.position.x -= camera_dx
					self.min_pos.x -= camera_dx
					self.max_pos.x -= camera_dx
				1: 
					var movement = Vector2(-camera_dx, camera_dy)
					$Camera2D.position += movement
					self.min_pos += movement
					self.max_pos += movement
				2: 
					$Camera2D.position.y += camera_dy
					self.min_pos.y += camera_dy
					self.max_pos.y += camera_dy
				
	$KinematicBody2D.update_limits(self.min_pos, self.max_pos)

func _on_HolesCreationTimer_timeout():
	for i in range(0, randi() % 4 + 3):
		var x = self.min_pos.x + randf() * screen_size.x
		var y = self.min_pos.y + randf() * screen_size.y
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