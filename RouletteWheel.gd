extends Sprite2D

# Roulette wheel pockets and their corresponding numbers
const POCKET_COUNT: int = 38
const POCKET_MAP: Array = [
	18, 31, 19, 8, 12, 29, 25, 10, 27, 37, 1, 13, 36, 24, 3, 15, 34, 22, 5,
	17, 32, 20, 7, 11, 30, 26, 9, 28, 0, 2, 14, 35, 23, 4, 16, 33, 21, 6
]  # Array arranged based on wheel's graphic when pocket 00 is element 37.

var _spin_speed: float = 500  # Speed of the spin in degrees per second
var _is_spinning: bool = false  # Whether the wheel is spinning or still

# Updates the wheel's rotation and handles it's stop condition
func _process(delta: float) -> void:
	if _is_spinning:
		rotation_degrees += _spin_speed * delta # Rotate the wheel
		_decrement_speed()
		
		# Stop the wheel if speed drops to 0 or less
		if _spin_speed <= 0:
			_stop_spin()
			# Temporary print function for testing/demonstration purposes
			print("The rightmost pocket of the wheel is: %s" % get_pocket_number(rotation_degrees))

# Starts the spinning of the wheel
func start_spin() -> void:
	_is_spinning = true
	_set_random_speed()  # Randomize the initial spin speed

# Returns whether the wheel is currently spinning
func is_spinning() -> bool:
	return _is_spinning

# Returns the number of the pocket specific in accordance with specific use
func get_pocket_number(degrees: float) -> int:
	var degrees_per_pocket: float = 360.0 / POCKET_COUNT
	var pocket_index: int = int(fmod(degrees, 360.0) / degrees_per_pocket)
	return POCKET_MAP[pocket_index]

# Sets a random speed for the wheel's spin
func _set_random_speed() -> void:
	#Will adjust speed range accordingly
	_spin_speed = randf_range(300.0, 700.0)

# Stops the spinning of the wheel
func _stop_spin() -> void:
	_is_spinning = false

# Decrements the wheel's spin speed over time, simulating friction
func _decrement_speed() -> void:
	# Will expand function to adjust this value for deceleration speed that isn't linear
	_spin_speed -= 1
