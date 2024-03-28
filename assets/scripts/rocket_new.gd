extends RigidBody3D

# Input constants
const ROTATION_SPEED = 0.01

const INPUT_LEFT = Vector3(0, 0, 1)
const INPUT_RIGHT = Vector3(0, 0, -1)
const INPUT_UP = Vector3(1, 0, 0)
const INPUT_DOWN = Vector3(-1, 0, 0)

const FRONT_THRUST = 30
const BACK_THRUST = 10
const MAX_FORWARD = 50
const MAX_BACKWARD = 20

var collision_shape
var rotation_helper
var particle_emitter1
var particle_emitter2

var camera
var camera_option = 2
var camera_pos_fpv = Vector3(0, 3, 0)
var camera_rot_fpv = Vector3(90, 0, 0)
var camera_pos_back = Vector3(0, -10, 0)
var camera_rot_back = Vector3(90, 0, 0)
var camera_pos_front = Vector3(0, 10, 0)
var camera_rot_front = Vector3(-90, 0, 0)

func _ready():
	collision_shape = $CollisionShape3D
	rotation_helper = $rotation_helper
	camera = $rotation_helper/Camera3D
	particle_emitter1 = $rotation_helper/yellow
	particle_emitter2 = $rotation_helper/gray
	
	if camera_option == 0:
		camera.position = camera_pos_fpv
		camera.rotation = camera_rot_fpv
	elif camera_option == 1:
		camera.position = camera_pos_back
		camera.rotation = camera_rot_back
	else:
		camera.position = camera_pos_front
		camera.rotation = camera_rot_front

func _process(delta):
	var brake = false
	# Handle input
	var current_linear_speed = linear_velocity.length()
	var input_dir = Vector3.ZERO
	var thrust_dir = collision_shape.transform.basis.y
	var rot = collision_shape.rotation
	if Input.is_action_pressed("left"):
		input_dir += INPUT_LEFT
	if Input.is_action_pressed("right"):
		input_dir += INPUT_RIGHT
	if Input.is_action_pressed("up"):
		input_dir += INPUT_UP
	if Input.is_action_pressed("down"):
		input_dir += INPUT_DOWN
	if Input.is_action_pressed("brake"):
		brake = true
	if Input.is_action_pressed("accelerate"):
		linear_velocity += thrust_dir * FRONT_THRUST * delta
		if current_linear_speed > MAX_FORWARD:
			linear_velocity = linear_velocity.normalized() * MAX_FORWARD
		particle_emitter1.emitting = true  # Emit particles when accelerating
		particle_emitter2.emitting = false 
	else:
		particle_emitter1.emitting = false
		particle_emitter2.emitting = true
	if Input.is_action_pressed("decelerate"):
		linear_velocity -= thrust_dir * BACK_THRUST * delta
		if current_linear_speed < -MAX_BACKWARD:
			linear_velocity = linear_velocity.normalized() * -MAX_BACKWARD
	if Input.is_action_just_pressed("perspective"):
		if camera_option == 0:
			camera_option = 1
		elif camera_option == 1:
			camera_option = 2
		else:
			camera_option = 0
			
		if camera_option == 0:
			camera.position = camera_pos_fpv
			camera.rotation = camera_rot_fpv
		elif camera_option == 1:
			camera.position = camera_pos_back
			camera.rotation = camera_rot_back
		else:
			camera.position = camera_pos_front
			camera.rotation = camera_rot_front
	
		# Stop the rocket on collision
	if get_contact_count() > 0:
		self.hide()
		# queue_free is very important to change hitboxes
		self.queue_free()
		linear_velocity = Vector3.ZERO
	
	rot = input_dir * ROTATION_SPEED
	
	if input_dir != Vector3.ZERO:
		# Apply the rotation around the appropriate axis using rotate_object_local
		rotation_helper.rotate_object_local(input_dir.normalized(), rot.length())
		collision_shape.rotate_object_local(input_dir.normalized(), rot.length())

	contact_monitor = true

	if brake:
		linear_velocity = lerp(linear_velocity, Vector3(0, 0, 0), 0.1)
		
	# if Input.is_action_just_pressed("fire"):
	#	var bullet = Bullet.instance()
	#	bullet.global_transform = global_transform
	#	get_parent().add_child(bullet)
	
# A simple bullet class
# class_name Bullet
# extends RigidBody3D

# const SPEED = 500

# func _ready():
# 	apply_impulse(Vector3.ZERO, transform.basis.z * SPEED)
