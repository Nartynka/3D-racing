extends VehicleBody

var max_rpm = 10000
var max_torque = 100
var is_drifting = false
onready var backLeftWheel = $BackLeftWheel
onready var backRightWheel = $BackRightWheel
onready var frontLeftWheel = $FrontLeftWheel
onready var frontRightWheel = $FrontRightWheel

onready var start_position = global_transform

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("ui_right", "ui_left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("ui_down", "ui_up")
	var rpm = abs(backLeftWheel.get_rpm())
	backLeftWheel.engine_force = acceleration * max_torque * (1-rpm / max_rpm)

	rpm = abs(backRightWheel.get_rpm())
	backRightWheel.engine_force = acceleration * max_torque * (1-rpm / max_rpm)
	# tilt body for effect
	var body_tilt = 35
	var t = -steering * linear_velocity.length() / body_tilt
	$body.rotation.z = lerp($body.rotation.z, t, 10 * delta)
	
	# smoke
	if is_drifting:
		$Smoke.emitting = true
		$Smoke2.emitting = true
	else:
		$Smoke.emitting = false
		$Smoke2.emitting = false

func _input(event):
	if Input.is_action_just_pressed("reset"):
		global_transform = start_position
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
	if Input.is_action_pressed("drift") and Input.is_action_pressed("ui_left"):
		backRightWheel.engine_force = -100
		is_drifting = true
	elif Input.is_action_pressed("drift") and Input.is_action_pressed("ui_right"):
		backLeftWheel.engine_force = -100
		is_drifting = true
	else:
		is_drifting = false
