extends CharacterBody3D

# How fast the player will be moving
# Again, using @export makes a variable public to Godot's inspector to modify the value
@export var playerSpeed = 14

# The downward acceleration when the player is in the air, falling down
@export var fallAcceleration = 75

# Verical impulse applied to the character upon jumping
@export var jumpImpulse = 20

# Verical impulse applied to the character upon bouncing on another mob enemy
@export var bounceImpulse = 16

# Combines the player speed with the player's direction of movement
# Needs to be a proeprty so that we can reuse this inside of __process function and reuse this acroos multiple frames
var targetVelocity = Vector3(0.0, 0.0, 0.0)

# Update the player's physics on input
func _physics_process(delta):
	# Store the player input direction
	var direction = Vector3.ZERO
	
	# Check which input is being pressed and update the direction based on that input
	if Input.is_action_pressed("MoveRight"): # If the move right input is pressed, move the player to the right
		direction = Vector3(1, 0, 0)
	
	# If the move left input is pressed, move the player to the left
	if Input.is_action_pressed("MoveLeft"):
		direction = Vector3(-1, 0, 0)
	
	# If the move forward input is pressed, move the player forward in z axis
	if Input.is_action_pressed("MoveForward"):
		direction = Vector3(0, 0, -1) # In 3D, the XZ plane is the ground plane
	
	# If the move back input is pressed, move the player back in z axis
	if Input.is_action_pressed("MoveBack"):
		direction = Vector3(0, 0, 1)
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		# Affects the rotation of the node when setting the basis property
		$Pivot.basis = Basis.looking_at(direction)
	
	# Set the ground velocity
	targetVelocity = Vector3(direction.x * playerSpeed, 0, direction.z * playerSpeed)
	
	# Vertical velocity
	if not is_on_floor(): # If in the air, make the player fall towards the floor
		targetVelocity.y = targetVelocity.y - (fallAcceleration * delta)
		
	# Moving the character
	velocity = targetVelocity
	
	# Jumping mechanic
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		targetVelocity.y = jumpImpulse
	
	# Loop through all the collisions occurred this frame
	for index in range(get_slide_collision_count()):
		
		# Get the collision with the player
		var collision = get_slide_collision(index)
		
		# If the collision is with the ground, continue iterating
		if collision.get_collider() == null:
			continue
		
		# If the player collides with the Mob group
		if collision.get_collider().is_in_group("Mob"):
			
			# Get the collider of the Mob node
			var mob = collision.get_collider()
			
			# Check if the player is hitting the mob from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				
				# If true, then squash the mob
				mob.MobSquashed()
				
				# Bounce the player around the screen
				targetVelocity.y = bounceImpulse
				
				# Prevent any duplicate calls to this loop
				break
	
	move_and_slide() # Helps with smooth movement with our character
