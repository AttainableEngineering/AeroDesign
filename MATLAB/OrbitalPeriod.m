function T = OrbitalPeriod(r_per, r_apo, mu)
T = 2*pi/sqrt(mu)*((r_per + r_apo)/2)^(3/2); % [sec]
