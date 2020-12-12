extends KinematicBody2D

const GRAVITY = 11

var motion = Vector2()


func _physics_process(delta):
	var Player = get_parent().get_node("Player")
	
	
	
#Gravity
	motion.y += GRAVITY
	
	move_and_slide(motion)


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		motion.y = -100
		print ("dead")
