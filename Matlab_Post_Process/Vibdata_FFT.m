%Vibration sensor data FFT script

  
  fname =' FFT data';
  FFT_file=Y_data_FFT_format;

  
  
  xdft=[];
  freq=0;  
  
 
  %Determine variables and Display size
    [N,m] = size(FFT_file);
    t = FFT_file(:,1); %time in seconds
    x = FFT_file(:,2); %array of data for RMS and FFT
   
    Fs=frequency;
    fprintf('%12.0f data points\n',N)

    
    %{
%Plot Data
    tic %start timer
    figure(2)
    plot(t,x)
    xlabel('Time (s)');
    ylabel('Accel (g)');
    title(fname);
    grid on;
    fprintf('%4.2f seconds - Time to Plot Data\n',toc)
    %}

    %Determine RMS and Plot
    tic %start timer
    w = floor(Fs); %width of the window for computing RMS
    steps = floor(N/w); %Number of steps for RMS
    t_RMS = zeros(steps,1); %Create array for RMS time values
    x_RMS = zeros(steps,1); %Create array for RMS values
    for i=1:steps
        range = ((i-1)*w+1):(i*w);
        t_RMS(i) = mean(t(range));
        x_RMS(i) = sqrt(mean(x(range).^2));  
    end
    
    
    %{
    figure(3)
    plot(t_RMS,x_RMS)
    xlabel('Time (s)');
    ylabel('RMS Accel (g)');
    title(['RMS - ' fname]);
    grid on;
    fprintf('%4.2f seconds - Time to Compute RMS and Plot\n',toc)    
    %}

    
    %Determine FFT and Plot
    tic 
    freq = 0:Fs/length(x):Fs/2; %frequency array for FFT
    xdft = fft(x); %Compute FFT
    %xdft = fft(x,Fs/2); %Compute FFT
    xdft = 1/length(x).*xdft; %Normalize
    xdft(2:end-1) = 2*xdft(2:end-1); 
    
    
    %{
    figure(4)
    plot(freq,abs(xdft(1:floor(N/2)+1)))
    xlabel('Frequency (Hz)');
    ylabel('Accel (g)');
    title(['FFT - ' fname]);
    grid on;
    fprintf('%4.2f seconds - Time to Compute FFT and Plot\n',toc)
    %}
    
    
    figure(5);
    
    subplot(2,2,1);
    plot(t,x)
    xlabel('Time (s)');
    ylabel('Accel (g)');
    title(fname);
    grid on;
    
    subplot(2,2,2);
    plot(t_RMS,x_RMS)
    xlabel('Time (s)');
    ylabel('RMS Accel (g)');
    title(['RMS - ' fname]);
    grid on;
    
    subplot(2,2,[3,4]);
    plot(freq,abs(xdft(1:floor(N/2)+1)))
    xlabel('Frequency (Hz)');
    ylabel('Accel (g)');
    title(['FFT - ' fname]);
    grid on;
    
    
    figure(6);
    periodogram(x,rectwin(length(x)),length(x),Fs);
    
    %{
    figure(5)
    plot(freq(1:50),abs(xdft(1:floor(N/2)+1)))
    xlabel('Frequency (Hz)');
    ylabel('Accel (g)');
    title(['FFT - ' fname]);
    grid on;
    fprintf('%4.2f seconds - Time to Compute FFT and Plot\n',toc)
    %}
    
    
    % Extract frequency and amplitude content from FFT plot. Possible
    % solution for later mean value estimations of multiple data sets.Not
    % verified yet
    
   %{ 
    [A_accel_peaks.(FFT_select)(:,A_FFT_col_cnt) , A_frequencies.(FFT_select)(A_FFT_col_cnt,:)] =findpeaks(abs(xdft(1:floor(N/2)+1)), freq);
    %fft_cnt.(FFT_select)=fft_cnt.(FFT_select)+1;
    figure(5);
    %hold on;
    plot(A_frequencies.(FFT_select), A_accel_peaks.(FFT_select) );
    %plot(frequencies, accel_peaks);
    
    %fft_cnt.(FFT_select)
    
    %}
    
    