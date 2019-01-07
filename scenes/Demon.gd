extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var primColor 
var secoColor

var demon_name #the name of the demon

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	randomize()
	
	primColor = Color(randf(), randf(), randf())
	get_child(0).modulate = primColor
	secoColor = Color(randf(), randf(), randf())
	get_child(1).modulate = secoColor
	
	#gen name
	demon_name = MedAlgo.genDemonName()
	
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
