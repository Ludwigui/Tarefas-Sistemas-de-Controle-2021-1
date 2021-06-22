clc
clear all

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;
V = 100;
sim('DiagramaDeSimulacaoItem2')
%% Realização do ensaio sugerido pelo enunciado:

plot(ans.data(:,1), ans.data(:,2))
hold on
plot(ans.data(:,1), ans.data(:,3))
hold on
plot(ans.data(:,1), ans.data(:,4))
hold on
plot(ans.data(:,1), ans.data(:,5))
hold on
legend('C_{A} [mol/L]', 'C_{B} [mol/L]', 'u [1/min]', 'C_{af} [mol/L]')
xlabel('Tempo [min]')
