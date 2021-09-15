clear all
close all
clc

%Código para projetar PS
s = tf('s');

% Funcoes de transferencia entre PV, MV e Perturbacao
Gq = tf([0 4.808], conv([1 6.9433],[1 1.6433])); %expressao da FT perturbacao
Gu    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  %expressao da planta sem atraso
C =(6.6534*((s+3.879)^2))/(s*(s+28.98)); % controlador primario
F = tf([0 1], [0.06645 0.5155 1]); %filtro de referencias


%% Funcoes de transferencia de Cb/R e Cb/Caf

%Ft Cb/R com Preditor de Smith
Hr = zpk(minreal((C*Gu*F)/(1+C*Gu)));

%funcao de transferencia de malha fechada de Y/Q
Hq =  minreal((Gq)/(1 + (C*Gu)));
[num_Hq,den_Hq] = tfdata(Hq);

%% Configuraçao janela

%Gerando graficos da questao 2
sim('item1PS')

screenSize = get(0,'screensize'); % gets screen size
monWidth = screenSize(3);
monHeight = screenSize(4);
offHeight = 0; % assumed height of system task bar
monHeight = monHeight - offHeight; % usable screen height
% establishing a 2x3 grid on the screen
figHeight = monHeight/2;
figWidth = monWidth/3;


figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(sp.Time,sp.Data, '- r')
hold on
plot(pv.Time, pv.Data, '-b')
hold on
plot(pert.Time,pert.Data)
%axis([0 121 0 4])
legend('SP', 'PV', 'pert')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb')



 