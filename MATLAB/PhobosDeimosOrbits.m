%% Initialize
clc;clear;close;
fprintf("Initializing: ...\n")

%%% Notes:
% Phobos and Deimos eccentricity of 0.0151 and 0.0002 respectively.
% 1.075 and 2 degree inclination can be neglected
% Assume Circular, Keplerian, non inclined Orbits

% Parking orbit in Mars @ 5 sol period


%--------------------------------------------------------------------------


%%% Mars and Moon Parameters: 

% Mars
% https://solarsystem.nasa.gov/planets/mars/by-the-numbers/
Mm = 641693000000000000000000; % [kg] - - - mass of Mars, 6.41x10^23 kg
Rm = 3389.5;                   % [km] - - - equatorial radius

% Phobos
% https://solarsystem.nasa.gov/moons/mars-moons/phobos/by-the-numbers/
Mp = 10658529896187200; % [kg] - - - mass of Phobos, 10.7x10^15 kg
Rp = 11.1;              % [km] - - - equatorial radius
r_p = 9376;             % [km] - - - orbital distance from Mars

% Diemos
% https://solarsystem.nasa.gov/moons/mars-moons/deimos/by-the-numbers/
Md = 1476188406600740;  % [kg] - - - mass of Diemos - - 1.48x10^15 kg
Rd = 6.2;               % [km] - - - equatorial radius
r_d = 23458;            % [km] - - - orbital distance from Mars

% Constants
G = 6.6742*10^(-20);    % [km^3/(kg*s^2)] - - - gravitational constant 
m_ship = 1000;          % [kg] >>> Change with mass of ship

R_MS = 227.94e6;        % [km] - - - distance from sun to mars
Msun = 1.9891*10^30;    % [kg] - - - mass of Sun


%--------------------------------------------------------------------------


%% Calculations

% Gravitational parameters
mu_M = G*(Mm + m_ship); % [km^3/s^2] - - - Mars
mu_P = G*(Mp + m_ship); % [km^3/s^2] - - - Phobos
mu_D = G*(Md + m_ship); % [km^3/s^2] - - - Deimos

% Velocities
Vp = sqrt(mu_M/r_p);    % [km/s] - - - Phobos
Vd = sqrt(mu_M/r_d);    % [km/s] - - - Deimos

% Orbital Periods
Tp = (2*pi)/(mu_M)^(1/2)*r_p^(3/2); % [s]
Td = (2*pi)/(mu_M)^(1/2)*r_d^(3/2); % [s]

% Parking Orbit
% Define a sol in [s], find parameters to maintain a 5 sol orbit
sol = 24*3600 + 39*60 + 35;         % [s]
Tpark = 5*sol;                      % [s] - - - period of parking orbit
r_park = (Tpark*(mu_M^(1/2))/(2*pi))^(2/3); % [km] - - - radius of parking orbit
V_park = sqrt(mu_M/r_park);                 % [km/s] - - - velocity of parking orbit

fprintf("\nParking orbit radius: %g\n", r_park);
%--------------------------------------------------------------------------


%% Initialize Plot

fprintf("...Creating Plot...\n")

% Initialize Figure
figure(1)
grid on
hold on
title("Orbits of Phobos and Diemos Around Mars")

% Make Mars in center of figure
[X,Y,Z] = sphere;
props.FaceColor= 'red';
props.EdgeColor = 'none';
s=surface(Rm*X,Rm*Y,Rm*Z,props);
fprintf("...Done!\n")


%--------------------------------------------------------------------------


%% Construct State Vectors and Integrate

% Phobos

fprintf("...Calculating Phobos's Orbit...\n")

rp = [r_p; 0; 0];   % [km]
vp = [0; Vp; 0];    % [km/s]
sp = [rp;vp];       % [ [km] [km/s] ]

% Define timespan and integrate
tspanP = 0:Tp;      % [s]
OPTIONS = odeset('Maxstep',10);
[~,Sp] = ode45(@EOM_Mars, tspanP, sp, OPTIONS); 

