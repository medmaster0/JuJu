extends Node

#Caclulate the "opposite color"
#This is the color with each of it's rgb channels 128 (or 0.5) away from the color
#ex. (255,108,176) and (128,236,48)
func oppositeColor(in_col):
	
	var r = in_col.r + 0.5
	if r > 1:
		r = r - 1
	var g = in_col.g + 0.5
	if g > 1:
		g = g - 1
	var b = in_col.b + 0.5
	if b > 1:
		b = b - 1
	
	var out_col = Color(r,g,b)
	return out_col
	
	
#Determine which color will better contrast input color:
#Black or White?	
func contrastColor(in_col):
	
	var in_brightness_count = 0 #this will keep track of which channels are bright (over 0.5)
	if in_col.r > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.g > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.b > 0.5:
		in_brightness_count = in_brightness_count + 1
		
	#If the majority of channels are bright, return black (for contrast)
	if in_brightness_count >=2:
		return(Color(0,0,0))
	#Otherwise return white
	else: 
		return(Color(1,1,1))
	
	
#Blend two colors
func blendColor(col1, col2):
	
	var r = (col1.r+col2.r)/2.0
	var g = (col1.g+col2.g)/2.0
	var b = (col1.b+col2.b)/2.0
	return( Color(r,g,b) )
	
#Generate color cycle schema
#These are meant to be moody color that cycle unto each other
#Right now, RANDOM
#eventually more artistic and shit
#Things we can filter:
	#Green? doesn't look good as a sky
	#blue? pure doesn't look good as a sky neither...
	#too much red will get boring, some otherworldy is cool
	# like one or two out of all of them can be freaky, but no more
func colorCycle():
	
	randomize() #randomize just to be safe, fuckhead
	
	var colors = [] #the list of colors that form the cycle
	
	#now add some random colors boyeee
	var cycle_length = randi()%3 + 3
	for i in range(cycle_length):
		colors.append(Color(randf(),randf(), randf()))
	
	return colors
	
#MAYBE TODO????????
#Generates a discrete list of colors to go through
#that slowly changes ino one from the other
#Will list colors to get from color1 to color2, in random RGB increments

#Function that will return a color a step in the "direction" of the other step
func colorTransitionStep(color1,color2):
	
	#Determine how big of steps to adjust each color channel in
	var STEP_SIZE = 0.0125
	
	var temp_color = color1 #the color we'll be returning (will be manipulated but starts at color1)
	
	#We first need to analyze which channels need to go higher or lower
	var shouldGoUp = [] #will hold boolean values indicating if channel should go up or down
	for i in range(3):
		if color1[i] < color2[i]: #If target is greater
			shouldGoUp.append(true)
		else: #then target is lower
			shouldGoUp.append(false)
			
	#Need to pick which channel (R,G, or B) we'll change
	var channel_choice = randi()%3 
	match(channel_choice):
		0:
			#Chose Red
			#Check array for if we should increment or decrement
			if shouldGoUp[0] == true:
				temp_color.r = temp_color.r + STEP_SIZE
			else:
				temp_color.r = temp_color.r - STEP_SIZE
		1:
			#Chose Green
			#Check array for if we should increment or decrement
			if shouldGoUp[1] == true:
				temp_color.g = temp_color.g + STEP_SIZE
			else:
				temp_color.g = temp_color.g - STEP_SIZE
		2:
			#Chose Blue
			#Check array for if we should increment or decrement
			if shouldGoUp[2] == true:
				temp_color.b = temp_color.b + STEP_SIZE
			else:
				temp_color.b = temp_color.b - STEP_SIZE
	
	return(temp_color)




