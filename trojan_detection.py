import serial
import os
import math
import random

def introPrint():
    print("""
    Welcome to
    ==================================================================================================
    |     _______________                                                                            |
    |            |                                                                                   |
    |            |                                       *                                           |
    |            |                    _____                       _____          |   __              |
    |            |       |  __       /     \             |             \         | /    \            |
    |            |       |/   \     |       |            |        ______|        |/      \           |
    |            |       |          |       |            |       /      |        |       |           |
    |            |       |           \_____/         \___/       \_____/|        |       |           |
    =================================================================================================
    detection
        """)

#Find how many input and output bits are in the provided Wrapper.v
def inOutBits():
    wrapperInput = ""
    wrapperOutput = ""

    foundFile = 0
    path = input("Enter file location:\n")
    for file in os.listdir(path):                   #all files in path
        #print(file)
        if file == "wrapper.v":                     #looking for the wrapper file
            foundFile = 1
            print("Found wrapper file")
            openFile = open(path + file)
            for line in openFile:                   #loop through all lines in the file
                if line[0:5] == "input":            #only want to look at input
                    first = False
                    for i in line[5:]:              #loop through all chars in line
                        if i == "[":                #only want the numbers between '[' and ':'
                            first = True
                        elif i == ":":
                            first = False
                        elif first:
                            wrapperInput += i
                if line[0:6] == "output":           #only want to look at output
                    first = False
                    for i in line[6:]:              #loop through all chars in line
                        if i == "[":                #only want the numbers between '[' and ':'
                            first = True
                        elif i == ":":
                            first = False
                        elif first:
                            wrapperOutput += i
            openFile.close()

            wrapperInput = int(wrapperInput) + 1    #7 downto 0 is 8 bits
            wrapperOutput = int(wrapperOutput) + 1
            print(f"Wrapper Input: ", wrapperInput, "bits", int((wrapperInput + 8) / 8), "bytes")   #bit to byte conversion
            print(f"Wrapper Output: ", wrapperOutput, "bits", int((wrapperOutput + 8) / 8), "bytes")
    if foundFile == 0:
        print("Wrapper file was not found")
        exit()
    return wrapperInput, wrapperOutput

#Open the COM port on the Basys3 and write inputs to it
def openCOM(golden, bitIn, bitOut):
    com_port = 'COM7'  # TO-DO, change the com port of the FPGA device
    baud_rate = 115200  # Don't change this 
    try:
        # Open the COM port
        ser = serial.Serial(com_port, baud_rate, timeout=1)
    except serial.serialutil.SerialException:
        print( "The COM port cannot be opened" )
        exit()

    if ser.is_open:
        print(f"Connected to {com_port} at {baud_rate} baud\n")
        try:
            goldenFileLine = 0
            for _ in range(bitIn * 100):
                #loop through inputs

                if( golden == "golden" ):
                    testNum = bin(random.randint(0,2**bitIn-1))[2:]
                    #while len(testNum) < (math.ceil(bitIn / 8) * 8):
                    #    testNum = '0' + testNum
                    #print("padded testNum, length = " + str(len(testNum)) + ", testNum = " + str(testNum))
                            
                    #print(testNum)
                else:
                    goldenOutputFile = open("goldenOutput.txt")
                    goldenOutputFile.seek(goldenFileLine)
                    goldenNum = goldenOutputFile.readline()
                    #print("xxx" + goldenNum[0:6] + "xxx")
                    while goldenNum[0:6] != "Input:":
                        goldenNum = goldenOutputFile.readline()
                    testNum = goldenNum[7:-1]
                    goldenOutputFile.readline()
                    goldenFileLine = goldenOutputFile.tell()

                    #0000 0000 0101 0000 1011 0100 1101 0010 0001 0101 0111 0111
                    #0000 0000 1000 0011 0011 0011 0010 1110 1001 0100 0011 1100
                    #  0    0   8    3     3    3    2    e    9    4    3    c
                    #0000 0000 0101 001000110001011110111110100011011010
                hexTestNum = hex( int(testNum, 2) )[2:].zfill(int((math.ceil(bitIn / 8) * 8)/4))
                print(hexTestNum)
                data_bytes = bytes.fromhex(hexTestNum)
                ser.write(data_bytes)
                outputFile = open( golden + "Output.txt", "a")
                outputFile.write("Input:\t" + str(bin(int(hexTestNum, 16))[2:].zfill((math.ceil(bitIn / 8) * 8))) + "\n")
                received_data = ser.read(int((bitOut+8)/8))

                # Convert the received bytes to a hexadecimal string
                hex_string = ''.join(f'{byte:02X}' for byte in received_data)

                # Print the received data as a hexadecimal string
                #print(f"Received data: 0x{hex_string}")
                outputFile.write("Output:\t0x" + hex_string + "\n\n")
                outputFile.close()
            #safe   input = 0xff7fffffff    safe output = 0x07
            #trojan input = 0xff7fffffff  trojan output = 0x27

        except KeyboardInterrupt:
            pass
        finally:
            ser.close()
            print("Connection closed.")
    else:
        print(f"Failed to connect to {com_port}")

#Compare the two files
def compareFiles():
    output = False
    golden = False
    for file in os.listdir("./"):
        if file[1:] == "Output.txt":
            output = True
        if file == "goldenOutput.txt":
            golden = True
    if golden & output:
        print("Comparing the golden output with the unknown output\n")
        
        file1_lines = open("goldenOutput.txt", "r").readlines()
        file2_lines = open("Output.txt", "r").readlines()
        xnor = open("xnor.txt", "w")

        with open("results.txt", "w") as output_file:
            inputLine = ""
            for line_num, (line1, line2) in enumerate(zip(file1_lines, file2_lines)):
                if line1.strip() != line2.strip():
                    output_file.write(f"\t{inputLine}")
                    output_file.write(f"golden{line1}")
                    output_file.write(f"\t\t{line2}\n")
                    xnor.write(inputLine[7:])               #this file stores all the values to xnor
                    
                else:
                    inputLine = line1
        exit()

#Main function to call all functions
def main():
    introPrint()
    if input("Do you want to look at a wrapper file for bit lengths? y or n\n") == "y":
        bitIn, bitOut = inOutBits()
    else:
        bitIn = input("Bit input:\n")
        bitOut = input("Bit output:\n")
    if input("Open COM: y or n\n") == "y":
        if input("Is this the golden bitstream: y or n\n") == "y":
            golden = "golden"
        else:
            numFiles = input("How many files to test?\n")
            if numFiles == 1:
                golden = ""
            else:
                golden = numFiles
        openCOM(golden, int(bitIn), int(bitOut))
        if input("All files? y/?") == "y":
            compareFiles()

main()