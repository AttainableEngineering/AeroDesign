function [deltaV_depart, deltaV_arrive, DeltaV] = HohmannDeltaV(r_per, r_apo, mu)
%%% Function takes the nearest and furthest desired radius for Hohmann transfer,
%%% and mu value of orbiting body. Outputs delta v for transit

A = (r_per + r_apo)/2; % [km]

deltaV_depart = sqrt(mu)*sqrt((2/r_per)-(1/A)) - sqrt(mu/r_per); % [km/s]
deltaV_arrive = sqrt(mu/r_apo) - sqrt(mu)*sqrt((2/r_apo)-(1/A)); % [km/s]

DeltaV = deltaV_depart + deltaV_arrive; % [km/s]
