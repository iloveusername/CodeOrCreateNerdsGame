extends Sprite

onready var anim = $AnimationPlayer

func _ready():
	anim.play("LOGO")
