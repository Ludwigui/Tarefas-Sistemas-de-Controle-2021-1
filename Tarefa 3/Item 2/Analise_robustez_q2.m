clc
clear all
close all

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;

%Valores de equilíbrio para cada ponto de operação
Caf=5.1;
u=[0.45 0.6 0.9 1.1 1.3 1.5 2];
Ca=[0.35 0.459 0.657 0.779 0.894 1 1.3];
Cb=[1.64 1.91 2.26 2.41 2.51 2.574 2.64];
s = tf('s'); % variavel de Laplace

%Encontrando a família de funções de transferência

for i=1:7
    alpha1=-k1-2*k3*Ca(i)-u(i);
    alpha3=Caf-Ca(i);
    betha1=k1;
    betha2=-k2-u(i);
    betha3=Cb(i);
    Cas(i)=(alpha3)/(s-alpha1);
    Cbs(i)=(((betha1*Cas(i))-betha3)/(s-betha2));
    Pn(i)=Cbs(i)*exp(-3*s);
    
end

%FT nominal
Gn=(tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433])));

%Controlador PID
C = 6.65 * tf(conv([1 3.879],[1 3.879]),conv([1 0],[1 29]));

%Inversa de Hr
invHr=((1+C*Gn)/(C*Gn)); 

%delta para cada função do grupo de FTs calculadas
for i=1:7
    deltaPi(i)=((Cbs(i)-Gn)/Gn);
end


figure
for i=1:7
    bodemag(deltaPi(i))
    hold on
end
bodemag(invHr,'m--')

legend('delta P1', 'delta P2', 'delta P3', 'delta P4', 'delta P5', 'delta P6', 'delta P7', '1/Hr')
title('Análise de Robustez para erro de tau e Ke')



%% Gráfico normal
figure
for i=1:7
    bodemag(Cbs(i))
    hold on
end
bodemag(Gn,'k--')
legend('P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'Pn')
title('Funções de Transferência')

%% Para erros de modelagem do atraso

Gnat=(tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]))*exp(-3*s));

for i=1:5
    Cbat(i)=Gn*exp((-0.06*i-3)*s);
end

for i=1:5
    deltaPiat(i)=((Cbat(i)-Gnat)/Gn);
end

figure
for i=1:5
    bodemag(deltaPiat(i))
    hold on
end
bodemag(invHr,'k--')
legend('delta P1', 'delta P2', 'delta P3', 'delta P4', 'delta P5', '1/Hr')
title('Análise de Robustez para erro de modelagem no atraso')
