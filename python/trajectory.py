import json
import serial
import time

# Define the runtime of the script in seconds
runtime = 60

# Open the serial connection
ser = serial.Serial('COM5', 9600) # Replace with your serial port and baud rate

# Create an empty list to store the JSON data
json_data = []

# Set the start time of the script
start_time = time.time()

# Read the JSON data from the serial connection for the specified duration
while (time.time() - start_time) < runtime:
    data = ser.readline()
    try:
        json_obj = json.loads(data)
        json_data.append(json_obj)
        
    except:
        pass
    with open('trajectory.txt', 'w') as f:
        json.dump(json_data, f)
    
# Close the serial connection
ser.close()

# Save the JSON data to a file
#with open('trajectory.txt', 'w') as f:
#    json.dump(json_data, f)
#json_data
