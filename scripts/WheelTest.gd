extends "res://scenes/CharacterBody2D.gd"  # Update the path

# Test spin functionality
func test_spin():
	print("Running test_spin")
	assert(!spinning)  # Initially not spinning
	_spin()
	assert(spinning)  # Should be spinning after calling _spin()

# Test reset functionality
func test_reset():
	print("Running test_reset")
	reset_wheel()
	assert(!spinning)  # Should not be spinning after reset
	print("hello")

# Test update_segment functionality
func test_update_segment():
	print("Running test_update_segment")
	rotation = $Wheel.rotation_degrees
	$Wheel.rotation_degrees = 90  # Set rotation to a specific value for testing
	update_segment()
	assert(currentSegment == 1)  # Adjust this based on your logic
	$Wheel.rotation_degrees = rotation  # Restore the original rotation

# Test calc functionality
func test_calc():
	print("Running test_calc")
	bet = 10
	calc(bet)
	# Add assertions based on your calc logic
	assert(label1.text == "$5")

# Add more tests as needed

# Run all tests
func run_all_tests():
	test_spin()
	test_reset()
	test_update_segment()
	test_calc()

# Uncomment the line below to run all tests when the script is loaded
#run_all_tests()
