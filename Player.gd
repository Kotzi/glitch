extends KinematicBody2D

signal player_entered_hole

const SPEED = 300

var velocity = Vector2()

onready var limit_dx = $Sprite.texture.get_width()/2
onready var limit_dy = $Sprite.texture.get_height()/2

var limit_left = 0
var limit_right = 0
var limit_top = 0
var limit_bottom = 0

func _ready():
	update_limits(Vector2(0,0), OS.get_window_size())

func update_limits(min_pos, max_pos):
	print(min_pos)
	print(max_pos)
	
	limit_left = min_pos.x + limit_dx
	limit_right = max_pos.x - limit_dx
	limit_top = min_pos.y + limit_dy
	limit_bottom = max_pos.y - limit_dy

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