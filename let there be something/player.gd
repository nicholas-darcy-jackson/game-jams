extends CharacterBody3D

@export var speed: float = 10.0
@export var camera : Camera3D
@export var jump_force: float = 5.0
@export var acceleration: float = 100.0
@export var friction: float = 100.0
@export var push_force: float = 5.0  # Strength of pushing rigidbodies
@export var push_radius: float = 0.5  # How close rigidbodies need to be to be pushed

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
		look_at(Vector3(ray_result.position.x, position.y, ray_result.position.z))
		mouse_location = ray_result.position

func push_rigidbodies(direction):
	# Detect objects within a small radius in front of the player
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.transform = Transform3D(Basis(), global_position + direction * push_radius)
	query.shape = SphereShape3D.new()
	query.shape.radius = push_radius
	query.collide_with_bodies = true
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var body = result.collider
		if body is RigidBody3D:
			var push_dir = (body.global_position - global_position).normalized()
			body.apply_impulse(push_dir * push_force)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("right", "left", "back", "forward")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply acceleration-based movement
	var target_velocity = direction * speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	
	# Apply friction when no input
	if direction == Vector3.ZERO:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
	
	mouse_pointer()
	
	move_and_slide()
	
	# Push rigid bodies if moving
	if direction != Vector3.ZERO:
		push_rigidbodies(direction)
