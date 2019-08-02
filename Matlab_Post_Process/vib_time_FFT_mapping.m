%Map data to FFT friendly format


%X axis
 X_data_FFT_format(:,1)=time_scope_shifted; 
 X_data_FFT_format(:,2)=sens_x_scaled;
 
 %Y axis
 Y_data_FFT_format(:,1)=time_scope_shifted; 
 Y_data_FFT_format(:,2)=sens_y_scaled;
 
 %Z axis
 
 Z_data_FFT_format(:,1)=time_scope_shifted; 
 Z_data_FFT_format(:,2)=sens_z_scaled;
 
 
 
 
 
 %Dataset manipulation for piezo energy harvester modelling
 
 Y_data_LTS_mod(:,1)=time_scope_shifted;
 
 if N_fft_size(1,1) >= N_wanted_size
    mean_y=mean(sens_y_scaled(1:1048576));
elseif N_fft_size(1,1) < N_wanted_size
    mean_y=mean(sens_y_scaled(1:size_sample_set));
 end 
%mean_y=mean(sens_y_scaled(1:1048576));
%mean_y=0.46;
%for mean_cnt=1:1:size(sens_y_scaled)
for mean_cnt=1:1:1048576
Y_data_LTS_mod(mean_cnt,2)= (sens_y_scaled(mean_cnt)-mean_y);

end



X_data_LTS_mod(:,1)=time_scope_shifted;
 
 if N_fft_size(1,1) >= N_wanted_size
    mean_x=mean(sens_x_scaled(1:1048576));
elseif N_fft_size(1,1) < N_wanted_size
    mean_x=mean(sens_x_scaled(1:size_sample_set));
 end 
%mean_y=mean(sens_y_scaled(1:1048576));
%mean_y=0.46;
%for mean_cnt=1:1:size(sens_y_scaled)
for mean_cnt=1:1:1048576
X_data_LTS_mod(mean_cnt,2)= (sens_x_scaled(mean_cnt)-mean_x);

end 


 