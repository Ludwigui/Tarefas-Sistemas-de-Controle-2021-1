clear all
close all
clc

%% Configuraçao janela

%Gerando graficos da questao 2
sim('Simu_q2')

figure
plot(Ref.Time,Ref.Data)
hold on
plot(Cb.Time, Cb.Data)
%plot(Pert.Time, (Pert.Data-5.1),'g')
plot(u.Time, u.Data)
axis([0 150 0 3])
legend('Referência', 'Cb', 'Sinal de controle')
xlabel('Tempo [min]')
ylabel('Concentracao [mol/L]')
title('Resposta dinamica para Cb')