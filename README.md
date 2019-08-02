# MasterThesis
Repository containing all measurement and post analysis scripts for the Master Thesis named "Automotive Energy Harvesting". See ReadMe for further info


Measurement system:
Python script(s) used for an accelerometer measurement system, running from an MPU600 accelerometer and Raspberry pi 3B.

Post-Process:
Post processing scripts for Matlab to calculate time series of measurement data, manipulate sampled data etc.
Implements FFT, PSD and Spectrogram analysis, on the basis of work done by Steve Irvine and the Midè group.


Energy harvester analysis:
Models a piezoelectric energy harvester in LT-Spice by the parameters found the piezoelements datasheet (Mide S129)



Approach:

Run accelerometer measurements with accel_pb_ctrl.py
Output data will be similar as examples given in Datasets folder

Run scripts in Matlab_Post_Process folder.
Import output data
Run time_conv.m
Run Sensordata_map.m
Run vib_time_FFT_mapping.m
Run Vibdata_FFT.m
Run vibdata_Spectrogram.m

Output data will be FFT, PSD and Spectrogram analysis according to the set axis in FFT script.

To run energy harvester modelling simulations:
Run res_freq_calc_masschange.m 
Compare the desired resonance frequency found by FFT or PSD analysis, and select a corresponding mass to correlate with the desired resonance frequency
Component values for resistor and inductor will need to be input to the optimized LTSpice model, while the Voltage Correction Factor will be input to the
Acceldata_txt_write.m script. 
Run Acceldata_txt_write.m scrip with desired voltage correction factor.

Run Piezo_LTC3588__Merc_W212_opti.asc with desired parameters for resistor and inductor for piezo element. 
For ideal cases, the "load matched ideal power" file can be run with similar procedure.

Output data from LTSpice simulations can either be cut directly from LTSpice simulations, or further processed by Matlab.
This is performed by LTspice2Matlab.m, which reads the raw data file from simulations.
NOTE: Time consuming and system demanding!
LTSpice_pre_plot_map.m plots the desired results from the raw data file. 



