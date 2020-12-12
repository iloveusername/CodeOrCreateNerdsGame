extends KinematicBody2D

const GRAVITY = 11
const FRICTION = 0.1

var motion = Vector2()
var launchVal = -100
var health = 12
var bulletSpeed = 500
var firebullet = preload("res://Scenes/FireBullet.tscn")

onready var fireAnim = $AnimationPlayer

func _physics_process(delta):
	fireAnim.play("Fire Animation")
	var Player = get_parent().get_node("Player")
	
#Gravity
	motion.x = lerp(motion.x, 0, FRICTION)
	motion.y += GRAVITY
	
	shoot()
	
	move_and_slide(motion)
	
#Death
	if health < 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		var facingDir = get_parent().get_node("Player").facingDir
		motion.x = launchVal*-facingDir*3
		motion.y = launchVal*1.25
		health = health - 4

func shoot():
	var bulletInstance = firebullet.instance()
	bulletInstance.position = get_global_position() + Vector2(15,-15)
	bulletInstance.apply_impulse(Vector2(0,0),Vector2(bulletSpeed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bulletInstance)
