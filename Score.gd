extends Label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onMobSquashed():
	
	# Increment the score by 1
	score += 1
	
	# Display the text of the score and update it when the player squashes a mob
	text = "Score: %s" % score