% Split Sp into components and plot
XaP = Sp(:,1)';     % [km] - - - Mars Centered X coordinate
YaP = Sp(:,2)';     % [km] - - - Mars Centered Y coordinate
ZaP = Sp(:,3)';     % [km] - - - Mars Centered Z coordinate

plot(XaP, YaP, 'Color', [238/255 116/255 89/255], 'linewidth', 2)
fprintf("...Done!\n")


%--------------------------------------------------------------------------


% Deimos

fprintf("...Calculating Deimos's Orbit...\n")

rd = [r_d; 0; 0];   % [km]
vd = [0; Vd; 0];    % [km/s]
sd = [rd;vd];       % [ [km] [km/s] ]

% Define timespan and integrate
tspanD = 0:Td;      % [s]
[~,Sd] = ode45(@EOM_Mars, tspanD, sd, OPTIONS); 

% Split Sd into components and plot
XaD = Sd(:,1)';     % [km] - ECI X coordinate
YaD = Sd(:,2)';     % [km] - ECI Y coordinate
ZaD = Sd(:,3)';     % [km] - ECI Z coordinate

plot(XaD, YaD, 'Color',[204/255 160/255 150/255], 'linewidth', 2)
fprintf("...Done!\n")


%--------------------------------------------------------------------------


% Parking Orbit
fprintf("...Calculating Parking Orbit...\n")

rpark = [r_park; 0; 0];    % [km]
vpark = [0; V_park; 0];    % [km/s]
spark = [rpark; vpark];    % [ [km] [km/s] ]
   
% Define timespan and integrate
tspanPark = 0:Tpark;       % [s]
[~,Spark] = ode45(@EOM_Mars, tspanPark, spark, OPTIONS); 

% Split Spark into components and plot
XaPark = Spark(:,1)';     % [km] - - - ECI X coordinate
YaPark = Spark(:,2)';     % [km] - - - ECI Y coordinate
ZaPark = Spark(:,3)';     % [km] - - - ECI Z coordinate

plot(XaPark, YaPark, 'c', 'linewidth', 2)
fprintf("...Done!\n")
fprintf("\nDisplaying Results:\n\n\n")


%--------------------------------------------------------------------------


%% Delta V and Angle Calculations

% [DVarrival, DVdeparture, DV] = HohmannDeltaV(start, end, mu)
% [radians, degrees] = TransferAngle(start, end)

fprintf(" - - - - - - - - - - - - - - - - - - - - - - - - - - \n")
fprintf("\nManeuver DeltaV and Transfer Angle Calculations:\n\n")


% Parking to Phobos:

% Get delta V and angle for transfer
[DVa_pkp, DVd_pkp, DV_pkp] = HohmannDeltaV(r_park, r_p, mu_M);
[rad_pkp, deg_pkp] = TransferAngle(r_park, r_p);

% Get transfer period
transferPeriod_pkp = OrbitalPeriod(r_park, r_p, mu_M) / 2; % [s]
fprintf("Parking to Phobos:\n")
SecondsToTimeElapsed(transferPeriod_pkp)
fprintf("Angle of Transfer: %.4g degrees\n", mod(deg_pkp, 360))
fprintf("\n")


%--------------------------------------------------------------------------


% Phobos to Deimos:

% Get delta V and angle for transfer
[DVa_pd, DVd_pd, DV_pd] = HohmannDeltaV(r_p,r_d, mu_M);
[rad_pd, deg_pd] = TransferAngle(r_p, r_d);

% Get transfer period
transferPeriod_pd = OrbitalPeriod(r_p, r_d, mu_M) / 2; % [s]
fprintf("Phobos to Diemos:\n")
SecondsToTimeElapsed(transferPeriod_pd)
fprintf("Angle of Transfer: %.4g degrees\n", deg_pd)
fprintf("\n")


%--------------------------------------------------------------------------


