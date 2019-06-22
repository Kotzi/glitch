extends Node2D

func _ready():
	$AnimationPlayer.play("Sky")
	
func adjust_rect(x, y):
	$Sky.region_rect.size.x += x
	$Sky.region_rect.size.y += y
	
	for star in $Stars.get_children():
		star.region_rect.size.x += x
		star.region_rect.size.y += y