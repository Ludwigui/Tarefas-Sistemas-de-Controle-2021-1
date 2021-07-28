figure
set(gcf,'name','Gráfico de concentração de A')
title('de concentração de A')
plot(Ca.Time,Ca.Data)
hold on
plot(Cal.Time,Cal.Data)
plot (u.Time,u.Data)
grid on
axis([0 10 0 3])
legend('Modelo não linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')

figure
set(gcf,'name','Gráfico de concentração de B')
title('de concentração de B')
plot(Cb.Time,Cb.Data)
hold on
plot(Cbl.Time,Cbl.Data)
plot (u.Time,u.Data)
grid on
axis([0 10 0 3])
legend('Modelo não linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')
