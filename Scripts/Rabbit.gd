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
var death = 0
var die = 0
func _physics_process(delta):
	if death == 1:
		die = die + 1
	if die > 2:
		queue_free()
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


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		death = 1

func _ready():
	var scoreTracker = get_parent().get_node("ScoreTracker")
	scoreTracker.animalNeed = scoreTracker.animalNeed + 1
