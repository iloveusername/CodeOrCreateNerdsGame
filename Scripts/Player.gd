extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 100
const FRICTION = 0.1
const AIR_RESISTENCE = 0.02
const GRAVITY = 11
const JUMP_FORCE = 300

var motion = Vector2.ZERO
var maxSpeed = 200
var xDir = 1
var yDir = 1
var spriteDir = 1

onready var rayCast = $RayCast2D

func _physics_process(delta):

#Direction
	var xDir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var yDir = (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	
	
#X Motion
	if xDir != 0:
		motion.x += xDir * ACCELERATION * delta
	else:
		motion.x = lerp(motion.x, 0, FRICTION)
	
#Clamp X Speed
	motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
	
#Y Motion
	if Input.is_action_pressed("ui_select") && rayCast.is_colliding():
		motion.y = -JUMP_FORCE 
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, Vector2.UP)
	print(rayCast.is_colliding())

