extends Node3D

@export var player : Node3D
const BIT = preload("res://blocks/bit.tscn")

func spawn_bit():
	# Handle jump.
	if Input.is_action_just_pressed("spawn"):
		print_debug("spawning a bit at ", player.mouse_location)
		var bit = BIT.instantiate()
		bit.position = player.mouse_location
		add_child(bit)
		print_debug("spawned: ", bit)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_bit()
