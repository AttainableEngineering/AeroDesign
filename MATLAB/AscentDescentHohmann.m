r_p = 11.2667 ;
r_d = 6.2;
ro_p = 50;
ro_d = 20;

mship = 1000; %[kg]
Mp = 10658529896187200; % [kg] - - - mass of Phobos, 10.7x10^15 kg
Md = 1476188406600740;  % [kg] - - - mass of Diemos - - 1.48x10^15 kg
G = 6.6742*10^(-20);    % [km^3/(kg*s^2)] - - - gravitational constant 

mu_p = G*(Mp + mship);
mu_d = G*(Md + mship);

[dvdp ,dvap, dvp] = HohmannDeltaV(r_p,ro_p, mu_p);


[dvdd ,dvad, dvd] = HohmannDeltaV(r_d,ro_d, mu_d);