%% Solving Orbital EOM's for Patched Conics to Mars
%%% Done with Orbital Elements to track relative positions
% Code by Carlos Ortiz

%% Initialize
clc;clear;close all;
fprintf("Initializing: \n")

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

% Mean Solar Distance for Earth & Mars to Sun
r_Es = 149.60e6;        % [km]
r_Ms = 227.94e6;        % [km]

% Orbital Period
T_E = (2*pi)/(mu_S)^(1/2)*r_Es^(3/2); % [sec]
T_M = (2*pi)/(mu_S)^(1/2)*r_Ms^(3/2); % [sec]
% Period of ship after transfer is initiated
Tship = 2*pi/sqrt(mu_S)*((r_Es + r_Ms)/2)^(3/2); % [sec]

%% Earth: Orbital Elements
% Solve with orbital elements approach and display results
fprintf("...Calculating Earth's Orbit...\n")

% orbital elements at initial time
a_E = r_Es; %semi-major axis [kilometers] 
enorm_E = 0; %eccentricity. 
inclination_E = 0; %inclination [degrees]
RAAN_E = 0; %  right ascension of the ascending node [degrees]
arg_per_E = 0; % argument of perigee [degrees]
true_anomaly_E = 0; %True anomaly [degrees]

% Converting orbital parameters to ECI cartsian coordinates 
r_E = zeros(3,1); %fill r vector with zeroes
v_E = zeros(3,1); %fill v vector with zeroes

p_E = a_E*(1-enorm_E^2); %intermediate variable
q_E = p_E/(1 + enorm_E*cosd(true_anomaly_E));%intermediate variable

% Creating r vector in pqw coordinates
R_pqw_E(1,1) = q_E*cosd(true_anomaly_E);
R_pqw_E(2,1) = q_E*sind(true_anomaly_E);
R_pqw_E(3,1) = 0;
    
% Creating v vector in pqw coordinates    
V_pqw_E(1,1) =-(mu_S/p_E)^.5*sind(true_anomaly_E);
V_pqw_E(2,1) =((mu_S/p_E)^.5)*(enorm_E + cosd(true_anomaly_E));
V_pqw_E(3,1) =   0;

% Solving for 313 rotation matrices
R1_i_E = [1 0 0; 0 cosd(inclination_E) sind(inclination_E); 0 -sind(inclination_E) cosd(inclination_E)];
R3_Om_E = [cosd(RAAN_E) sind(RAAN_E) 0; -sind(RAAN_E) cosd(RAAN_E) 0; 0 0 1];
R3_om_E = [cosd(arg_per_E) sind(arg_per_E) 0; -sind(arg_per_E) cosd(arg_per_E) 0; 0 0 1];

support_var_E = R3_om_E*R1_i_E*R3_Om_E; %Intermediate variable
support_var_E=support_var_E'; %Transposed

r_E(:,1)=support_var_E*R_pqw_E; %Radius r [km] in ECI Cartesian
v_E(:,1)=support_var_E*V_pqw_E; %Velocity v [km/s] in ECI Cartesian
%%%%%FROM ORBITAL ELEMENTS TO STATE VECTOR (END)

% Numerical integration of Cartesian State Vector
Y0_E = [r_E; v_E];
% Uncomment 2 lines down and uncomment 1 for full period
%tf_E = T_E; %s
tf_E = Tship/2;
TSPAN_E = [0 tf_E]; %duration of integration in seconds
OPTIONS = odeset('Maxstep', 10);
[TOUT_E,YOUT_E] = ode45(@EOM,TSPAN_E,Y0_E,OPTIONS);

% Initialize Figure, integrate and display with sun in center
figure(1)
grid on
hold on

% Create a sun in the figure
R_sun = 6696340; %[km]
[X,Y,Z] = sphere;
props.FaceColor= 'yellow';
props.EdgeColor = 'none';
s=surface(R_sun*X,R_sun*Y,R_sun*Z,props);

plot3(YOUT_E(:,1),YOUT_E(:,2),YOUT_E(:,3),'b')

fprintf("...Finished Plotting Earth's Orbit...\n")

%% Ship Trajectory:
% Solved using earth's orbital elements with an additional velocity
% in the prograde direction for transfer to mars

fprintf("...Calculating Ship's Trajectory...\n")

% Delta V of transfer
deltaV_depart = 2.94509; % [km/s] >>> found from MarsDeltaV.m

% Construct state vector
v_S = v_E;
v_S(2) = v_S(2) + deltaV_depart;
Y0_S = [r_E; v_S];

% Half period till intersect (180 degrees traveled)
tf_S = Tship/2;
TSPAN_S = [0 tf_S]; %duration of integration in seconds

% Integrate and display
[TOUT_S,YOUT_S] = ode45(@EOM,TSPAN_S,Y0_S,OPTIONS);
plot3(YOUT_S(:,1),YOUT_S(:,2),YOUT_S(:,3),'w--')

