extends CharacterBody3D

# Emitted when the player jumps on the mob
signal squashed

# Minimum speed of the mob
@export var minimumMobSpeed = 10

# Maximum speed of the mob
@export var maximumMobSpeed = 18

func _physics_process(delta):
	
	# Moves the mob by each frame smoothly
	move_and_slide()

# This will be called inside the Main script to include the mob
func InitializeMob(startingMobPosition, playerPosition):
	
	# Place the mob at the starting position and rotate it towards the player's position (to look at the player)
	look_at_from_position(startingMobPosition, playerPosition, Vector3.UP)
	
	# Rotate the mob randomly between -45 degrees and 45 degrees so it doesn't move towards the player directly
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Calculate the random speed by using an int randomizer function and pass in the min and max speeds of the mob
	var randomSpeed = randi_range(minimumMobSpeed, maximumMobSpeed)
	
	# Use forward velocity with the randomized speed
	velocity = Vector3.FORWARD * randomSpeed
	
	# Rotate the velocity based on the mob's y position in order to move it in the mob's looking direction
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	#pass # Replace with function body.
	
	# Delete the instance of the mobs whenever they left the screen
	queue_free()

func MobSquashed():
	
	# Emit the squashed signal and destroy the mob
	squashed.emit()
	queue_free()
