extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tile_index #the index of which child/tile is visible

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	tile_index = randi()%1
	#get_child(tile_index).visible = true
	change_symbol(tile_index)
	
	#need to color black
	change_color(Color(randf(), randf(), randf()) , Color(randf(), randf(), randf()) )
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#Function that handles changing of the visibility of the proper tiles
func change_symbol(new_tile_index):
	
	#Turn off old one...
	var temp_color1 = get_child(0).get_child(tile_index).modulate #save the color
	var temp_color2 = get_child(1).get_child(tile_index).modulate #save the color
	
	get_child(0).get_child(tile_index).visible = false
	get_child(1).get_child(tile_index).visible = false
	
	#Change to new one
	tile_index = new_tile_index
	get_child(0).get_child(tile_index).visible = true
	get_child(0).get_child(tile_index).modulate = temp_color1
	
	get_child(1).get_child(tile_index).visible = true
	get_child(1).get_child(tile_index).modulate = temp_color2
	


#function to change the color of the proper tile
func change_color(color1, color2):
	get_child(0).get_child(tile_index).modulate = color1
	get_child(1).get_child(tile_index).modulate = color2