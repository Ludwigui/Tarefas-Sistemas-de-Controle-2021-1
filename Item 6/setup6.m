clear all
close all

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;

Ts = 0.08;
z = tf('z',Ts);
s = tf('s');

Pz = 0.56*(1-0.873)/(z-0.873);


C = 4.53*(1+0.478*s)/(0.478*s);

%H = C*Pz/(1+C*Pz);

Hr = (-2.34*s+9.51)/((s+1.84)*(s+7.17));
Hmf= minreal(C*Hr/(1+C*Hr));

pzmap(Hmf)
step(Hmf)

Hq = (6.01)/((s+1.84)*(s+7.17));
Hqmf= minreal(Hq/(1+C*Hr));
