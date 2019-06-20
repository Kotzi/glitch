extends KinematicBody2D

signal player_entered_hole

const SPEED = 300

var velocity = Vector2()

onready var limit_left =  $Sprite.texture.get_height()/2
onready var limit_right = OS.get_window_size().x - $Sprite.texture.get_height()/2
onready var limit_top = $Sprite.texture.get_height()/2
onready var limit_bottom = OS.get_window_size().y - $Sprite.texture.get_height()/2

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * SPEED
	
	velocity = move_and_slide(velocity)
	
	position.x = clamp(position.x, limit_left, limit_right)
	position.y = clamp(position.y, limit_top, limit_bottom)

func on_entered_hole():
	emit_signal("player_entered_hole")