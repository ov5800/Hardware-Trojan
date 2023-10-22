import serial
import os
import random


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
                        if i == "[":
                            first = True
                        elif i == ":":
                            first = False
                        elif first:
                            wrapperInput += i
                if line[0:6] == "output":            #only want to look at output
                    first = False
                    for i in line[6:]:               #loop through all chars in line
                        if i == "[":
                            first = True
                        elif i == ":":
                            first = False
                        elif first:
                            wrapperOutput += i
            openFile.close()

            wrapperInput = int(wrapperInput) + 1
            wrapperOutput = int(wrapperOutput) + 1
            print(f"Wrapper Input: ", wrapperInput, "bits", int((wrapperInput + 8) / 8), "bytes")
            print(f"Wrapper Output: ", wrapperOutput, "bits", int((wrapperOutput + 8) / 8), "bytes")
    if foundFile == 0:
        print("Wrapper file was not found")
    return wrapperInput, wrapperOutput

def openCOM(bitIn, bitOut):
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
    =================================================================================================
    Welcome to the hardware trojan detection method
    =================================================================================================   
        """)

        try:
            while True:
                # Send data to the device
                for i in range(16):
                    #loop through random inputs
                    num = i * bitIn
                    
                    data_to_send = num
                    data_to_send = data_to_send[2:] if data_to_send [0:2] == "0x" else data_to_send
                    data_bytes = bytes.fromhex(data_to_send)
                    ser.write(data_bytes)
                    outputFile = open("Output.txt", "w")
                    outputFile.write("Input:\t" + str(data_bytes))
                    received_data = ser.read(bitOut)
                    outputFile.write("Output:\t" + str(received_data))


                # Read data from the FPGA
                 # to-do, change the parameter into the number of bytes needed to read from FPGA
                #safe   input = 0xff7fffffff    safe output = 0x07
                #trojan input = 0xff7fffffff  trojan output = 0x27

                # Convert the received bytes to a hexadecimal string
                hex_string = ''.join(f'{byte:02X}' for byte in received_data)

                # Print the received data as a hexadecimal string
                print(f"Received data: 0x{hex_string}")

        except KeyboardInterrupt:
            pass
        finally:
            ser.close()
            print("Connection closed.")
    else:
        print(f"Failed to connect to {com_port}")


if input("File location input output bits: y or n\n") == "y":
    bitIn, bitOut = inOutBits()
else:
    bitIn = input("Bit input:\n")
    bitOut = input("Bit output:\n")
if input("Open COM: y or n\n") == "y":
    openCOM(int(bitIn), int(bitOut))
#look at rtl and use random inputs and store the outputs
#check against 