%% Solving Orbital EOM's for Patched Conics to Mars
% Code by Carlos Ortiz

clc;clear;close;

%% Initialize
fprintf("Initializing:\n")

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

%% Calculate and Constuct State

% Mean Solar Distance for Earth & Mars to Sun
r_Es = 149.60e6;        % [km]
r_Ms = 227.94e6;        % [km]

v_E = sqrt(mu_S/r_Es);  % [km/s]
v_M = sqrt(mu_S/r_Ms);  % [km/s]

% Construct state vectors
rE = [r_Es; 0; 0];      % [km], position vector
vE = [0; v_E; 0];       % [km/s], velocity vector
sE = [rE; vE];          % [km; km/s], state vector

rM = [r_Ms;0;0];        % [km], position vector
vM = [0;v_M;0];         % [km/s], velocity vector
sM = [rM;vM];           % [km; km/s], state vector

% Orbital Period
T_E = (2*pi)/(mu_S)^(1/2)*r_Es^(3/2); % [sec]
T_M = (2*pi)/(mu_S)^(1/2)*r_Ms^(3/2); % [sec]

fprintf("...Making Plot...\n")

% Initialize Figure
figure(1)
grid on
hold on
title("Orbits of Earth and Mars Around the Sun")

% Make Sun
R_sun = 6696340;        %[km]
[X,Y,Z] = sphere;
props.FaceColor= 'yellow';
props.EdgeColor = 'none';
s=surface(R_sun*X,R_sun*Y,R_sun*Z,props);
xlabel('x [km]');ylabel('y [km]');zlabel('z [km]')

%% Ship
fprintf("...Calculating Ship's Orbit...\n")

% Transfer Delta V:
deltaV_departure = 2.94509; % [km/s]
rS = [r_Es; 0; 0];      % [km], position vector
vS = [0; (v_E+deltaV_departure); 0];       % [km/s], velocity vector
sS = [rS; vS];

% Integrate with ODE45
Tship = 2*pi/sqrt(mu_S)*((r_Es + r_Ms)/2)^(3/2); % [s]
tspanS = 0:Tship;                                % [s]
OPTIONS = odeset('Maxstep',10000);
[~,SS] = ode45(@EOM, tspanS, sS, OPTIONS);       % [[km][km/s]]

% Split SS into components
XaS = SS(:,1)';     % [km] - ECI X coordinate
YaS = SS(:,2)';     % [km] - ECI Y coordinate
ZaS = SS(:,3)';     % [km] - ECI Z coordinate

plot(XaS, YaS, 'c', 'linewidth', 2)
fprintf("...Finished Plotting Ship's Orbit...\n")


%% Earth
fprintf("...Calculating Earth's Orbit...\n")

% Integrate with ODE45
tspanE = 0:T_E;                             % [s]
%OPTIONS = odeset('Maxstep',10000);
[~,SE] = ode45(@EOM, tspanE, sE, OPTIONS);  % [[km][km/s]]

% Split SE into components
XaE = SE(:,1)';     % [km] - ECI X coordinate
YaE = SE(:,2)';     % [km] - ECI Y coordinate
ZaE = SE(:,3)';     % [km] - ECI Z coordinate

plot(XaE, YaE, 'b', 'linewidth', 2)
fprintf("...Finished Plotting Earth's Orbit...\n")

%% Mars
fprintf("...Calculating Mars's Orbit...\n")

% Integrate woth ODE45
tspanM = 0:T_M;                             % [s]
[~,SM] = ode45(@EOM, tspanM, sM, OPTIONS);  % [[km][km/s]]

%Split SM into components
XaM = SM(:,1)';     % [km] - ECI X coordinate
YaM = SM(:,2)';     % [km] - ECI Y coordinate
ZaM = SM(:,3)';     % [km] - ECI Z coordinate

plot(XaM, YaM, 'r', 'linewidth', 2)
legend("Sun","Ship","Earth Orbit","Mars Orbit",'AutoUpdate','off')

% Make axes
plot3(linspace(0,r_Ms),zeros(100),zeros(100),'k','linewidth',2)
plot3(zeros(100),linspace(0,r_Ms),zeros(100),'k','linewidth',2)
plot3(zeros(100),zeros(100),linspace(0,r_Ms),'k','linewidth',2)
axis equal

fprintf("...Finished Plotting Mars's Orbit.\n\nDisplaying Results:\n\n")

