clear all
close all

s = tf('s');

%%
Pq = 0.8/(s+6.9433); % Equivalente ao ramo de Caf até Ca

Pi = 4.5067/(s+6.9433); %Equivalente a planta interna

Ci = 7.335*(s+24.4)/s; % Controlador Interno

Uq = minreal(-Ci*Pq/(1+Ci*Pi)); %U/Caf

Pqn = Uq*-2.1699/(s+1.6433); % Referente a CB/Caf malha aberta


%%%%
%Relação Cb/Caf

Pex = (-0.48*(s-5.55))/(s+ 1.64633); %Equivalente a planta externa medida em Ca

Ce = (0.728*s+2.047)/(s); %Controlador Externo

Cbq = minreal(Pqn/(1+Ce*Pex)); %Equivalente a Pq no relatório

step(Cbq)


