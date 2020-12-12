extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128
var motion = Vector2.ZERO
onready var raycast= $RayCast2D
onready var raycast2 = $RayCast2D2
onready var sprite= $Sprite
var x = 0
func _physics_process(delta):
	motion.y += GRAVITY * delta
	if x < 50 :
		x=x+1
	elif x>=50 && raycast.is_colliding() || raycast2.is_colliding():
		var random1=rand_range (-50, 50)
		var random2=rand_range (-30, 0)
		if random1<0:
			sprite.flip_h = random1<0
		else:
			sprite.flip_h = random1<0
		motion.x = random1 * 5
		motion.y = random2 * 2
		x=0
	motion.x = lerp(motion.x, 0, FRICTION)
	motion = move_and_slide(motion, Vector2.UP)
