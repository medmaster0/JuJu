extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Preload all the hat textures
var hat_tex1 = preload("res://tiles/hats/bandanaPrim.png")
var hat_tex2 = preload("res://tiles/hats/bandanaSeco.png")
var hat_tex3 = preload("res://tiles/hats/bowPrim.png")
var hat_tex4 = preload("res://tiles/hats/bowSeco.png")
var hat_tex5 = preload("res://tiles/hats/capPrim.png")
var hat_tex6 = preload("res://tiles/hats/capSeco.png")
var hat_tex7 = preload("res://tiles/hats/crownPrim.png")
var hat_tex8 = preload("res://tiles/hats/crownSeco.png")
var hat_tex9 = preload("res://tiles/hats/hoodPrim.png")
var hat_tex10 = preload("res://tiles/hats/hoodSeco.png")
var hat_tex11 = preload("res://tiles/hats/mohawkPrim.png")
var hat_tex12 = preload("res://tiles/hats/mohawkSeco.png")
var hat_tex13 = preload("res://tiles/hats/tophatPrim.png")
var hat_tex14 = preload("res://tiles/hats/tophatSeco.png")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Give Sprite color
	$Sprite.modulate = Color(randf(), randf(), randf())
	$Sprite2.modulate = Color(randf(), randf(), randf())
	
	#Randomly set the texture of the sprites...
	var hat_index = randi()%7
	match(hat_index):
		0:
			$Sprite.set_texture(hat_tex1)
			$Sprite2.set_texture(hat_tex2)
		1:
			$Sprite.set_texture(hat_tex3)
			$Sprite2.set_texture(hat_tex4)
		2:
			$Sprite.set_texture(hat_tex5)
			$Sprite2.set_texture(hat_tex6)
		3:
			$Sprite.set_texture(hat_tex7)
			$Sprite2.set_texture(hat_tex8)
		4:
			$Sprite.set_texture(hat_tex9)
			$Sprite2.set_texture(hat_tex10)
		5:
			$Sprite.set_texture(hat_tex11)
			$Sprite2.set_texture(hat_tex12)
		6:
			$Sprite.set_texture(hat_tex13)
			$Sprite2.set_texture(hat_tex14)
			
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
