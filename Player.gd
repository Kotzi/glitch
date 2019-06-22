extends KinematicBody2D

signal player_entered_glitch
signal player_died

const SPEED = 300

var idleTexture = preload("res://assets/idle.png")
var idleSurprisedTexture = preload("res://assets/idle-surprised.png")
var moveTexture = preload("res://assets/move.png")
var moveSurprisedTexture = preload("res://assets/move-surprised.png")
var deadTexture = preload("res://assets/dead.png")

var velocity = Vector2()

var is_surprised = false
var is_dead = false

onready var limit_dx = 55
onready var limit_dy = 60

var limit_left = 0
var limit_right = 0
var limit_top = 0
var limit_bottom = 0

func _ready():
	$HeadSprite.texture = idleTexture
	
	update_limits(Vector2(0,0), OS.get_window_size())

func update_limits(min_pos, max_pos):
	limit_left = min_pos.x + limit_dx
	limit_right = max_pos.x - limit_dx
	limit_top = min_pos.y + limit_dy
	limit_bottom = max_pos.y - limit_dy

func _physics_process(delta):
	if self.is_dead:
		return
	
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
	
	if (velocity.length() > 0):
		if (self.is_surprised):
			$HeadSprite.texture = moveSurprisedTexture
		else:
			$HeadSprite.texture = moveTexture
	else:
		if (self.is_surprised):
			$HeadSprite.texture = idleSurprisedTexture
		else:
			$HeadSprite.texture = idleTexture

func on_entered_glitch():
	emit_signal("player_entered_glitch")
	
	self.is_dead = true
	$HeadSprite.texture = deadTexture
	$AudioStreamPlayer2D.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.8
	timer.autostart = true
	timer.connect("timeout", self, "_on_DeadTimer_timeout")
	
	add_child(timer)
	
func _on_DeadTimer_timeout():
	emit_signal("player_died")
	
func _on_SurprisedTimer_timeout():
	self.is_surprised = false
	
func surprise():
	self.is_surprised = true
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 1
	timer.autostart = true
	timer.connect("timeout", self, "_on_SurprisedTimer_timeout")
	
	add_child(timer)