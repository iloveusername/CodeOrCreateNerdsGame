extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 100
const FRICTION = 0.1
const AIR_RESISTENCE = 0.02
const GRAVITY = 11
const JUMP_FORCE = 300
const XKICKBACK = 500
const ENEMYKICKBACK = 500

var motion = Vector2.ZERO
var maxSpeed = 200
var xDir = 1
var yDir = 1
var jumpReady = 1.1
var facingDir = 1
var bulletSpeed = 500
var bullet = preload("res://Scenes/Bullet.tscn")
var shootRefresh = 100
var charge = 0
var healthCount = 100
var healthTake
var POS = get_global_transform()
var animalScore = 0
var flash = 0
var flashGo = 0
var randomDamage = 0

onready var waterAnim = $WaterDropAnim
onready var playerAnim = $AnimationPlayer
onready var charColor = $CharSprite


func _physics_process(delta):
	var scoreTracker = get_parent().get_node("ScoreTracker")

#Direction
	var xDir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var yDir = (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	
#Player Animations
	if xDir != 0:
		if xDir > 0:
			playerAnim.play("Walk Right")
		if xDir < 0:
			playerAnim.play("Walk Left")
	elif facingDir == 1:
		playerAnim.play("Stand Right")
	elif facingDir == -1:
		playerAnim.play("Stand Left")
		
#HitFlash
	if flashGo == 1:
		charColor.self_modulate = Color(100, 100, 100)
		flash = flash + 1
	if flash > 12:
		charColor.self_modulate = Color(1, 1, 1)
		flashGo = 0
		flash = 0	
	
#X Motion
	if xDir != 0:
		motion.x += xDir * ACCELERATION * delta
	else:
		motion.x = lerp(motion.x, 0, FRICTION)
	
#Clamp X Speed
	motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
	
#Y Motion
	if is_on_floor() || is_on_wall():
		if Input.is_action_pressed("ui_select") && jumpReady > 1:
			jumpReady = 0
			motion.y = -JUMP_FORCE 
			
#Jump Refresh
	if jumpReady != 1:
		jumpReady += 0.05
		
#Gravity
	motion.y += GRAVITY
	
#Sprite Flip
	if xDir == 1: 
		facingDir = 1
		
	elif xDir == -1:
		facingDir = -1
		
		
#WaterDropSprite
	if charge == 0:
		waterAnim.play("0 Charge")
	if charge == 20:
		waterAnim.play("20")
	if charge == 40:
		waterAnim.play("40")
	if charge == 60 :
		waterAnim.play("60")
	if charge == 80:
		waterAnim.play("80")
		
#Random Number Test

	randomDamage = randi() % 6 + 3
	if Input.is_action_just_pressed("ui_up"):
		var ranDom = randi() % 20
		print(ranDom)
		
#Shooting
	if Input.is_action_pressed("LMB"):
		charge += 2
	else:
		charge -= 2

	if charge >= 98 && shootRefresh == 100:
		shootRefresh = 0
		charge = 0
		shoot()
		motion.x += XKICKBACK*-facingDir
		
	if shootRefresh != 100:
		shootRefresh += 1
		
#Health
	if healthCount < 0:
		get_tree().reload_current_scene()
		
		
		
	shootRefresh = clamp(shootRefresh, 0, 100)	
	charge = clamp(charge, 0, 100)
		
	motion = move_and_slide(motion, Vector2.UP)

	
#Bullet Stuff
func shoot():
	var bulletInstance = bullet.instance()
	bulletInstance.position = get_global_position() + Vector2(15*facingDir,-15)
	bulletInstance.apply_impulse(Vector2(0,0),Vector2(bulletSpeed * facingDir, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bulletInstance)
	
func _on_Area2D_body_entered(body):
	var scoreTracker = get_parent().get_node("ScoreTracker")
	if "EnemyFire" in body.name:
		healthCount = healthCount-10
		hit_knockback()
	if "FireThing" in body.name:
		healthCount = healthCount-10
		hit_knockback()

func hit_knockback():
	motion.x = -ENEMYKICKBACK * facingDir
	motion.y = -ENEMYKICKBACK/3
	flashGo = 1


