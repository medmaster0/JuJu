extends Node2D

onready var map = get_parent().find_node("TileMap")

#Movement stuff
var step_tick = 0.5 #time period for each step
var step_timer = 0 #will help keep track of when we stepped
var path = [] #A set of steps to follow in pathfinding (usually set outside)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Add color
	$Sprite.modulate = Color(randf(), randf(), randf())
	
	#JUJU specific
	#Decide gender...
	var gender_id = randi()%2
	if gender_id == 0:
		$Clothes.change_symbol(0)
		$Hat2.change_symbol(0)
	else:
		$Clothes.change_symbol(1)
		$Hat2.change_symbol(1)
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	step_timer = step_timer + delta
	if step_timer > step_tick:
		path_step()
		#update timer
		step_timer = step_timer - step_tick
	
	pass

#A function that takes a step in the stored path
#Returns true if done with path
#Returns false if not
###GOTTA MAKE SURE THIS MAP VARIABLE GETS SET OUTSIDE TOO....
func path_step():
	
	if path.size() == 0:
		return(true) #Do nothing since there are no more steps left
	
	#Take the first Vector2 in the list
	var next_coords = path.pop_front()
	
	#Move the Creature there (remember to convert to world coords from map)
	position = map.map_to_world(next_coords)
	
	return(false)