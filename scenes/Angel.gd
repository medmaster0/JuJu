extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Color the sprites
	#$Sprite.modulate = MedAlgo.generate_gold()
	#$Sprite.modulate = Color(1,0.9,0.1)
	$Sprite.modulate = MedAlgo.generate_hair_color()
	#$Sprite2.modulate = MedAlgo.generate_brown()
	$Sprite2.modulate = MedAlgo.generate_skin_color()
	#$Sprite3.modulate = Color(randf(), randf(), randf())
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
