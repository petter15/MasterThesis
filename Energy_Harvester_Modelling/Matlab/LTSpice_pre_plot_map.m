%This script remaps and calculates data from LTSpice simulation files for
%result plotting. 


%Calculate specific items addresses in struct
gnd_detect=strcmp(raw_data.variable_name_list  (1,:), 'V(local_gnd_piezo)');
for gen_cnt=1:1:length(gnd_detect)
    if gnd_detect(1,gen_cnt) == 1
        address_gnd=gen_cnt;
    end 
end

Vaccel_detect=strcmp(raw_data.variable_name_list  (1,:), 'V(vaccel)');
for gen_cnt=1:1:length(Vaccel_detect)
    if Vaccel_detect(1,gen_cnt) == 1
        address_Vaccel=gen_cnt;
    end 
end

Vpiezo_detect=strcmp(raw_data.variable_name_list  (1,:), 'V(vpiezo)');
for gen_cnt=1:1:length(Vpiezo_detect)
    if Vpiezo_detect(1,gen_cnt) == 1
        address_Vpiezo=gen_cnt;
    end 
end

VLoad_detect=strcmp(raw_data.variable_name_list  (1,:), 'V(vload)');
for gen_cnt=1:1:length(VLoad_detect)
    if VLoad_detect(1,gen_cnt) == 1
        address_VLoad=gen_cnt;
    end 
end



IRLoad_detect=strcmp(raw_data.variable_name_list  (1,:), 'I(Rload1)');
for gen_cnt=1:1:length(IRLoad_detect)
    if IRLoad_detect(1,gen_cnt) == 1
        address_IRLoad=gen_cnt;
    end 
end

%Calculate "Piezo elements " side potential towards "local ground".

V_Accel_calc=(raw_data.variable_mat(address_Vaccel,:))-(raw_data.variable_mat(address_gnd,:));

V_Piezo_calc=(raw_data.variable_mat(address_Vpiezo,:))-(raw_data.variable_mat(address_gnd,:));


%Calculate output power from LTC3588 regulator

LTC3588_power_calc=(raw_data.variable_mat(address_VLoad,:)).*(raw_data.variable_mat(address_IRLoad,:));

%Input voltage from accelerometer vs "piezo voltage" . Mechanical to
%electrical conversion

figure(1);
plot(raw_data.time_vect(1,:), V_Accel_calc(1,:), 'g' );
hold on;
plot(raw_data.time_vect(1,:), V_Piezo_calc(1,:), 'r' );
title('Acceleration signal vs piezo signal');
xlabel('Time[s]');
ylabel('Voltage [V]');
legend('Acceleration ampplitude','Piezo voltage');
%axis([700 800 -40 60]);
%xlim([700,800]);
%axis([300 400 -200 200]);
%axis 'auto y';

%Piezo voltage vs output voltage from LTC3588. 

figure(2);
plot(raw_data.time_vect(1,:), V_Piezo_calc(1,:), 'r' );
hold on;
plot(raw_data.time_vect(1,:), raw_data.variable_mat(address_VLoad,:), 'b' );
title('Piezo input at LTC3588 vs output voltage from LTC3588');
xlabel('Time[s]');
ylabel('Voltage [V]');
legend('Piezo voltage','LTC3588 output voltage');
%axis([300 400 -10 10]);
%Output current and output power from regulator.

figure(3);
yyaxis left;
plot(raw_data.time_vect, raw_data.variable_mat(address_IRLoad,:), 'b' );
ylabel('LTC3588 Current [I]');
hold on;
plot(raw_data.time_vect, LTC3588_power_calc(1,:), 'r' );

title('LTC3588, output current and power');
xlabel('Time[s]');
yyaxis right
ylabel('LTC3588 Power[W]');
legend('LTC3588 Output current','LTC3588 Output power');
%axis([300 400 -0.5e-5 4.5e-5 ]);

