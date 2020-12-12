extends KinematicBody2D

var shootTime = 0
var bulletSpeed = 200
var firebullet = preload("res://Scenes/FireBullet.tscn")

func _physics_process(delta):
	
	if shootTime > 98:
		shootTime = 0
		shoot()
	shootTime = shootTime + 1
	print(shootTime)


func shoot():
	var bulletInstance = firebullet.instance()
	var Player = get_parent().get_parent().get_node("Player")
	bulletInstance.position = get_global_position() + Vector2(15,-15)
	look_at(Player.position)
	bulletInstance.apply_impulse(Vector2(0,0),Vector2(bulletSpeed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bulletInstance)
