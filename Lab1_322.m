%% Lab Report 1 - MAE 322
clear; clc;
% Import necissary values for each (Trimming the noise at the beginnin
% Import using Import tool:
st = importdata('SteelData.mat');
al = importdata('AlData.mat');
% convert table to array
s_data = table2array(st(1:end,2:3));
a_data = table2array(al(1:end,2:3));

% Trim data before and after test
s_data = s_data(89:end,1:end);
a_data = a_data(29:end,1:end);
n = length(s_data);
s_data = s_data(1:n-2,:);
n = length(a_data);
a_data = a_data(11:598,:);
% Perform zero shift on data from steel:
s_data(:,1) = s_data(:,1)-s_data(1,1);
s_data(:,2) = s_data(:,2)-s_data(1,2);
a_data(:,1) = a_data(:,1)-a_data(1,1);
a_data(:,2) = a_data(:,2)-a_data(1,2);
% Displacement in column 1, load in column 2

% Calculate measured original cross sectional area
d_avg = .267*10; % average diameter in mm
Ao = pi/4*d_avg^2;
lo = 1.965*10; % original length in mm
li = s_data(:,1); % li in mm
%% Steel Calculations
si = s_data(:,2).*10^3./Ao;
ei = li./lo;

plot(ei,si)
xlabel('Strain [mm/mm])')
ylabel('Stress [MPa]')
title('Engineering Stress Strain Diagram for Steel')

figure(2)
plot(ei,si)
xlabel('Strain [mm/mm])')
ylabel('Stress [MPa]')
title('S-Strain Diagram for Steel (To see Slope)')
xlim([0 0.005])

% Extract data of Linear Portion of data
sfit = si(1:92);
efit = ei(1:92);
% Use regression function created in MAE 384 to find fit for elastic region
% Least squares regression:
a = myLinReg(efit,sfit);
hold on
% fit the line to the corresponding points
fitline = a(2).*efit + a(1);
plot(efit,fitline,'r')
legend('Stress Strain Curve','Best Fit Line')
fprintf('Calculated Value of E for steel = %3.2f ',a(2).*10^-3)
fprintf('GPa\n')
%% Alumainum Calculations
di = 2.6; % diameter in mm
Aao = pi/4.*di^2; % area in mm^2
alo = 22.2; % Original length in mm
asi = a_data(:,2).*10^3./Aao; % Calculated stress
aei = a_data(:,1)./alo; % calculated strain
% plot the stress straing curve
figure(3)
plot(aei,asi)
xlabel('Strain [mm/mm]')
ylabel('Stress [MPa]')
title('Stress Strain Curve of Aluminum')
figure(4)
% Extract data to fit to a line
aefit = aei(1:86);
asfit = asi(1:86);
% Least squares regression to find best fit line:
a2 = myLinReg(aefit,asfit);
fitline2 = a2(2).*aefit + a2(1);
% Plot fit line with graph
plot(aei,asi)
xlim([0 0.005])
hold on
plot(aefit,fitline2,'r')
legend('S-Strain curve (Al)','Best Fit Line')
xlabel('Strain [mm/mm]')
ylabel('Stress [MPa]')
fprintf('Calculated Value of E for Aluminum = %3.2f ',a2(2)*10^-3)
fprintf('GPa\n')
hold off

%% Finding the Yield Stress
% Plot stress strain curves of each, and a 0.2% offset. Then use the data
% selection tool in plot to determine the intersection point
% Steel
ei_offset = efit + 0.002;
plot(ei,si)
xlabel('Strain [mm/mm])')
ylabel('Stress [MPa]')
hold on
plot(ei_offset,fitline);
xlim([0 0.01])
fprintf('Yield Strength Calculations\n')
fprintf('\nCalculated Yield Strength (Steel) = 259.2 Mpa\n')
hold off
% Aluminum
figure(5)
aei_offset = aei(1:100) + 0.002;
plot(aei,asi)
xlabel('Strain [mm/mm])')
ylabel('Stress [MPa]')
hold on
fitline3 = a2(2).*aei(1:100) + a2(1);
plot(aei_offset,fitline3)
xlim([0 0.01])
fprintf('Calculated Yield Strength (Aluminim) = 290.2 Mpa \n')

%% Ultimate Stress
% Take max value from both graphs for Ultimate Stress
fprintf('\nUltimate Stress Calculations\n\n')
fprintf('Ultimate Stress (Steel) [Mpa] = %3.2f',max(si))
fprintf('\nUltimate Stress (Aluminum) [MPa] = %3.2f',max(asi))

%% Fracture Stress
% Take the final data value for each graph to find Fracture Stress
fprintf('\nFracture Stress Calculations\n\n')
fprintf('Fracture Stress (Steel) [MPa] = %3.2f',si(end))
fprintf('\nFracture Stress (Aluminum) [MPa] = %3.2f',asi(end))

%% % Elongation
% 2 Methods
%   1. Using Graphical Data
%   2. Using Measured Data
% 1. 
fprintf('\nPercent Elongation (Steel) (Graphical) = %3.2f',ei(end)*100)
fprintf('\nPercent Elongation (Aluminum) (Graphical) = %3.2f',aei(end)*100)

% 2.
% % elongation from (Lf-Lo)/Lo
fprintf('\n\nPercent Elongation (Steel) = %3.2f',100*(2.275-1.965)/2.275)
fprintf('\nPercent Elongation (Aluminum) = %3.2f',100*(2.34-2.22)/2.34)


%% % R.A.
% Steel: Df = .145mm, Do = .267mm
ao = pi/4*.267^2;
af = pi/4*.145^2;
rAs = (ao-af)/ao*100;
% Aluminum: Df = .188mm, Do = .260mm
ao = pi/4*.26^2;
af = pi/4*.188^2;
rAa = (ao-af)/ao*100;

fprintf('\nPercent Reduction of Area (Steel) = %3.2f',rAs)
fprintf('\nPercent Reduction of Area (Aluminum) = %3.2f',rAa)

%% True Stress Strain Curve
% Steel: Only use points up to max load
n = 230;
figure(6)
ao = pi/4*.267^2;
ai = ao./(1+ei(n:1080));
stress_st = s_data(n:1080,2)./ai;
strain_st = log(1 + ei(n:1080));
loglog(strain_st,stress_st)
xlabel('Natural Log of Strain [mm/mm]')
ylabel('Natural log of Stress [MPa]')
title('LogLog Plot of True Stress Strain Curve (Steel)')

% Aluminum
figure(7)
n = 117; m = 400;
ao = pi/4*.267^2;
ai = ao./(1+aei(n:m));
stress_a = a_data(n:m,2)./ai;
strain_a = log(1 + aei(n:m));
plot(log(strain_a),log(stress_a))
xlabel('Strain [mm/mm]')
ylabel('Stress [MPa]')
title('True Stress Strain Curve (Aluminum)')

% Fit lines to each data set
% Steel
s_stf = log(stress_st);
s_ef = log(strain_st);
a = myLinReg(s_ef,s_stf);
slope_s = a(2);
int_s = a(1);

% Aluminum
a_stf = log(stress_a);
a_ef = log(strain_a);
a = myLinReg(a_ef,a_stf);
slope_a = a(2);
int_a = a(1);

% Calculate n and b
% n = slope of line, intercept = ln(sigma)
bs = exp(int_s);
ns = slope_s;

% Aluminum
ba = exp(int_a);
na = slope_a;
fprintf('\n')

%% Plot True Stress Strain Diagram
%Create data set for plotting
n = 5; m = 1093; % Bounds for extraction
ao = pi/4*.267^2;
ai = ao./(1+ei(n:m));
ei_s = log(1+ei(n:m));
si_s = s_data(n:m,2).*10./ao;

figure(8)
plot(ei,si)
hold on
plot(ei_s,si_s,'r')
xlabel('Strain [mm/mm]')
ylabel('Stress [MPa]')
title('Stress Strain Diagram (Steel)')
legend('Engineering','True','Location','SouthEast')
% Aluminum
n = 5; m = 410; % Bounds for extraction
ao = pi/4*.26^2;
aai = ao./(1+aei(n:m));
ei_a = log(1+aei(n:m));
si_a = a_data(n:m,2).*10./ao;

figure(9)
plot(aei,asi)
hold on
plot(ei_a,si_a,'r')
xlabel('Strain [mm/mm]')
ylabel('Stress [MPa]')
title('Stress Strain Diagram (Aluminum)')
legend('Engineering','True','Location','SouthEast')