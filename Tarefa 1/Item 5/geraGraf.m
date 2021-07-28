figure
set(gcf,'name','Gr�fico de concentra��o de A')
title('de concentra��o de A')
plot(Ca.Time,Ca.Data)
hold on
plot(Cal.Time,Cal.Data)
plot (u.Time,u.Data)
grid on
axis([0 10 0 3])
legend('Modelo n�o linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')

figure
set(gcf,'name','Gr�fico de concentra��o de B')
title('de concentra��o de B')
plot(Cb.Time,Cb.Data)
hold on
plot(Cbl.Time,Cbl.Data)
plot (u.Time,u.Data)
grid on
axis([0 10 0 3])
legend('Modelo n�o linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')
