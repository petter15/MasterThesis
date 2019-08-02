%Extract sensor data into separate columns

%Sens_data_ADC=table2array(acceldatawindow(:,2:4));

if N_fft_size(1,1) >= N_wanted_size
    %Sens_data_X= table2array(acceldatawindow(1:size_sample_set,2));
    %Sens_data_Y= table2array(acceldatawindow(1:size_sample_set,3));
    %5Sens_data_Z= table2array(acceldatawindow(1:size_sample_set,4));
    
    Sens_data_X= table2array(acceldatawindow(1:wanted_sample_size,2));
    Sens_data_Y= table2array(acceldatawindow(1:wanted_sample_size,3));
    Sens_data_Z= table2array(acceldatawindow(1:wanted_sample_size,4));
    %time_scope_shifted(wanted_sample_size+1:,1)=[];
    %time_scope_shifted(wanted_sample_size+1:length(time_scope_shifted),1)=[];
    
    fprintf('Sample data shorted, samples left to process: Approx %f seconds ', samples_left);
    
elseif N_fft_size(1,1) < N_wanted_size
    
    %Pad zero's to dataset to make equal length to 2^20 data points
    Sens_data_X= table2array(acceldatawindow(1:size_sample_set,2));
    Sens_data_X(size_sample_set+1:wanted_sample_size,1)= zeros;
    
    Sens_data_Y= table2array(acceldatawindow(1:size_sample_set,3));
    Sens_data_Y(size_sample_set+1:wanted_sample_size,1)= zeros;
    
    
    Sens_data_Z= table2array(acceldatawindow(1:size_sample_set,4));
    Sens_data_Z(size_sample_set+1:wanted_sample_size,1)= zeros;
    
    
end 


%{
Sens_data_X= table2array(acceldatawindow(1:length(B),2));
Sens_data_Y= table2array(acceldatawindow(1:length(B),3));
Sens_data_Z= table2array(acceldatawindow(1:length(B),4));
%}

%Convert to 2's complement
for twosc_cnt=1:1:size(Sens_data_X)
    
    if Sens_data_X(twosc_cnt,1) >= 32768
        
        sens_x_conv(twosc_cnt,1) = -(((65535 - Sens_data_X(twosc_cnt,1) ))+1);
        
    else 
        sens_x_conv(twosc_cnt,1) = Sens_data_X(twosc_cnt,1);
    end 
end 

for twosc_cnt=1:1:size(Sens_data_Y)
    
    if Sens_data_Y(twosc_cnt,1) >= 32768
        
        sens_y_conv(twosc_cnt,1) = -(((65535 - Sens_data_Y(twosc_cnt,1) ))+1);
        
    else 
        sens_y_conv(twosc_cnt,1) = Sens_data_Y(twosc_cnt,1);
    end 
end 
for twosc_cnt=1:1:size(Sens_data_Z)
    
    if Sens_data_Z(twosc_cnt,1) >= 32768
        
        sens_z_conv(twosc_cnt,1) = -(((65535 - Sens_data_Z(twosc_cnt,1) ))+1);
        
    else 
        sens_z_conv(twosc_cnt,1) = Sens_data_Z(twosc_cnt,1);
    end 
end 


% Scale according to set sensitivity - see datasheet of MPU6000 accelerometer for further info

for scaling_cnt = 1:1:size(Sens_data_X)
    
    sens_x_scaled(scaling_cnt,1) = sens_x_conv(scaling_cnt,1)/16384;
    
end 

for scaling_cnt = 1:1:size(Sens_data_Y)
    
    sens_y_scaled(scaling_cnt,1) = sens_y_conv(scaling_cnt,1)/16384;
    
end 

for scaling_cnt = 1:1:size(Sens_data_Z)
    
    sens_z_scaled(scaling_cnt,1) = sens_z_conv(scaling_cnt,1)/16384;
    
end 

