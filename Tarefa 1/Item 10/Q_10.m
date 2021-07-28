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
%Discretização
Puz=c2d(Pu,Ts,'zoh')
Pqz=c2d(Pq,Ts,'zoh')
Cz=(4.2253*z-3.5840)/(z-1);
H=(Cz*Puz)/(1+Cz*Puz);
H=minreal(H)
Hq=(Pqz)/(1+Cz*Puz);
Hq=minreal(Hq)

%Resposta ao degrau para Hr
figure
step(H)

%Diagrama polo-zero Hr
figure
pzmap(H)

%Diagrama de Bode Hr
figure
bode(H)

%Resposta ao degrau para Hq
figure
step(Hq)

%Diagrama polo-zero Hq
figure
pzmap(Hq)

%Diagrama de Bode Hq
figure
bode(Hq)
