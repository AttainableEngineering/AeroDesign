function ds = EOM(t, s)
mu_s = 1.327565e11; %[km^3/s^2]
r = s(1:3);
v = s(4:6);
a = -(mu_s/(norm(r)^3))*r;
ds = [v;a];