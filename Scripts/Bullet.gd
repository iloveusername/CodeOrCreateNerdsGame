extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
var death = 0


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	death += 1
	if death > 100:
		queue_free()
	print(death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
