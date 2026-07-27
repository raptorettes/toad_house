extends Node2D

# example of setting tilemap cells to tilemap atlas
 
@onready var water: TileMapLayer = %water
@onready var dark_grass: TileMapLayer = %dark_grass


func _ready() -> void:
	# let's do stuff.
	for i in 100:
		for n in 100:
			water.set_cell(Vector2i(0 + i, 6 + n), 9, Vector2i(2,13))
			#
	#dark_grass.set_cells_terrain_path()
	#dark_grass.set_cells_terrain_connect()
