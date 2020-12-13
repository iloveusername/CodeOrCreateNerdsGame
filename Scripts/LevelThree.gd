extends Node2D

func _physics_process(delta):
	var scoreTracker = get_node("ScoreTracker")
	if scoreTracker.complete == 1:
		get_tree().change_scene("res://Scenes/LevelFour.tscn")
