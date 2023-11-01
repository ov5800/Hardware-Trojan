#Just a file to test different stuff


import random

def inputLoop():
	bitIn = 36

	for i in range(bitIn * 100):
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
#print(test_cases)


import difflib

# Function to compare two files and write differing lines to an output file
def compare_files(file1_path, file2_path, output_path):
    with open(file1_path, 'r') as file1, open(file2_path, 'r') as file2:
        lines1 = file1.readlines()
        lines2 = file2.readlines()

        d = difflib.Differ()
        diff = list(d.compare(lines1, lines2))

        with open(output_path, 'w') as output_file:
            for line in diff:
                if line.startswith(' '):
                    # Lines that are the same in both files
                    continue
                elif line.startswith('- '):
                    # Lines that are in the first file but not in the second
                    output_file.write(f'File 1: {line[2:]}')
                elif line.startswith('+ '):
                    # Lines that are in the second file but not in the first
                    output_file.write(f'File 2: {line[2:]}')


# Paths to the two files you want to compare
file1_path = 'file1.txt'
file2_path = 'file2.txt'

# Path to the output file where differing lines will be written
output_path = 'differences.txt'

# Call the function to compare the files
#compare_files(file1_path, file2_path, output_path)



def read_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return lines

def main():
    file1_lines = open("file1.txt", "r").readlines()
    file2_lines = open("file2.txt", "r").readlines()

    with open("results.txt", "w") as output_file:
        inputLine = ""
        for line_num, (line1, line2) in enumerate(zip(file1_lines, file2_lines)):
            if line1.strip() != line2.strip():
                output_file.write(f"\t{inputLine}")
                output_file.write(f"golden{line1}")
                output_file.write(f"\t{line2}\n")
            else:
                 inputLine = line1

def xnor(a, b):
    return not (a ^ b)

def xnor_all_lines(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Initialize result as an empty string
    result = ""

    for line in lines:
        line = line.strip()  # Remove leading/trailing whitespace

        # Check if the line contains only "0" and "1" characters
        if all(bit in "01" for bit in line):
            line_value = line

            if not result:
                # If result is empty, use the first line as the initial result
                result = line_value
            else:
                # Perform XNOR operation on each bit position
                result = "".join("1" if a == b else "0" for a, b in zip(result, line_value))

    return result

# Example usage:
file_path = "xnor.txt"  # Replace with your file path
result = xnor_all_lines(file_path)

if not result:
    print("No valid lines found in the file.")
else:
    print("XNOR result as a bit string:", result)
