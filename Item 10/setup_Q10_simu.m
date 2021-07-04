clear all
close all
clc

%% Simula��o

sim('simula_q10') % executa simula��o do modelo no Simulink

%% Gera os gr�ficos dos Resultados

figure 
subplot(211)
plot(ref1.time,ref1.data)
hold on
plot(cb1.time,cb1.data)
grid on
axis([0 40 0 2.75])
title('Sa�da')
ylabel('Concentra��o')
xlabel('Tempo [min]')
legend('refer�ncia','sa�da')
subplot(212)
plot(caf1.time,caf1.data)
grid on
axis([0 40 5 5.4])
title('Perturba��o')
ylabel('Caf')
xlabel('Tempo [min]')

figure 
subplot(211)
plot(ref2.time,ref2.data)
hold on
plot(cb2.time,cb2.data)
grid on
axis([0 40 0 2.75])
title('Sa�da')
ylabel('Concentra��o')
xlabel('Tempo [min]')
legend('refer�ncia','sa�da')
subplot(212)
plot(caf2.time,caf2.data)
grid on
axis([0 40 5 5.4])
title('Perturba��o')
ylabel('Caf')
xlabel('Tempo [min]')

figure 
subplot(211)
plot(ref3.time,ref3.data)
hold on
plot(cb3.time,cb3.data)
grid on
axis([0 40 0 2.75])
title('Sa�da')
ylabel('Concentra��o')
xlabel('Tempo [min]')
legend('refer�ncia','sa�da')
subplot(212)
plot(caf3.time,caf3.data)
grid on
axis([0 40 5 5.4])
title('Perturba��o')
ylabel('Caf')
xlabel('Tempo [min]')


figure
plot(ref3.time, ref3.data)  
grid on
hold on
plot(cb3.time,cb3.data) 
plot(cb4.time,cb4.data) 
plot(caf3.time,(caf3.data-5.1))
legend('Refer�ncia [r]','Sem anti-windup','Com anti-windup','Perturba��o [Caf]')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')