fprintf("...Finished Plotting Ship's Trajectory...\n")

%% Mars: Orbital Elements Method
% Solve with orbital elements approach and display results
fprintf("...Calculating Mars's Orbit...\n")

% Transfer angle found from MarsDeltaV.m. Initial pos'n ahead of earth
transfer_angle = 44.3433;

% Orbital elements at initial time
a_M = r_Ms; %semi-major axis [kilometers] 
enorm_M = 0; %eccentricity. 
inclination_M = 0; %inclination [degrees]
RAAN_M = 0; %  right ascension of the ascending node [degrees]
arg_per_M = 0; % argument of perigee [degrees]
true_anomaly_M = transfer_angle; %True anomaly [degrees]

% Converting orbital parameters to ECI cartsian coordinates 
r_M=zeros(3,1); %fill r vector with zeroes
v_M=zeros(3,1); %fill v vector with zeroes

p_M=a_M*(1-enorm_M^2); %intermediate variable
q_M=p_M/(1+enorm_M*cosd(true_anomaly_M));%intermediate variable

% Creating r vector in pqw coordinates
R_pqw_M(1,1) = q_M*cosd(true_anomaly_M);
R_pqw_M(2,1) = q_M*sind(true_anomaly_M);
R_pqw_M(3,1) = 0;
    
% Creating v vector in pqw coordinates    
V_pqw_M(1,1) =-(mu_S/p_M)^.5*sind(true_anomaly_M);
V_pqw_M(2,1) =((mu_S/p_M)^.5)*(enorm_M + cosd(true_anomaly_M));
V_pqw_M(3,1) =   0;

% Solving for 313 rotation matrices
R1_i_M = [1 0 0; 0 cosd(inclination_M) sind(inclination_M); 0 -sind(inclination_M) cosd(inclination_M)];
R3_Om_M = [cosd(RAAN_M) sind(RAAN_M) 0; -sind(RAAN_M) cosd(RAAN_M) 0; 0 0 1];
R3_om_M = [cosd(arg_per_M) sind(arg_per_M) 0; -sind(arg_per_M) cosd(arg_per_M) 0; 0 0 1];

support_var_M = R3_om_M*R1_i_M*R3_Om_M; %Intermediate variable
support_var_M=support_var_M'; %Transposed

r_M(:,1)=support_var_M*R_pqw_M; %Radius r [km] in ECI Cartesian
v_M(:,1)=support_var_M*V_pqw_M; %Velocity v [km/s] in ECI Cartesian
%%%%%FROM ORBITAL ELEMENTS TO STATE VECTOR (END)

% Create a state vector to integrate from orbital elements
Y0_M = [r_M; v_M];

%tf_M = T_M; %s  WHOLE orbital period
% Comment next 2 line and uncomment previous for whole orbital period
A = (r_Es + r_Ms)/2;
tf_M = pi*sqrt(A^3/mu_S); % [s] time to complete one transfer
TSPAN_M = [0 tf_M]; %duration of integration in seconds

% Integrate and display
[TOUT_M,YOUT_M] = ode45(@EOM,TSPAN_M,Y0_M,OPTIONS);
plot3(YOUT_M(:,1),YOUT_M(:,2),YOUT_M(:,3),'r')

fprintf("...Finished Plotting Mars's Orbit...\n")

%% Finishing touches
fprintf("...Finishing Touches...\n")

% Give axis lables and a title
xlabel("ECI X-Axis: [km]")
ylabel("ECI Y-Axis: [km]")
lgnd = legend("{\color{yellow}Sun}","{\color{blue}Earth's Orbit}","{\color{white}Spacecraft Trajectory}","{\color{red}Mars's Orbit}",'AutoUpdate','off','Location','southeast');
title("Hohmann Transfer to Mars from Earth")
% Configure size, shape, and color
xlim([-3.4e8 3.4e8])
ylim([-3.4e8 3.4e8])
axis square
set(gca,'Color','k')
set(lgnd,'color','none')

% Plot beginnings and endpoints of every line:
% Earth:
plot3(YOUT_E(1,1),YOUT_E(1,2),YOUT_E(1,3),'c.')
plot3(YOUT_E(end,1),YOUT_E(end,2),YOUT_E(end,3),'b*')

% Ship
plot3(YOUT_S(1,1),YOUT_S(1,2),YOUT_S(1,3),'c.')
plot3(YOUT_S(end,1),YOUT_S(end,2),YOUT_S(end,3),'w*')

% Mars
plot3(YOUT_M(1,1),YOUT_M(1,2),YOUT_M(1,3),'c.')
plot3(YOUT_M(end,1),YOUT_M(end,2),YOUT_M(end,3),'rd')


fprintf("\nDisplaying:\n\n")