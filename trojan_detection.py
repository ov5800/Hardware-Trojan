import serial
import os
import filecmp

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

        try:
            for i in range(16):
                #loop through inputs
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
                data_bytes = bytes.fromhex(num)
                ser.write(data_bytes)
                outputFile = open( golden + "Output.txt", "a")
                outputFile.write("Input:\t" + str(num) + "\n")
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
        if file == "Output.txt":
            output = True
        if file == "goldenOutput.txt":
            golden = True
    if golden & output:
        results = open( "results.txt", "a")
        results.write("Comparing the golden output with the unknown output\n")
        if filecmp.cmp("Output.txt", "goldenOutput.txt"):
            results.write("The unknown bitstream is not a trojan\n")
        else:
            results.write("The unknown bitstream is a trojan\n")
        results.close();
        exit()

#Main function to call all functions
def main():
    compareFiles()
    if input("Do you want to look at a wrapper file for bit lengths? y or n\n") == "y":
        bitIn, bitOut = inOutBits()
    else:
        bitIn = input("Bit input:\n")
        bitOut = input("Bit output:\n")
    if input("Open COM: y or n\n") == "y":
        if input("Is this the golden bitstream: y or n\n") == "y":
            golden = "golden"
        else:
            golden = ""
        openCOM(golden, int(bitIn), int(bitOut))

main()