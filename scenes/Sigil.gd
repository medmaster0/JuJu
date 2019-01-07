extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var vertices = [] #A list of vector2s of points - generated by calling one of the generation functions

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	gen_intelligence_sigil()
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	draw_intelligence_sigil()

#Draws an intelligence-like sigil
#Chooses a series of random vertices from a grid of points
#The grid is the child TileMap
#then connect all the points in order
func gen_intelligence_sigil():
	
	#vvvvvvvvvvvvv Set these parameters vvvvvvvvvvvvvvvvv
	var num_vertices = randi()%4+4 # 4 to 7?
	var grid_size = Vector2(5,5) #the dimensions of the grid from which to choose points from
	
	#Now go and randomly pick the vertices
	for i in range(num_vertices):
		
		#Choose a random point on the grid (based of size)
		var temp_vertex = Vector2(randi()%int(grid_size.x), randi()%int(grid_size.y)) #Random point on the grid
		
		#Add it to the list
		vertices.append(temp_vertex)
		

#Draws the sigil by connecting straight lines between all the stored vertices in vertices[]
func draw_intelligence_sigil():
	#Now Vertices should have random points in it...
	#Draw a line between all the points
	var line_color = Color(0,0,0)
	for v in range(vertices.size()-1):
		#Draw a line between this point and the next
		var first_point = $TileMap.map_to_world(vertices[v])
		var second_point = $TileMap.map_to_world(vertices[v+1])
		draw_line(first_point, second_point,line_color, 1,true)
		
	
	#Also, move sprites to both ends of the sigil
	$Sprite.position = $TileMap.map_to_world(vertices[0])
	$Sprite2.position = $TileMap.map_to_world(vertices[-1])
	
		