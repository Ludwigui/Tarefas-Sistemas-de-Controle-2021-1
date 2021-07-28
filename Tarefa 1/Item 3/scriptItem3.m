clc
clear all
s = tf('s');

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;
CaEq = 0.7192;
CbEq = 2.345;
uEq = 1;
CafEq = 5.1;
sim('DiagramaDeSimulacaoItem5')
plot(ans.data3(:,1), ans.data3(:,2))
hold on
plot(ans.data3(:,1), ans.data3(:,3))
hold on
plot(ans.data3(:,1), ans.data3(:,4))
hold on
plot(ans.data3(:,1), ans.data3(:,5))

legend('C_{A} [mol/L]', 'C_{B} [mol/L]', 'C_{A}_{Eq} [mol/L]', 'C_{B}_{Eq} [mol/L]')
xlabel('Tempo [min]')