#A STAR FUNCTIONS!!!!
#A* Path Finding 
#returns an array of steps to follow between the two points
#returns (9999,9999) if no path 
#input two vectors you want to search for (global non-tilemap coords)
#
#Also need a tile map that you search on
#
#How it works:
#We have two sets, open and closed set
func find_path(global_start, global_end, tile_map):
	
	#Function vars
	var open_set = []
	var closed_set = []
	var walkable_tiles = [0,1,2,3,4]
	
	#Convert the coordinates to map_coords
	var start = tile_map.world_to_map(global_start)
	var end = tile_map.world_to_map(global_end)

	#Create the FIRST node
	var temp_node = {
		"g" : 0,
		"h" : abs(start.x - end.x) + abs(start.y - end.y),
		"f" : abs(start.x - end.x) + abs(start.y - end.y),
		"coords" : start,
		"last_node" : null
	}
	#And add it to the open_set
	open_set.append(temp_node)
	
	#Now an infinite loop that only breaks once we find our target...
	while(true):
		
		#print(open_set.size())
		
		#EACH ITERATION...
		#find the node in open_set with the least f (next node)
		var least_f = 9999 #temp var to keep track of what the lowest f is
		var next_node #the temp var for the node that has the lowest f
		for node in open_set:
			if node.f <= least_f: #use equals so we get the last one checked (added to open set)
				next_node = node
				least_f = node.f
		#next_node now points to the node with the lowest f
		
		#if there is no next_node (we got through open set), then just exit
		if next_node == null:
			print("got to end of open set and no target")
			return(false)
		
		#remove that node from open_set (so we don't check it again)
		open_set.erase(next_node)
		
		#Now, add each of next_node's neighbors (if walkable)
		#RIGHT
		if tile_map.get_cell(next_node.coords.x+1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x+1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#LEFT
		if tile_map.get_cell(next_node.coords.x-1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x-1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#UP
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y-1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y-1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#DOWN
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y+1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y+1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node, end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#Finally, add the node to the closed set
		closed_set.append(next_node)
			
	#end while - If this while broke, means we found target
	

#A utility function for A* that will reconstruct the path from given node
#Returns a list of steps only 
#array of Vector2
func path_from_set(latest_node, end_coords):
	
	var path_array = [] #The list of coords we'll be returning back
	
	var current_node = latest_node #temp node for interating list
	while(current_node.last_node != null):
		path_array.push_front(current_node.coords)
		current_node = current_node.last_node
		
	path_array.append(end_coords)
		
	return(path_array)
		

#Checks if the input coords (Vector2) have already been entered in the search set
func isVectorInSet(search_coords, search_set):
	
	#Iterate through all the nodes in set
	for node in search_set:
		if search_coords == node.coords: #If the coords match the target
			return(true)
	
	#If it makes it here, not in set
	return(false)
#END A STAR SEARCH AFFILIATED FUNCTIONS
	



#GENERAL FLOOD SEARCH
#POSSIBLY GENERAL USE??? LETS SEE ONCE IMPLEMENTED SINCE IM WRITING THIS BEFORE
#This is a flood search
#Creates a list of nodes
#Nodes have form: (position, distance from target)
func find_tile(global_start, target_tile, tile_map):
	print("him momo")
	
	var walkable_tiles = [0,1,2,3,4]
	
	var search_q = [] #The list of nodes to search through
	var search_index = 0 #Which node in the search queue we are currently searching
	
	#Add First node
	var temp_position = tile_map.world_to_map(global_start)
	var temp_distance = 0
	var temp_node = {
					"coords": temp_position, 
					"distance": temp_distance}
	search_q.append(temp_node)

	#Now iterate the search queue , will have to break out when found target
	while(true):
		
		#get the next node
		var next_node = search_q[search_index]
		
		#Check if that node was the target?!??!
		if tile_map.get_cellv(next_node.coords) == target_tile:
			break
			
		#else, need to add all the other nodes onto search queue
		### ALL ADJACENT NODES
		#LEFT
		if tile_map.get_cell(next_node.coords.x-1, next_node.coords.y) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(-1,0),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#RIGHT
		if tile_map.get_cell(next_node.coords.x+1, next_node.coords.y) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(1,0),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#UP
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y-1) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(0,-1),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#DOWN
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y+1) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(0,1),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#Move on to the next node
		search_index = search_index + 1

	#end while
	print("found target")
	
	#Now need to go through and construct the path back
	var return_path = []
	return_path.push_front(search_q[search_index].coords)
	#cycle through the search_q
	while(search_index != -1):
		#go back down the search_q in reverse
		search_index = search_index - 1
		
		#check if the next tile is within one step of the next return step
		if search_q[search_index].coords.distance_to(return_path[0]) == 1:
			return_path.push_front(search_q[search_index].coords)
		
	
	#return the path
	return(return_path)



#generate a shade of golden yellow (for the perfume gold topper thingy)
func generate_gold():
	
	var r = 0.7 + rand_range(0,0.3)
	#var g = rand_range(0,r)
	var g = rand_range(0.7,r)
	var b = 0
	
	var gold = Color(r,g,b)
	return(gold)
	

#generate a shade of random brown
func generate_brown():
	
	var r = 0.6 + rand_range(0,0.2)
	var g = r - rand_range(0,0.2) - 0.2 #between a fifth and 2 fifths less than r
	var b = rand_range(0,g) #no more than g
	
	var brown = Color(r,g,b)
	return(brown)



#A collection of patterns and stuff made by me, MED

	
#A function for generating a LATIN SQUARE
#Based on the input of a string
#Scrambles up the words
#So that each row and column doesn't repeat letters...
#EX. ABCD
#	 BCDA
#	 CDAB
#	 DABC
#
#EX. MAGIC
#	 AICMG
#	 GCMAI
#	 IGACM
#	 CMIGA

#input: size, n dimension, of the latin square to generate
func latinSquare(num_letters):
	
	var return_square = [] #The grid we'll be returning, a list of list. to access use: (r,c)
	
	#var num_letters = letters.length() #the number of letters/columns/rows/n
	
	#Initialize the grid based on number of letters, n
	for i in num_letters: #the rows
		return_square.append([])
		#Also fill in with a dummy character
		for j in num_letters: #the cols
			return_square[i].append('x')
		
	#Start filling in the shit...
	
	#Row By Row, with an offset
	for i in range(num_letters):
		#Fill in row, with offset
		for j in range(num_letters):
			return_square[i][(i+j)%num_letters] = j
	
	
	#Now... shuffle the rows except the very first one
	for i in range(num_letters - 1):
		
		var row_index = i + 1 #the index of swap row, def not first
		
		#decide if we'll move it
		if randi()%2 == 0:
			#Okay, we'll swap then
			var temp_row = return_square[row_index] #temporarily store what was in there...
			
			#randomly choose another row (not the first)
			var choice_row = 1 + randi()%(num_letters-1)
			
			#Now perform the swap
			return_square[row_index] = return_square[choice_row]
			return_square[choice_row] = temp_row
		
		
	return(return_square)
	

#DEMON NAME GEN
#Follows pattern
# cvc-ending
#x. Gofolas or Jakavos
var demon_name_endings = [ "mon", "ur", "aras", "avos", "olas", "ael", "fas", "has", "ok" ]

func genDemonName():
	#pool of letters we pull from
	var consonants = "bcdfghjklmnpqrstvwxyz"
	var vowels = "aeiou"
	
	var name = "" #the name we return
	
	name = name + consonants[randi()%consonants.length()]
	name = name + vowels[randi()%vowels.length()]
	name = name + consonants[randi()%consonants.length()]
	
	name = name + demon_name_endings[randi()%demon_name_endings.size()]
	
	return(name)
