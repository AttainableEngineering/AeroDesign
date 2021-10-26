clc;clear;close;
figure(1)
grid on
hold on

r_Ms = 227940000/2;

plot3(linspace(0,2*r_Ms),zeros(100),zeros(100),'k','linewidth',2)
plot3(zeros(100),linspace(0,2*r_Ms),zeros(100),'k','linewidth',2)
plot3(zeros(100),zeros(100),linspace(0,2*r_Ms),'k','linewidth',2)
axis equal

[X,Y,Z] = sphere;
props.FaceColor= 'yellow';
props.EdgeColor = 'none';

R_sun = 6696340;
s=surface(R_sun*X,R_sun*Y,R_sun*Z,props);
xlabel('x [km]');ylabel('y [km]');zlabel('z [km]')

