%% Mars DV and Other Transfer Calculations
% Code by Carlos Ortiz

%% Initialize
% working
clc;clear;close;

% Constants
G = 6.6742*10^(-20);    % [km^3/(kg*s^2)] gravitational constant 
m_E = 5.972*10^24;      % [kg] mass of Earth 
m_M = 6.41693*10^23;    % [kg] mass of mars
m_S = 1.9891*10^30;     % [kg] mass of Sun
m_ship = 1000;          % [kg]  mass of Ship

% Gravitational Parameters for Earth, Mars, and Sun
mu_E = G*(m_E + m_ship); % [km^3/s^2]
mu_M = G*(m_M + m_ship); % [km^3/s^2]
mu_S = G*(m_S + m_ship); % [km^3/s^2]
% Show mu values
fprintf("Mu_Earth: %d[km^3/s^2]\nMu_Mars:  %d[km^3/s^2]\nMu_Sun:   %d[km^3/s^2]\n",mu_E, mu_M, mu_S)

% Mean Solar Distance for Earth & Mars to Sun
r_Es = 149.60e6; %[km]
r_Ms = 227.94e6; %[km]

% End Initialize

%% Delta_V:
% working

A = (r_Es + r_Ms)/2; % [km]

deltaV_depart = sqrt(mu_S)*sqrt((2/r_Es)-(1/A)) - sqrt(mu_S/r_Es); % [km/s]
deltaV_arrive = sqrt(mu_S/r_Ms) - sqrt(mu_S)*sqrt((2/r_Ms)-(1/A)); % [km/s]

DeltaV = deltaV_depart + deltaV_arrive; % [km/s]

fprintf("\nDelta V to Depart:    %g [km/s]\nDelta V upon Arrival: %g [km/s]", deltaV_depart, deltaV_arrive)
fprintf("\nTotal Delta V:        %g [km/s]\n", DeltaV)

%% Time Till Arrival
% working

% Duration of transfer
t_transfer = pi*sqrt(A^3/mu_S);     % [sec]
fprintf("\nTime duration of transfer:    %g [sec]\n", t_transfer)

% Convert and get output values
day = t_transfer/86400;             % [days]
days = floor(day);                  % integer days
year = day/365;                     % [years]
years = floor(year);                % int years
hour = (day - days)*24;             % [hours]
hours = floor(hour);                % int hours
minute = (hour - hours)*60;         % [minues]
minutes = floor(minute);            % int minutes
seconds = (minute - minutes)*60;    % [seconds]

fprintf("Time till arrival after burn: %g years, %g days, %g hours, %g minutes, %.4g seconds.\n", years, days, hours, minutes, seconds) 

%% Linear and Angular Velocity:

% Velocity of Earth and Mars (circular)
v_E = sqrt(mu_S/r_Es);
v_M = sqrt(mu_S/r_Ms);
fprintf("\nCircular Orbital Velocity and Angular Velocity of:\nEarth: %g[km/s]     Mars: %g[km/s]\n", v_E, v_M)
% Angular velocity of Earth and Mars ab sun
omega_Es = v_E / r_Es; %[rad/s] angular velocity of earth ab sun
omega_Ms = v_M / r_Ms; %[rad/s] angular velocity of mars ab sun
fprintf("Earth: %.3g[rad/s]   Mars: %.3g[rad/s]\n", omega_Es, omega_Ms)

% NOTE commented out way to calculate the arrival angle with incorrect
% results. Incorrectness stemmed from value of p in eqn
% Get p value to find the true anomaly
% h = r X v, but circular, so theta = 90, sin theta = 1, just multiply
% h_E = v_E*r_Es; % [km^2/s] spec angular momentum
% p_E = sqrt(h_E^2/mu_E); % [km]  semi-latus rectum
% 
% h_M = v_M*r_Ms;% [km^2/s] spec angular momentum
% p_M = sqrt(h_M^2/mu_M); % [km]

% % true anomaly with eccentricity 1
% nu1 = acos((p_E - r_Es)/(1*r_Es));
% nu2 = acos((p_M - r_Ms)/(1*r_Ms));
% 
% fprintf("\nnu1 %g\nnu2 %g\n", nu1, nu2)
% 
% 
% anom_sub = nu2 - nu1;
% time_sub = omega_Ms*(t_transfer);
% u=  anom_sub*180/pi;
% l=  time_sub*180/pi;
% phi_transfer = anom_sub - time_sub; %[rad]
% 
% if phi_transfer < 0
%     phi = pi + phi_transfer;
% else
%     phi = phi_transfer;
% end
% phi_d = phi*180/pi;
%% Angle of Arrival
% Different way of calculating angle of alignment
% https://resources.wolframcloud.com/FormulaRepository/resources/Hohmann-Angular-Alignment

align = pi*(1 - (sqrt(((r_Es/r_Ms)+1)^3)/(2*sqrt(2))));
alignd = 180/pi*align;

fprintf("\nMars must be %g degrees ahead of earth in phase to optimally Hohmann Transfer\n", alignd)
 