% Deimos to Parking:

% Get delta V and angle for transfer
[DVa_dpk, DVd_dpk, DV_dpk] = HohmannDeltaV(r_d,r_park, mu_M);
[rad_dpk, deg_dpk] = TransferAngle(r_d, r_park);

% Get transfer period
transferPeriod_dpk = OrbitalPeriod(r_d, r_park, mu_M) / 2; % [s]
fprintf("Diemos to Parking:\n")
SecondsToTimeElapsed(transferPeriod_dpk)
fprintf("Angle of Transfer: %.4g degrees\n", deg_dpk)
fprintf("\n")


%--------------------------------------------------------------------------


% Parking to Deimos:

% Get delta V and angle for transfer
[DVa_pkd, DVd_pkd, DV_pkd] = HohmannDeltaV(r_park,r_d, mu_M);
[rad_pkd, deg_pkd] = TransferAngle(r_park, r_d);

% Get transfer period
transferPeriod_pkd = OrbitalPeriod(r_park, r_d, mu_M) / 2; % [s]
fprintf("Parking to Diemos:\n")
SecondsToTimeElapsed(transferPeriod_pkd)
fprintf("Angle of Transfer: %.4g degrees\n", deg_pkd)
fprintf("\n")


%--------------------------------------------------------------------------


% Diemos to Phobos:

% Get delta V and angle for transfer
[DVa_dp, DVd_dp, DV_dp] = HohmannDeltaV(r_d,r_p, mu_M);
[rad_dp, deg_dp] = TransferAngle(r_d, r_p);

% Get transfer period
transferPeriod_dp = OrbitalPeriod(r_d, r_p, mu_M) / 2; % [s]
fprintf("Diemos to Phobos:\n")
SecondsToTimeElapsed(transferPeriod_dp)
fprintf("Angle of Transfer: %.4g degrees\n", deg_dp)
fprintf("\n")


%--------------------------------------------------------------------------


%% Format Plot
xlabel('x - Mars Centered Reference [km]');ylabel('y - Mars Centered Reference[km]');zlabel('z - Mars Centered Reference [km]')
bounds = 110000;
xlim([-bounds bounds])
ylim([-bounds bounds])
zlim([-bounds bounds])
axis square
lgnd = legend("{\color{red}Mars}","{\color[rgb]{0.9333, 0.4949, 0.3490}Phobos}","{\color[rgb]{0.8, 0.6275, 0.5882}Deimos}","{\color{cyan}Ship Trajectory}", 'location','southeast');
set(gca,'Color','k')
set(lgnd,'color','none')


%--------------------------------------------------------------------------


%% Calculate Escape Velocities and SOI
%https://trs.jpl.nasa.gov/bitstream/handle/2014/42478/12-3014.pdf?sequence=1#:~:text=15%20The%20Phobos%20and%20Deimos,their%20largest%20dimension%2C%20respectively).
fprintf(" - - - - - - - - - - - - - - - - - - - - - - - - - - \n")
fprintf("\nEscape Velocity and SOI Calculations:\n")


% Phobos
Vesc_p = sqrt((2*mu_P)/Rp);
r_SOI_p = r_p*(Mp/Mm)^(2/5);
fprintf("\nEscape velocity for Phobos: %g km/s\nSOI radius: %g km\n", Vesc_p, r_SOI_p)

% Deimos
Vesc_d = sqrt((2*mu_D)/Rd);
r_SOI_d = r_d*(Md/Mm)^(2/5);
fprintf("\nEscape velocity for Deimos: %g km/s\nSOI radius: %g km\n", Vesc_d, r_SOI_d)

% Mars
Vesc_m = sqrt((2*mu_M)/Rm);
r_SOI_m = R_MS*(Mm/Msun)^(2/5);
fprintf("\nEscape velocity for Mars: %g km/s\nSOI radius: %g km\n", Vesc_m, r_SOI_m)

fprintf("\n\n")
