import os

wrapperInput = ""
wrapperOutput = ""

path = input("Enter file location:\n")
for file in os.listdir(path):                   #all files in path
	if file == "wrapper.v":                     #looking for the wrapper file
		openFile = open(file)
		for line in openFile:                   #loop through all lines in the file
			if line[0:5] == "input":            #only want to look at input
				first = False
				for i in line[5:]:                  #loop through all chars in line
					if i == "[":
						first = True
					elif i == ":":
						first = False
					elif first:
						wrapperInput += i
			if line[0:6] == "output":            #only want to look at output
				first = False
				for i in line[6:]:                  #loop through all chars in line
					if i == "[":
						first = True
					elif i == ":":
						first = False
					elif first:
						wrapperOutput += i
		openFile.close()

wrapperInput = int(wrapperInput) + 1
wrapperOutput = int(wrapperOutput) + 1
print(f"Wrapper Input: ", wrapperInput)
print(f"Wrapper Input Bytes: ", int((wrapperInput + 8) / 8 ))
print(f"Wrapper Output: ", wrapperOutput)
print(f"Wrapper Output Bytes: ", int((wrapperOutput + 8) / 8))


