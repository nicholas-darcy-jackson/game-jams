extends Control

@export var main : Node3D
var paused = false

func pauseMenu():
	if paused:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true
		
	paused = !paused

func _on_resume_pressed() -> void:
	pauseMenu()

func _on_pause_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
