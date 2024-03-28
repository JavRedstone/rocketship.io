extends Node3D

var planet
var spawners
var has_spawned = false

func _ready():
	planet = get_node("../../Planet")
	spawners = get_parent_node_3d()
	
func _process(_delta):
	if !has_spawned and spawners.CHUNKS.size() > 0:
		spawn_planets()
		has_spawned = true

func spawn_planets():	
	# Chunk-based
	for chunk in spawners.CHUNKS:
		if chunk.objects.size() == 0:
			var probability = randi_range(0, 1000) < 5
			if probability:
				var new_planet = planet.duplicate()
				# anything left and right
				var random_X = randi_range(chunk.forward_left_up.x, chunk.forward_right_up.x)
				# anything down and up
				var random_Y = randi_range(chunk.forward_left_down.y, chunk.forward_left_up.x)
				# anything back and front
				var random_Z = randi_range(chunk.backward_left_up.z, chunk.forward_left_up.z)
				var new_pos = Vector3(random_X, random_Y, random_Z);
				new_planet.position = new_pos
				chunk.objects.append(new_planet)
				add_child(new_planet)
				new_planet.show()
