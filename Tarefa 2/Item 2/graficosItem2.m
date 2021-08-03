%% Configuraçao janela

%Gerando graficos da questao 2
sim('item2ModeloNLin')

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
plot(y1.Time,y1.Data, '- r')
hold on
plot(y2.Time, y2.Data, '-b')
hold on
%axis([0 121 0 4])
legend('Perto do ponto de operação', 'Longe do ponto de operação')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb no modelo Não Linear')

figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(y1.Time, y1.Data, '-b')
hold on
plot(yantes.Time,yantes.Data, '- r')
hold on
%axis([0 121 0 4])
legend('Cb com PID Tarefa 2', 'Cb com PI Tarefa1')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb')

figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(y2.Time, y2.Data, '-b')
hold on
plot(yantes.Time,yantes.Data, '- r')
hold on
%axis([0 121 0 4])
legend('Cb com PID Tarefa 2', 'Cb com PI Tarefa1')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb')
