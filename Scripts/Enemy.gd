extends KinematicBody2D

const GRAVITY = 11

var motion = Vector2()
var launchVal = -100

func _physics_process(delta):
	var Player = get_parent().get_node("Player")
	
#Gravity
	motion.y += GRAVITY
	
	move_and_slide(motion)


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		var facingDir = get_parent().get_node("Player").facingDir
		motion.x = launchVal*-facingDir
		motion.y = launchVal
		print (facingDir)
