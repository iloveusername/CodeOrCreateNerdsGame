extends Node2D

const ACCELERATION = 512
const MAX_SPEED = 100
const FRICTION = 0.1
const AIR_RESISTENCE = 0.02
const GRAVITY = 33
const JUMP_FORCE = 66

var motion = Vector2.ZERO
var maxSpeed = 100
var xDir = 1
var yDir = 1
var spriteDir = 1

func _physics_process(delta):

#Direction
	var xDir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var yDir = (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	
	motion.y -= GRAVITY
	
