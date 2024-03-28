extends Node3D

class_name Spawners

@export var GAME_BORDER = 10000
@export var CHUNK_SIZE = 1000
@export var CHUNKS = []

func _ready():
	for x in range(-GAME_BORDER, GAME_BORDER, CHUNK_SIZE):
		for y in range(-GAME_BORDER, GAME_BORDER, CHUNK_SIZE):
			for z in range(-GAME_BORDER, GAME_BORDER, CHUNK_SIZE):
				var chunk = Chunk.new(Vector3(x, y, z), [])
				if chunk.pos == Vector3(0, 0, 0):
					chunk.objects.append(get_node("../Earth"))
				if chunk.pos == Vector3(1000, 0, 0):
					chunk.objects.append(get_node("../Star"))
				CHUNKS.append(chunk)
		
