%% Configuraçao janela

%Gerando graficos da questao 2
sim('comparaCascataFF')

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
plot(y.Time,y.Data, '- r')
hold on
plot(y1.Time, y1.Data, '-b')
hold on
%axis([0 121 0 4])
legend('Controle em Cascata', 'Controle FEEDFORWARD')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb.')


