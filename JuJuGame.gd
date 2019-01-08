extends Node

export (PackedScene) var Angel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#DEBUG: Create a bunch of angels
	for i in range(10):
		var temp_pos = Vector2(5+3*i, 20)
		temp_pos = $TileMap.map_to_world(temp_pos)
		
		var new_angel = Angel.instance()
		new_angel.position = temp_pos
		add_child(new_angel)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
