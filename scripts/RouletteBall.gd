extends Sprite2D

## Roulette Ball's Movement and Behavior.
##
## This script manages the behavior and movement of the roulette ball. It
## calculates the ball's position around the wheel based on its speed and the
## wheel's radius, simulates the ball's deceleration due to friction, and
## determines its stopping position. Additionally, it provides functionalities
## to start the ball's movement, check if it's currently moving, and to adjust
## the ball's speed over time.
##
## Author: Nathan Vincent
## Date: 10/27/2023

var _ball_speed: float = 600  # Speed of the ball in degrees per second
var _is_moving: bool = false  # Whether the ball is moving or still
var _radius: int = 165  # Radius of the wheel's track based on horizontal offset
var _wheel_center: Vector2 = Vector2()  # The center point of the roulette wheel

# Updates the balls rotation, handles its stop condition, and inputs its position into the root node
func _process(delta: float) -> void:
	if _is_moving:
		# Calculate new angle based on the ball's speed
		var angle: float = _ball_speed * delta
		
		# Update the ball's rotation (visual, isn't used for the position calculation)
		rotation_degrees -= angle
		
		position = get_position_from_rotation(rotation_degrees)
		_decrement_speed()
		
		# Stop the ball if its speed drops to 0 or less
		if _ball_speed <= 0:
			_stop_spin()
			var angle_radians: float = position.angle_to(Vector2(1, 0))
			var angle_degrees: float = rad_to_deg(angle_radians)
			if angle_degrees < 0:
				angle_degrees += 360  # Ensure the angle is between 0 and 360 degrees
			get_node("/root/Roulette")._on_ball_stopped(angle_degrees)

# Starts the traversal of the ball
func start_spin(wheel_center_position: Vector2) -> void:
	_set_wheel_center(wheel_center_position)
	_is_moving = true
	_set_random_speed()

# Returns whether the ball is currently moving
func is_moving() -> bool:
	return _is_moving

# Returns the new position based on the angle and the radius from the wheels center
func get_position_from_rotation(rotation_deg: float) -> Vector2:
	var radian_angle = deg_to_rad(rotation_deg)
	return Vector2(cos(radian_angle), sin(radian_angle)) * _radius

# Sets a random speed for the ball
func _set_random_speed() -> void:
	_ball_speed = randf_range(400.0, 850.0) # Will adjust accordingly
	
# Sets the wheels center position
func _set_wheel_center(center_position: Vector2) -> void:
	_wheel_center = center_position

# Stops the balls traversal
func _stop_spin() -> void:
	_is_moving = false

# Decrements the ball's speed over time to simulate friction
func _decrement_speed() -> void:
	# This function can be adjusted to change how quickly the ball slows
	_ball_speed -= 1.25

