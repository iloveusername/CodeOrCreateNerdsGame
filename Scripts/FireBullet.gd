extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
var death = 0
onready var fireAnim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	fireAnim.play("Fireball")
	death += 1
	if death > 100:
		queue_free()

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		queue_free()
