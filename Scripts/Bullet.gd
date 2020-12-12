extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
var death = 0


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	death += 1
	if death > 100:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if "EnemyFire" in body.name:
		queue_free()
