
#!/usr/bin/python
import smbus
import math
import csv
import time
import sys
import datetime
import RPi.GPIO as GPIO
import os
import thread
import timeit


# Register addresses
power_mgmt_1 = 0x6b
power_mgmt_2 = 0x6c
samplerate_divider = 0x19
accel_config = 0x1C
I2C_mast_ctrl = 0x24
Mot_Det_Ctrl = 0x69
INT_Enable = 0x38

#Enable analog GPIO pins for LED control and push button ctrl
GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(24, GPIO.IN, pull_up_down=GPIO.PUD_UP)

GPIO.setwarnings(False)
GPIO.setup(17, GPIO.OUT)
GPIO.setup(27, GPIO.OUT)

GPIO.output(17, GPIO.HIGH)
GPIO.output(27, GPIO.HIGH)
time.sleep(2)
GPIO.output(17, GPIO.LOW)
GPIO.output(27, GPIO.LOW)


accel_status = 0
green_led_status=False
 
def start_meas_callback(channel):
	global accel_status
	accel_status = 1
	print "Starting accelerometer measurements, logging to CSV file"
	#csv_open()
	#csv_write('Time', 'X_Axis', 'Y_Axis', 'Z_Axis')
	
	GPIO.output(17, GPIO.HIGH)
	GPIO.output(27, GPIO.HIGH)

GPIO.add_event_detect(23, GPIO.FALLING, callback=start_meas_callback, bouncetime=300)


def stop_meas_callback(channel):
	global accel_status
	global green_led_status
	accel_status = 0
	print "Accelerometer measurements stopped, written to CSV file"
	#Closing csv file
	csv_close()
	GPIO.output(17, GPIO.HIGH)
	GPIO.output(27, GPIO.HIGH)
	time.sleep(1)
	GPIO.output(27, GPIO.LOW)
	time.sleep(2)
	GPIO.output(17, GPIO.LOW)

GPIO.add_event_detect(24, GPIO.FALLING, callback=stop_meas_callback, bouncetime=300)



 
def read_byte(reg):
    return bus.read_byte_data(address, reg)
 
def read_word(reg):
    h = bus.read_byte_data(address, reg)
    l = bus.read_byte_data(address, reg+1)
    value = (h <<8)+l
    return value
 
def read_word_2c(reg):
    val = read_word(reg)
    if (val >= 0x8000):
        return -((65535 - val) + 1)
    else:
        return val


csvwriter = None
filename_total =0
filepath_merge = 0 

def csv_open():

	global filename_total
	global filepath_merge

	filename_time_raw = datetime.datetime.now()
	filename_time=filename_time_raw.strftime('%y-%m-%d--%H:%M:%S')
	filename_total='accel-data-'+filename_time+'.csv'
	filepath = os.path.dirname(os.path.abspath(filename_total))
	print "Absolute filepath"
	print filepath
	filepath_merge = os.path.join(filepath, filename_total)
	print "Merged filepath"
	print filepath_merge

	csvfile = open(filepath_merge, 'a')
	global csvwriter
	csvwriter = csv.writer(csvfile)

def csv_close():

	global csvwriter
	global filepath_merge
	with open(filepath_merge, 'a') as csvfile:
		csvwriter.writerow(['File close',' file close',' file close',' file close'])
                

def csv_write(timedelta, accelerometerx, accelerometery, accelerometerz):
	global csvwriter
	csvwriter.writerow([timedelta,  accelerometerx, accelerometery, accelerometerz])


accel_list=[]

def csv_write_list(accel_list_inp):
        global csvwriter
                
        csvwriter.writerows(accel_list_inp)
                



def list_ext(timedelta_lst, accelerometerx_lst, accelerometery_lst, accelerometerz_lst):
        accel_list.extend([[timedelta_lst, accelerometerx_lst, accelerometery_lst, accelerometerz_lst]])
