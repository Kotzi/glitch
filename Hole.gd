extends Node2D

var hole2Texture = preload("res://assets/Hole2.png")
var hole3Texture = preload("res://assets/Hole3.png")
var hole4Texture = preload("res://assets/Hole4.png")

var is_active = false

onready var position_dx = $Sprite.texture.get_width()
onready var position_dy = $Sprite.texture.get_height()

func _ready():
	$AnimationPlayer.play("HoleAppeared")
	$CreationAudioPlayer.play()

func _on_Area2D_body_entered(body):
	if !is_active: 
		return
	
	if body.has_method("on_entered_glitch"):
		body.on_entered_glitch()

func activate():
	$AnimationPlayer.stop()
	$GlitchAudioPlayer.play()
	
	var glitch = randi() % 4 + 1
	for i in range(0, glitch):
		var newHole = $Sprite.duplicate(DUPLICATE_SIGNALS)
		newHole.position = Vector2($Sprite.position.x + randf() * self.position_dx, $Sprite.position.y + randf() * self.position_dy)
		match randi()%4:
			0: 
				newHole.position.x *= -1
			1: 
				newHole.position.x *= 1
			2: 
				newHole.position.y *= -1
			3: 
				newHole.position.y *= 1
				
		match randi()%3:
			0: newHole.texture = hole2Texture
			1: newHole.texture = hole3Texture
			2: newHole.texture = hole4Texture
				
		add_child(newHole)
	
	is_active = true