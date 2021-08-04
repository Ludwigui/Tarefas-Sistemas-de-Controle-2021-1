close all

figure(1)
plot(R.Time,R.Data,y1.Time,y1.Data);
legend({'Ref','Cb'}, 'interpreter', 'latex');
xlabel('Tempo [s]', 'interpreter', 'latex');
ylabel('Concentração [mol/L]', 'interpreter', 'latex');
grid on

figure(2)
subplot(2,1,1)
 plot(uIn.Time,uIn.Data,uEx.Time,uEx.Data,CaDin.Time,CaDin.Data);
 ylim([0 10])
 legend({'u -Controle Interno','u -Controle Externo','Ca [mol/L]'}, 'interpreter', 'latex');
 xlabel('Tempo [s]', 'interpreter', 'latex');
 ylabel('Vazão [L/min]', 'interpreter', 'latex');
 grid on 
 
 subplot(2,1,2)
 plot(CafDin.Time,CafDin.Data);
 legend({'Pertubação'}, 'interpreter', 'latex');
 xlabel('Tempo [s]', 'interpreter', 'latex');
 ylabel('Concentração [mol/L]', 'interpreter', 'latex');
 grid on 
 
%% 
 figure(1)
plot(R.Time,R.Data,y1.Time,y1.Data,y.Time,y.Data);
legend({'Ref','Cb Cascata','Cb etapa 1' }, 'interpreter', 'latex');
xlabel('Tempo [s]', 'interpreter', 'latex');
ylabel('Concentração [mol/L]', 'interpreter', 'latex');
grid on

figure(2)
subplot(2,1,1)
 plot(uIn.Time,uIn.Data,uEx.Time,uEx.Data,CaDin.Time,CaDin.Data,uIn1.Time,uIn1.Data);
 legend({'u -Controle Interno','u -Controle Externo','Ca [mol/L]','u -Controle etapa 1' }, 'interpreter', 'latex');
 xlabel('Tempo [s]', 'interpreter', 'latex');
 ylabel('Vazão [L/min]', 'interpreter', 'latex');
 grid on 
 
 subplot(2,1,2)
 plot(CafDin.Time,CafDin.Data);
 legend({'Pertubação'}, 'interpreter', 'latex');
 xlabel('Tempo [s]', 'interpreter', 'latex');
 ylabel('Concentração [mol/L]', 'interpreter', 'latex');
 grid on 




%% 
% 
% 
% subplot(3,1,3)
% plot(Umf.Time,Umf.Data,Ud.Time,Ud.Data);
% legend({'u(s)','u(s) anti-wind.'}, 'interpreter', 'latex');
% xlabel('Tempo [s]', 'interpreter', 'latex');
% ylabel('Tens\~ao [V]', 'interpreter', 'latex');
% 
% % subplot(2,1,1);
% % plot(y_nl.Time,y_nl.Data,R.Time,R.Data);
% % legend({'Sa\''ida','Refer\^encia'}, 'interpreter', 'latex');
% % xlabel('Tempo [s]', 'interpreter', 'latex');
% % ylabel('Tens\~ao [V]', 'interpreter', 'latex');
% % 
% % subplot(2,1,2);
% % plot(Umf.Time,Umf.Data);
% % xlabel('Tempo [s]', 'interpreter', 'latex');
% % ylabel('A\c{c}\~ao de controle [V]', 'interpreter', 'latex');
