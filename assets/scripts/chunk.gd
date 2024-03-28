extends Spawners
class_name Chunk

var pos = Vector3.ZERO
var forward_left_up = Vector3(-1, 1, 1)
var forward_left_down = Vector3(-1, -1, 1)
var forward_right_up = Vector3(1, 1, 1)
var forward_right_down = Vector3(1, -1, 1)
var backward_left_up = Vector3(-1, 1, -1)
var backward_left_down = Vector3(-1, -1, -1)
var backward_right_up = Vector3(1, 1, -1)
var backward_right_down = Vector3(1, -1, -1)
var objects = []

func _init(vec: Vector3, arr: Array = []):
	pos = vec
	forward_left_up = forward_left_up * CHUNK_SIZE / 2 + pos
	forward_left_down = forward_left_down * CHUNK_SIZE / 2 + pos
	forward_right_up = forward_right_up * CHUNK_SIZE / 2 + pos
	forward_right_down = forward_right_down * CHUNK_SIZE / 2 + pos
	backward_left_up = backward_left_up * CHUNK_SIZE / 2 + pos
	backward_left_down = backward_left_down * CHUNK_SIZE / 2 + pos
	backward_right_up = backward_right_up * CHUNK_SIZE / 2 + pos
	backward_right_down = backward_right_down * CHUNK_SIZE / 2 + pos
	objects = arr

func get_objects():
	return objects

func set_objects(arr: Array = []):
	objects = arr
