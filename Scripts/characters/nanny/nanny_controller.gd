extends CharacterBody3D

# Movement speed
var speed = 5.0

# Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Reference to the animated mesh
@onready var mesh = $Sketchfab_model
@onready var anim_player = $AnimationPlayer

func _physics_process(delta):
	var input_dir = Vector3.ZERO

	# Get input
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()

	# Movement
	if input_dir != Vector3.ZERO:
		# Rotate character toward movement direction
		mesh.rotation.y = atan2(input_dir.x, input_dir.z)
		# Move
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.z * speed

		# Play walking animation
		if not anim_player.is_playing():
			anim_player.play("WALK_2")  # your animation name
	else:
		# Stop movement
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		velocity.z = lerp(velocity.z, 0.0, 0.2)

		# Stop walking animation if idle exists
		if anim_player.is_playing():
			anim_player.stop()  # or play "Idle" if you have an idle animation

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	move_and_slide()
