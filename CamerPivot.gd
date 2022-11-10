extends Spatial

var direction = Vector3.FORWARD
export(float, 1, 10, 0.1) var smooth_speed = 2.5
onready var car = get_parent()

func _physics_process(delta):
	var current_velocity = car.get_linear_velocity()
	current_velocity.y = 0
	if current_velocity.length() > 1:
		direction = lerp(direction, -current_velocity.normalized(), smooth_speed*delta)
	
	# rotation
	global_transform.basis = get_rotation_from_direction(direction)

func get_rotation_from_direction(look_direction : Vector3) -> Basis:
	look_direction = look_direction.normalized()
	var x_axis = look_direction.cross(Vector3.UP)
	return Basis(x_axis, Vector3.UP, -look_direction)
