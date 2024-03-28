extends RigidBody3D

# Variables to control movement
var velocity = Vector3.ZERO
var rocket_acceleration = 50.0
var max_speed = 50.0
var damp = 0.1

# Variables to control camera
var camera: Camera3D
var rotation_helper: Node3D
var camera_offset = Vector3(0, 6, 0)
var camera_damp = 0.5
var mouse_captured = true

# Variables to control rocket rotation
var rotation_speed = 5.0
var rotation_damp = 0.5
var target_rotation = Vector3(0, 0, 0)

func _ready():
	camera = $RotationHelper/Camera3D
	rotation_helper = $RotationHelper
	
	rotation_helper.global_transform.origin = camera_offset

	# Set up input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	var delta = get_physics_process_delta_time()
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(-event.relative.y * rotation_speed * delta))
		rotation_helper.rotate_y(deg_to_rad(-event.relative.x * rotation_speed * delta))
		#self.rotate_x(deg_to_rad(-event.relative.y * rotation_speed * delta))
		#self.rotate_y(deg_to_rad(-event.relative.x * rotation_speed * delta))

		target_rotation = rotation_helper.rotation

func _process(_delta):
	# Toggle mouse capture on ESC key press
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	# Get input from keyboard
	var accelerate = Input.get_action_strength("accelerate")

	# Calculate acceleration based on input and velocity
	var acceleration = camera.global_transform.basis.z * accelerate * rocket_acceleration
	velocity = velocity.lerp(velocity + acceleration.normalized() * max_speed * delta, damp)
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	
	# Move the rocket and camera
	global_transform.origin += velocity * delta
	
	var target_pos = global_transform.origin + camera_offset
	camera.global_transform.origin = camera.global_transform.origin.lerp(target_pos, camera_damp)
	
	var look_at_pos_up = global_transform.origin + global_transform.basis.z * 10.0 # Point the camera forward
	var look_at_pos_right = global_transform.origin + global_transform.basis.y * 10.0 # Point the camera left and right
	camera.look_at(look_at_pos_up, Vector3.UP)
	camera.look_at(look_at_pos_right, Vector3.RIGHT)
	camera.rotate_object_local(Vector3.RIGHT, target_rotation.x)
	camera.rotate_object_local(Vector3.UP, target_rotation.y)
