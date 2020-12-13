extends Node2D

var killCount = 0
var animalCount = 0
var killNeed = 0
var animalNeed = 0
var wait = 0
var complete = 0

func _physics_process(delta):
	wait = wait + 1
	if wait > 100:
		if killCount == killNeed && animalCount == animalNeed:
			killCount = 0
			animalCount = 0
			complete = 1
