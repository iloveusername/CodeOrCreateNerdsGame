extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128
const HEALTH = 20

var motion = Vector2()
var launchVal = -100
var health = 20
var x = 0
onready var spriteColor = $Sprite
onready var fireAnim = $AnimationPlayer

func _physics_process(delta):
	fireAnim.play("Fire Animation")
	var Player = get_parent().get_node("Player")
	
#Sprite Color Stuff
#	spriteColor.self_modulate = Color(health/12, health/12, health/12)
	
#Gravity
	motion.y += GRAVITY * delta
	if x < 50 :
		x=x+1
		
	elif x>=50 && is_on_floor():
		var random1 = rand_range (-50, 50)
		var random2 = rand_range (-30, 0)
		motion.x = random1 * 5
		motion.y = random2 * 3
		x=0
		
	motion.x = lerp(motion.x, 0, FRICTION)
	print(health/12)
	motion = move_and_slide(motion, Vector2.UP)
	
#Death
	if health < 0:
		queue_free()
	


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		var facingDir = get_parent().get_node("Player").facingDir
		motion.x = launchVal*-facingDir*3
		motion.y = launchVal*1.25
		health = health - 4

