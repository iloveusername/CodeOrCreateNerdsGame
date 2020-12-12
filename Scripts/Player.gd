extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 100
const FRICTION = 0.1
const AIR_RESISTENCE = 0.02
const GRAVITY = 11
const JUMP_FORCE = 66

var motion = Vector2.ZERO
var maxSpeed = 64
var xDir = 1
var yDir = 1
var spriteDir = 1

func _physics_process(delta):

#Direction
	var xDir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var yDir = (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	
	
#X Motion
	if xDir != 0:
		motion.x += xDir * ACCELERATION * delta
		maxSpeed = 64
	else:
		motion.x = lerp(motion.x, 0, FRICTION)
	
#Y Motion
	if Input.is_action_pressed("ui_select"):
				motion.y = -JUMP_FORCE 
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, Vector2.UP)
	print(motion)

