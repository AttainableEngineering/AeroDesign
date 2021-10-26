function ds = EOM_Mars(t, s)
mu_m = 4.282787420600000e4; %[km^3/s^2]
r = s(1:3);
v = s(4:6);
a = -(mu_m/(norm(r)^3))*r;
ds = [v;a];