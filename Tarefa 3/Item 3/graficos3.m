%% Configuraçao janela

%Gerando graficos da questao 2
sim('item3ModeloNLinPS')

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
plot(sp1.Time,sp1.Data, '- g')
hold on
plot(pv.Time, pv.Data, '-b')
hold on
plot(pv2.Time, pv2.Data, '-k')
hold on
%plot(pert.Time,pert.Data, 'y')
%axis([0 121 0 4])
legend('SP perto', 'SP longe',  'PV perto', 'PV longe')
xlabel('Tempo [min]')
ylabel('Concentracao  [mol/L]')
title('Resposta Cb com variacao perto e longe do ponto de operacao')


figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(pert.Time,pert.Data, 'y')
%axis([0 121 0 4])
legend('perturbacao')
xlabel('Tempo [min]')
ylabel('Concentracao  [mol/L]')
title('Sinal de perturbacao')

figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(uDin.Time,uDin.Data, '- r')
hold on
plot(uDin1.Time,uDin1.Data, '- g')
legend('MV perto', 'MV longe')
xlabel('Tempo [min]')
ylabel('Sinal de controle [u]')
title('Sinal de controle com variacao perto e longe do ponto de operacao')