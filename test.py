#Just a file to test different stuff


import random

bitIn = 36

for i in range(bitIn):
	#loop through inputs

	num = random.randint(0,2**bitIn-1)
	num = bin(num)[2:]
	#print(num)


	i = hex(i)[2:]
	i = bin(int(i, 16))[2:]
	if len(str(i)) == 1:
		i = "000" + i
	elif len(str(i)) == 2:
		i = "00" + i
	elif len(str(i)) == 3:
		i = "0" + i
	else:
		i = "" + i
	num = ''.join(i * int(bitIn/4))     #make inputs bitIn size
	#print(num)




def generate_test_cases(n, num_test_cases):
    test_cases = []
    max_value = 2 ** n - 1
    for _ in range(num_test_cases):
        # Generate a random integer in the range of 0 to max_value
        random_int = bin(random.randint(0, max_value))[2:]
        test_cases.append(random_int)
    return test_cases

# Set the values for a 36-bit input
n = 36  # 36-bit input
num_test_cases = 10000  # Number of test cases to generate

# Generate pseudo-random test cases
test_cases = generate_test_cases(n, num_test_cases)

# Print the generated test cases
print(test_cases)