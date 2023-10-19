import serial
import os

com_port = 'COM7'  # TO-DO, change the com port of the FPGA device
baud_rate = 115200  # Don't change this 

# Open the COM port
ser = serial.Serial(com_port, baud_rate, timeout=1)

if ser.is_open:
    print(f"Connected to {com_port} at {baud_rate} baud\n")

    print("""
=================================================================================================
Welcome to the hardware trojan detection method
=================================================================================================   
    """)

    vInput = 0
    vOutput = 0

    try:
        while True:
            # Send data to the device
            data_to_send = input("Enter data to send: ")
            data_to_send = data_to_send[2:] if data_to_send [0:2] == "0x" else data_to_send
            data_bytes = bytes.fromhex(data_to_send)
            ser.write(data_bytes)


            # Read data from the FPGA
            received_data = ser.read(1) # to-do, change the parameter into the number of bytes needed to read from FPGA
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

