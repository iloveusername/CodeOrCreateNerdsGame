extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128
const HEALTH = 12

var motion = Vector2()
var launchVal = -100
var health = 12
var x = 0
var colorThingy = 1
var flash = 0
var flashGo = 0
onready var spriteColor = $Sprite
onready var fireAnim = $AnimationPlayer


func _physics_process(delta):
	fireAnim.play("Fire Animation")
	var Player = get_parent().get_node("Player")
	var scoreTracker = get_parent().get_node("ScoreTracker")
	
	
	
#Sprite Color Stuff
	if flashGo == 1:
		spriteColor.self_modulate = Color(100, 100, 100)
		flash = flash + 1
	if flash > 12:
		spriteColor.self_modulate = Color(1, 1, 1)
		flashGo = 0
		flash = 0
		

#Health Sprite
	if health > HEALTH*0.8:
		fireAnim.play("100%")
	elif health > HEALTH*0.6:
		fireAnim.play("80%")
	elif health > HEALTH*0.4:
		fireAnim.play("60%")
	elif health > HEALTH*0.2:
		fireAnim.play("40%")
	elif health > HEALTH*0:
		fireAnim.play("20%")

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
	motion = move_and_slide(motion, Vector2.UP)
	
#Death
	if health < 0:
		scoreTracker.killCount = scoreTracker.killCount + 1
		queue_free()
	


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		var Player = get_parent().get_node("Player")
		var facingDir = get_parent().get_node("Player").facingDir
		motion.x = launchVal*-facingDir*3
		motion.y = launchVal*1.25
		flashGo = 1
		health = health - Player.randomDamage

func _ready():
	var scoreTracker = get_parent().get_node("ScoreTracker")
	scoreTracker.killNeed = scoreTracker.killNeed + 1
