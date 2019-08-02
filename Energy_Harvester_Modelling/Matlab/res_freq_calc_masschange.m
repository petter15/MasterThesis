%Resonance frequency calculation script based on variable mass.
%Changing the mass in a piezo system effectively changes the resonance
%frequency of the transducer.
%Changing mass also changes the property of  the source element, inductive
%element and damping factor. 

%m= 1.4e-3;              %Mass in kg
k= 261;                 %Spring stiffness in N/m
Qm = 60;                %Quality factor. Found in specific datasheet for piezo element
GEMC = 886.60588e-6;     %General ElectroMagnetic Coupling factor
%{
res_freq=sqrt(k/m);

%Vmc = (m*a)/GEMC        %Source / input component
Lmc = m / GEMC^2;        %Inductive component relevant to mass
Rmc = ((m*sqrt(k/m))/Qm)/GEMC^2;     % Resistive element due to selection of mass, spring stiffness, quality factor and GEMC factor
Cmc = GEMC^2 / k;       %Capacitive bond


%}
m_val=400;
a=9.81;

%VC=1.009920651484624e+05;

%Create a series of mass values to calculate corresponding system
%parameters for

%m=linspace(1.4e-3, 100e-3, m_val);
m=linspace(1.4e-3, 200e-3, m_val);

for res_freq_calc=1:1:m_val
    
    res_freq(res_freq_calc,1) = ((sqrt(k/m(res_freq_calc)))/(2*pi));
    res_freq_mass(res_freq_calc,1)=    m(res_freq_calc);
    Lmc(res_freq_calc,1) =        m(res_freq_calc)/GEMC^2;
    Rmc(res_freq_calc,1) =        ((m(res_freq_calc)*sqrt(k/m(res_freq_calc)))/Qm)/GEMC^2;
    %Vmc_correction_factor(res_freq_calc,1) =        m(res_freq_calc)/GEMC; 
    Vmc_correction_factor(res_freq_calc,1) =        (m(res_freq_calc)*a)/GEMC; 
    %Vmc_correction_factor(res_freq_calc,1) =        ((res_freq_calc)*VC); 
    

    res_freq_values(res_freq_calc,1)= res_freq(res_freq_calc,1);                %Resonance frequency
    res_freq_values(res_freq_calc,2)=res_freq_mass(res_freq_calc,1);            %Added mass
    res_freq_values(res_freq_calc,3)=Lmc(res_freq_calc,1);                      %Inductor value
    res_freq_values(res_freq_calc,4)=Rmc(res_freq_calc,1);                      %Resistor loss
    res_freq_values(res_freq_calc,5)= Vmc_correction_factor(res_freq_calc,1);   %Voltage correction
    
end 

res_freq_valtable = array2table(res_freq_values);
res_freq_valtable.Properties.VariableNames={'Freq' 'Mass' 'Inductor' 'Resistor' 'VC'};