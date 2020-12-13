extends Node2D

var killCount = 0
var animalCount = 0


func _physics_process(delta):
	if killCount == 3 && animalCount == 2:
		killCount = 0
		animalCount = 0
		print(killCount)