#        print (accel_list)





 
bus = smbus.SMBus(1) # bus = smbus.SMBus(1) 
address = 0x69       # via i2cdetect


 
# Power management settings
bus.write_byte_data(address, power_mgmt_1, 0)
bus.write_byte_data(address, power_mgmt_2, 0x00)


#Configure sample-rate divider

bus.write_byte_data(address, samplerate_divider, 0x0C)

#Configre DLPF frequency
bus.write_byte_data(address, 0x1A, 0x0)


#Configure data ready interrupt:
bus.write_byte_data(address,INT_Enable, 0x01) 


#Opening csv file and getting ready for writing
csv_open()

csv_write('Time', 'X_Axis', 'Y_Axis', 'Z_Axis') 

 
#gyroskop_xout = read_word_2c(0x43)
#gyroskop_yout = read_word_2c(0x45)
#gyroskop_zout = read_word_2c(0x47)
 
#print "gyroskop_xout: ", ("%5d" % gyroskop_xout), " skaliert: ", (gyroskop_xout / 131)
#print "gyroskop_yout: ", ("%5d" % gyroskop_yout), " skaliert: ", (gyroskop_yout / 131)
#print "gyroskop_zout: ", ("%5d" % gyroskop_zout), " skaliert: ", (gyroskop_zout / 131)

print
print "Accelerometer"
print "---------------------"


print "Please push button 1 to start logging accelerometer data "
print "Push button 2 to stop logging accelerometer data"
print "Writing data to array"

accel_cnt_led=0


while True:


	if accel_status == 1:
	 
		data_interrupt_read =  bus.read_byte_data(address, 0x3A)

		if data_interrupt_read == 1:

 
			meas_time = datetime.datetime.now()
#		delta_time = meas_time - starttime


#		accelerometer_xout = read_word_2c(0x3b)
#		accelerometer_yout = read_word_2c(0x3d)
#		accelerometer_zout = read_word_2c(0x3f)

			accelerometer_xout = read_word(0x3b)
			accelerometer_yout = read_word(0x3d)
			accelerometer_zout = read_word(0x3f)

#		accelerometer_xout_scaled = accelerometer_xout / 16384.0
#		accelerometer_yout_scaled = accelerometer_yout / 16384.0
#		accelerometer_zout_scaled = accelerometer_zout / 16384.0
# 	meas_2 = datetime.datetime.now()
#	delta_2 = meas_2 - starttime
	
#	print "accelerometer_xout: ", ("%6d" % accelerometer_xout), " scaled: ", accelerometer_xout_scaled 
#	print "accelerometer_yout: ", ("%6d" % accelerometer_yout), " scaled:  ", accelerometer_yout_scaled 
#	print "accelerometer_zout: ", ("%6d" % accelerometer_zout), " scaled:  ", accelerometer_zout_scaled 
 
#	print "X Rotation:  " , get_x_rotation(accelerometer_xout_scaled, accelerometer_yout_scaled, accelerometer_zout_scaled)
#	print "Y Rotation:  " , get_y_rotation(accelerometer_xout_scaled, accelerometer_yout_scaled, accelerometer_zout_scaled)
#	print "Time:        " , delta_time

#		csv_write(meas_time, accelerometer_xout_scaled, accelerometer_yout_scaled, accelerometer_zout_scaled)

			#csv_write(meas_time, accelerometer_xout, accelerometer_yout, accelerometer_zout)

                        list_ext(meas_time, accelerometer_xout, accelerometer_yout, accelerometer_zout)
                if len(accel_list) == 615:
                               # print "LIST LIST LIST LIST LIST LIST LIST LIST"
                                #print " \n \n \n \n \n \n "
                        csv_write_list(accel_list)
                        #timeit.timeit(setup=csv_write_list(accel_list), number=1)
                      #print accel_list
                        GPIO.output(27, GPIO.LOW)
                        GPIO.output(27, green_led_status)
                        green_led_status = not green_led_status
                        accel_list[:]=[]
                                

                        
                

                     		
#		csv_write(meas_time, accelerometer_xout_scaled)
#	delete_last_line()
	#time.sleep(1)

		




	continue
