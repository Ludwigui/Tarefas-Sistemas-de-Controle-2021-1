close all
clear all
clc

%%Determinando as Ft's equivalentes discretas
%Período de amostragem
Ts=1.6/20;
z=tf('z',Ts)

%Funções de transferência contínuas
Pu=tf([0.56],[0.59 1])
Pq=tf([0.45],[0.59 1])
Cs=tf([2.168 4.536],[0.478 0]);
Fs=tf([1],[0.477 1])

%Discretização
Puz=c2d(Pu,Ts,'zoh')
Pqz=c2d(Pq,Ts,'zoh')
Cz=c2d(Cs,Ts,'zoh')
Fz=c2d(Fs,Ts,'matched')

Hs=(Cs*Pu)/(1+Cs*Pu);
Hs=minreal(Hs)
Hz=c2d(Hs,Ts,'zoh')

Hqs=(Pq)/(1+Cs*Pu);
Hqs=minreal(Hqs)
Hqz=c2d(Hqs,Ts,'zoh')

figure
bode(Cs)
hold on
bode(Cz)
legend('Domínio S','Domínio z')

figure
bode(Hs)
hold on
bode(Hz)
legend('Domínio S','Domínio z')

figure
pzmap(Hs)
hold on
axis([-4 0 -10 10])

figure
pzmap(Hz)
