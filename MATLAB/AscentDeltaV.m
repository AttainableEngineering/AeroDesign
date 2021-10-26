clc;clear;close;

N_eng = 4; % Number of Engines
m = 1000; % [kg] of ship 
T_vac = 1000;% [N] Thrust of Engine
sum = 0;
for ii = 1:1:N_eng-1
    sum = sum + T_vac/m ;
end

f =@(t) (sum) + 0*t;

time = [0;180]; % start;end in [s]

DV = integral(f, time(1), time(2));

fprintf("The Delta V required for ascent for:\n%g engines firing at\n%g N of thrust for\n%g seconds is\n%g m/s.\n", N_eng, T_vac, time(2), DV);