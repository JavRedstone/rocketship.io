extends Node3D

var asteroid
var spawners
var has_spawned = false

func _ready():
	asteroid = get_node("../../Asteroid")
	spawners = get_parent_node_3d()
	
func _process(_delta):
	if !has_spawned and spawners.CHUNKS.size() > 0:
		spawn_asteroids()
		has_spawned = true

func spawn_asteroids():	
	# Chunk-based
	for chunk in spawners.CHUNKS:
		if chunk.objects.size() == 0:
			var probability = randi_range(0, 1000) < 350
			if probability:
				var new_asteroid = asteroid.duplicate()
				# anything left and right
				var random_X = randi_range(chunk.forward_left_up.x, chunk.forward_right_up.x)
				# anything down and up
				var random_Y = randi_range(chunk.forward_left_down.y, chunk.forward_left_up.x)
				# anything back and front
				var random_Z = randi_range(chunk.backward_left_up.z, chunk.forward_left_up.z)
				var new_pos = Vector3(random_X, random_Y, random_Z);
				new_asteroid.position = new_pos
				chunk.objects.append(new_asteroid)
				add_child(new_asteroid)
				new_asteroid.show()
