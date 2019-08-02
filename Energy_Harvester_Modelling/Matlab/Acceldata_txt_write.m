%This scripts converts acceleration data into a .txt file, to be used for
%acceleration simulations in LTSpice and similar.

%Write acceleration data to text file


%Insert file-name accourding to specification or desire
fileID =fopen('accel-data-19-02-20--20_12_42_X_axis-median-correctedsource_for12_54hz_Fullscope.txt', 'w');




%Set Voltage correction factor, according to calculations performed in
%res_freq_calc_masschange

%VC= 15.490535659429646       % For 68 hz freq, natural resonance
%VC=5.049603257423121e+02;  %For V70 Resonance
%VC= 1.106466832816403e+03;   %For U857 resonance


VC= 4.650385576035093e+02;  %For V70 resonance, at 12.54 hz
%VC=9.913386808551147e+02;   %For 857 resonance, 8.59 hz
%VC=3.718395774443708e+02;   % For 856 resonance, at 14.0259 hz
%VC= 5.034146082572722e+02;   % For V70 resonance at 12.05 hz
%VC=3.499104056422206e+02; % For 856 resonance, at 14.45 hz

%VC=1.484133431571285e+03; %For 856 resonance, at 7.02 hz


%Recalculate acceleration values to be based upon GEMC factor.
%for GEMC_cnt=1:1:size_sample_set
for GEMC_cnt=1:1:length(X_data_LTS_mod)
%for GEMC_cnt=359692:1:501000

%for GEMC_cnt=1:1:(539e3)
%for GEMC_cnt=1:1:(240e3)
    %Write time scale
    X_data_GEMC_format(GEMC_cnt,1)=X_data_LTS_mod(GEMC_cnt,1);
    
    %write acceleration data
    %Y_data_GEMC_format(GEMC_cnt,2)=(Y_data_LTS_mod(GEMC_cnt,2))/GEMC;
    %Y_data_GEMC_format(GEMC_cnt,2)=((Y_data_LTS_mod(GEMC_cnt,2))*VC);
    %Y_data_GEMC_format(GEMC_cnt,2)=((Y_data_LTS_mod(GEMC_cnt,2)));
    
    X_data_GEMC_format(GEMC_cnt,2)=((X_data_LTS_mod(GEMC_cnt,2))*VC);
    
    %Y_data_GEMC_format(GEMC_cnt,2)=((Y_data_LTS_mod(GEMC_cnt,2)));
        fprintf(fileID,'%6.6f %12.6f \n',X_data_GEMC_format(GEMC_cnt,:));
end 


%File write without GEMC factor calculated
%{
for file_writer=1:1:size_sample_set
%for file_writer=1:1:9000
    
%fprintf(fileID,'%6s %12s\n','t','data(t)');
    fprintf(fileID,'%6.6f %12.6f \n',Y_data_FFT_format(file_writer,:));
end 
%}

fclose(fileID);