extends Node

@export var MobScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	
	# Hide the retry text at the start of the game
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	#pass # Replace with function body.
	
	# Create a new instance of the Mob scene
	var mob = MobScene.instantiate()
	
	# Choose a random location on the Mob's spawn path
	var mobSpawnLocation = get_node("SpawnPath/SpawnLocation")
	
	# And give it a random offset
	mobSpawnLocation.progress_ratio = randf()
	
	var playerPosition = $Player.position
	mob.InitializeMob(mobSpawnLocation.position, playerPosition)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
	
	# Connect the mob being squashed signal with the score label of the user interface to update the score each time
	mob.squashed.connect($UserInterface/ScoreLabel.onMobSquashed.bind())


func _on_player_hit():
	#pass # Replace with function body.
	
	# Stops spawning the mob monsters
	$MobTimer.stop()
	
	# Show the retry text on screen
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		
		# Restarts the current scene
		get_tree().reload_current_scene()
