
% Extract time data from imported csv file
tic %start timer

%Manipulate data to fit sample length 2 ^ 20 samples. Corresponds to
%approximately 25 to 30 minute drive
help 
N_fft_size = floor(log2(size(acceldatawindow)));
size_sample_set = 2 ^ N_fft_size(1,1);

N_actual_sz=log2(size(acceldatawindow));
actual_sz = size(acceldatawindow);

N_wanted_size= 20;
wanted_sample_size = 2^20;



%Manipulate data set size according to 2 ^N size restriction

if N_fft_size(1,1) >= N_wanted_size
    Time_Sens_data = acceldatawindow(1:wanted_sample_size,1);
    sample_diff = (size_sample_set - wanted_sample_size) / 615; 
    
    samples_left = (actual_sz(1,1) - size_sample_set)/615;
    fprintf('Sample data shorted, samples left to process: Approx %f seconds \n', samples_left);
    
elseif N_fft_size(1,1) < N_wanted_size
    Time_Sens_data = acceldatawindow(1:size_sample_set,1);
    
    %Pad zero's to dataset after to make equal length to 2^20 data points
    %Will be done later in code, when time is converted to seconds diff
    
    %Time_Sens_data(size_sample_set+1:wanted_sample_size, 2:4) = zeros;
    
    %time_conv_sec(size_sample_set:wanted_sample_size, 1) = 0.0017;
    %fprintf('Data set too short, zero padded from boundary with time period 1.7 ms');
    
end 


%Time_Sens_data = acceldatawindow(1:size_sample_set,1);
length_accdatawind=size(acceldatawindow);
Time_Sens_data = acceldatawindow(1:length_accdatawind(1,1),1);
% Convert time data from table to array

B=table2array(Time_Sens_data);

%Reducing file til when "File close" string is reached
closing_split=strcmp(B(:,1), 'File close');
for closing_cnt = 1:1:length(closing_split)
    if closing_split(closing_cnt) == 1
        B=B(1:closing_cnt-10,1);
        
    end 
end

        
 
 


%Convert to datetime format
time_datetime_conv=datetime(B, 'Format', 'yyyy-MM-dd HH:mm:ss.SSSSSS');


%Prevent empty microsecond issue
for time_micro = 1:1:size(time_datetime_conv)
     if isnat(time_datetime_conv(time_micro,1)) == 1
         B(time_micro,1) = strcat(B(time_micro,1), '.000000');
         time_datetime_conv(time_micro,1) = datetime(B(time_micro,1), 'Format', 'yyyy-MM-dd HH:mm:ss.SSSSSS');
     end 
end          
         

%Convert to time stamps relative to time nr 1

time_conv_sec = seconds(diff(time_datetime_conv)) ; 
M=mean(time_conv_sec);
frequency=1/M;


%"Zero padding" of time scope if measurement data is below N 20 boundary

if N_fft_size < N_wanted_size
    time_conv_sec(size_sample_set:wanted_sample_size, 1) = M;
    fprintf('Data set too short, zero padded from boundary with time period %f ms \n', M);
end 



figure(1);
plot(time_conv_sec);

xlabel('Sample');
ylabel('Time difference (s)');
title('Acceleration measurement time drift');
%time_conv_2 = seconds(time_datetime_conv);

%Calculate time duration - starting from sample 1 as start-point
sample_cnt_prev=1;
time_scope(1,1)=0;


for sample_cnt = 1:1:size(time_conv_sec)
    %samplecnt_inc= sample_cnt + 1;
    
    time_scope(sample_cnt,1) = time_scope(sample_cnt_prev,1) + time_conv_sec(sample_cnt,1);
%     for conv_cnt = 1:1:size(time_conv_sec)
%         
%         time_scope(sample_cnt,1) = time_scope(sample_cnt_prev,1) + time_conv_sec(conv_cnt,1);
%         
    sample_cnt_prev=sample_cnt;
    %end 
    
end 



time_scope(wanted_sample_size,1)=0;


time_scope_shifted=circshift(time_scope(1:wanted_sample_size,1), 1);
sample_length = time_scope_shifted(size(time_scope_shifted,1));
fprintf(' %4.2f seconds - sample length \n' ,sample_length)
sample_rate_bound(1,1) = 1 / min(time_conv_sec);
sample_rate_bound(2,1) = 1 / max(time_conv_sec);

fprintf (' %4.2f Min calculated sample rate \n' ,sample_rate_bound(2,1))
fprintf (' %4.2f Max calculated sample rate \n' ,sample_rate_bound(1,1))


 fprintf('%4.2f seconds - Time to Calculate time scope \n',toc)
 
 

