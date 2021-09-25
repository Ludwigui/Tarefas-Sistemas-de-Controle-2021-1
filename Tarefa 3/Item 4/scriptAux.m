clear all
close all

s= tf('s');
L = 3;
C = (6.65*(s+3.87)^2)/(s*(s+29));
Gu = (-2.1699*s+12.0873)/((s+6.9433)*(s+1.6433));
Gq = 4.808/((s+6.9433)*(s+1.6433));
G = Gu*exp(-L*s);

Ceq = C/(1+C*Gu-C*Gu*exp(-L*s));
Hmf = minreal(Ceq*G/(1+Ceq*G));

%P estimada
Ge = 0.667*exp(-3.3*s)/((0.45*s+1)*(0.2*s+1));

%%
L = 3.3;
t1 = 0.45;
t2 = 0.2;
Ke = 0.667;


Ti = t1;
Td = t2;
Kc= (1/(2*L))*(1/(Ke/Ti));

C = Kc*(1+1/(Ti*s))*(1+Td*s);
F = ((2.22)*(1.64)*5)/((s+2.22)*(s+1.64)*(s+5));

%%

plot(Ref.Time,Ref.Data)
hold on
plot(CaDin.Time, CaDin.Data)
% hold on
% plot(CaDin1.Time, CaDin1.Data)
legend('Ref', 'Cb')
xlabel('Tempo [min]')
ylabel('Concentracao [mol/L]')

%%

figure
subplot(2,1,1);
plot(Ref.Time,Ref.Data)
hold on
plot(CaDin.Time, CaDin.Data)
legend('Ref', 'Cb')
xlabel('Tempo [min]')
ylabel('Concentracao [mol/L]')
ylim([0 4])
subplot(2,1,2)
plot(u.Time,u.Data)
ylim([0 6])
hold on
plot(Caf.Time, Caf.Data+5.1)
xlabel('Tempo [min]')
ylabel('Concentracao [mol/L]')
legend('u', 'Caf')