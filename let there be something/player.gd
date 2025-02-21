extends CharacterBody3D

@export var speed = 9
@export var camera : Camera3D
@export var jump_speed = 5
@export var push_force = 1

var mouse_location: Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func mouse_pointer():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = ray_origin + camera.project_ray_normal(mouse_pos) * 500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_direction)
	
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if(!ray_result.is_empty()):
		look_at(ray_result.position)
		mouse_location = ray_result.position

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("right", "left", "back", "forward")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
	mouse_pointer()
	
