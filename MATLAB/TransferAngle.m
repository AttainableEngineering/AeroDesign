function [align, alignd] = TransferAngle(r_per, r_apo)
%%% Takes the desired starting and ending radius of orbit and calculates
%%% the optimal transfer angle for Hohmann Transfer
align = pi*(1 - (sqrt(((r_per/r_apo)+1)^3)/(2*sqrt(2))));
alignd = 180/pi*align;
