extends StaticBody3D

@export var gridmap : GridMap


var velocity = Vector3(250,250,250)

func destroy_bit(entity):
	
	print_debug("bit has just been destroyed at: ", entity.position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_point = collision_info.get_position()
