extends KinematicBody2D

signal TankPressure

const ACCELERATION = 512
const MAX_SPEED = 100
const FRICTION = 0.1
const AIR_RESISTENCE = 0.02
const GRAVITY = 33
const JUMP_FORCE = 66
const JETPACK = 132
const BOOST = 128
const FALL_SPEED_MAX = 150
const BRUH = 1

var airTank = 100
var motion = Vector2.ZERO
var maxSpeed = 100
var falling = true
var fallSpeed = 0
var xDir = 1
var yDir = 1
var yBounce = 0
var xBounce = 0
var spriteDir = 1
var boostTime = 100
var jetOn = 0
var gravOn = 1
var bouncesoundToggle = 0
var xbouncesoundToggle = 0
var boostSound = 0
var attack = 0
var attackTime = 100

#onready var jetPart = $Particles2D
onready var audio = $Sound/AudioStreamPlayer
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rayCast = $RayCast2D
onready var jetNoise = $Sound/jetpackNoise

func _physics_process(delta):
	
	
#Direction
	var xDir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var yDir = (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	
		
	if attack == 0:
	#Ground Movement And Jump
		if rayCast.is_colliding():
		#Refueling Air
			airTank += 0.25
			
		#Jetpack Toggle Off
			if yBounce > 70 || yBounce < -70:
				jetOn = 1
			else:
				jetOn = 0
			
		#Walking And Standing / Friction
			if xDir != 0:
				animationPlayer.play("Run")
				motion.x += xDir * ACCELERATION * delta
				maxSpeed = 64
			else:
				animationPlayer.play("Stand")
				motion.x = lerp(motion.x, 0, FRICTION)
				
		
				
		#Jumping
			if Input.is_action_pressed("ui_select"):
				animationPlayer.play("Jump")
				motion.y = -JUMP_FORCE 
				audio.stream = load("res://Sound/Jump1.wav")
				audio.play()
			
			
			
			
		#Y Bouncing
			if !Input.is_action_pressed("ui_select"):
				if yDir == -1:
					motion.y = yBounce*0.1
					if bouncesoundToggle == 1:
						audio.stream = load("res://Sound/Bouncy1.wav")
						audio.play()
						bouncesoundToggle = 0
				elif yDir == 1:
					animationPlayer.play("Jump")
					motion.y = yBounce*1
					if bouncesoundToggle == 1:
						audio.stream = load("res://Sound/Bouncy1.wav")
						audio.play()
						bouncesoundToggle = 0
				else:
					motion.y = yBounce*0.6
					
					if bouncesoundToggle == 1:
						audio.stream = load("res://Sound/Bouncy1.wav")
						audio.play()
						bouncesoundToggle = 0
					
				
		#Clamp X Speed
			motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
			
			
			
	#Jetpack And Space Movement
		else:
			
		#Toggle Bounce Sound To Avoid Annoyance
			bouncesoundToggle = 1
			
		#Turn On And Off Jetpack
			if Input.is_action_just_pressed("ui_select") && jetOn == 0:
				jetOn = 1
				audio.stream = load("res://Sound/jetOn1.wav")
				audio.play()
	
			
			
		#Set yBounce Value
			yBounce = -motion.y
			
			
		#Jetpack Stuff
			if jetOn == 1:
			#Vertical Jetpack
				if Input.is_action_pressed("ui_select"):	
					animationPlayer.play("Jump")
					motion.y += -JETPACK * delta
					airTank -= 0.05
	#				jetNoise.stream = load("res://Sound/flying1.wav")
	#				jetNoise.play()
				if yDir == -1 && airTank > 0:
					animationPlayer.play("Jump")
					motion.y -= -JETPACK * delta
					airTank -= 0.03
					
			#Horizontal Jetpack
				if xDir != 0 && !Input.is_action_pressed("shift"):
						animationPlayer.play("Jump")
						motion.x += xDir * ACCELERATION * delta * 0.3
						airTank -=0.075 * 0.2
					
					
					
			#Boost
				if Input.is_action_pressed("shift"):
					animationPlayer.play("Glide")
					motion.x += spriteDir * ACCELERATION * delta * boostTime/50
					boostTime -= 0.5
					if boostSound == 1:
						audio.stream = load("res://Sound/boost1.wav")
						audio.play()
						boostSound = 0
					if boostTime > 50:
						airTank -= 0.1 
					else:
						airTank -= 0.1 * boostTime/100
				else:
					boostSound = 1
					
		#Minor Mid-Air Control
			elif jetOn == 0:
				if xDir != 0:
					animationPlayer.play("Run")
					motion.x += xDir * ACCELERATION * delta/3
					
				else:
					animationPlayer.play("Stand")
				if spriteDir == 1 && motion.x > 34:
					motion.x = lerp(motion.x, 34, 0.2)
				elif spriteDir == -1 &&  motion.x < -34:
					motion.x = lerp(motion.x, -34, 0.2)
					
					
		#Horizontal Slowdown
			if spriteDir == 1 && motion.x > 100:
				motion.x = lerp(motion.x, 100, 0.05)
			elif spriteDir == -1 &&  motion.x < -100:
				motion.x = lerp(motion.x, -100, 0.05)
#Spin Attack Controls
	elif attack == 1:
		animationPlayer.play("Spin")
		if rayCast.is_colliding() || is_on_ceiling():
			motion.y = yBounce
			if bouncesoundToggle == 1:
				audio.stream = load("res://Sound/Bouncy1.wav")
				audio.play()
				bouncesoundToggle = 0
			
			
		else:
			yBounce = -motion.y
			bouncesoundToggle = 1
	else:
		animationPlayer.play("Stand")
#Regen Boost
	if !Input.is_action_pressed("shift"):
		boostTime += 0.25

#Attack Boolean
#	if Input.is_action_pressed("q"):
#		attack = 1
#	else:
#		attack = 0

	if Input.is_action_just_pressed("q") && attackTime == 100:
		attack = 1
	if Input.is_action_just_released("q"):
		attack = 0
		animationPlayer.play("Stand")
	if attackTime == 0:
		attack = 0
		animationPlayer.play("Stand")
#
#Attack Time
	if attack == 1:
		attackTime -= 3
	else:
		 attackTime += 3
	
#Gravity
	if gravOn == 1:
		motion.y += GRAVITY * delta
	if Input.is_action_just_pressed("g"):
		gravOn *= -1
	
#Sprite Flip
	if xDir == 1:
		spriteDir = 1
	elif xDir == -1:
		spriteDir = -1
	sprite.flip_h = spriteDir < 0
	emit_signal("TankPressure", airTank)
	
	
#X Bounce
	if is_on_wall():
		if attack == 1:
			motion.x = xBounce
		else:
			motion.x = xBounce*0.5
		spriteDir = spriteDir * -1
		if xbouncesoundToggle == 1:
			audio.stream = load("res://Sound/Bouncy1.wav")
			audio.play()
			xbouncesoundToggle = 0
	else:
		xbouncesoundToggle = 1
		xBounce = -motion.x
	
#Clamp Air Tank, Boost, and Attack Time
	airTank = clamp(airTank, 100, 100)
	boostTime = clamp(boostTime, 0, 100)
	attackTime = clamp(attackTime, 0, 100)
	
#	print (motion)
	print (jetOn)
	
	motion = move_and_slide(motion, Vector2.UP)

