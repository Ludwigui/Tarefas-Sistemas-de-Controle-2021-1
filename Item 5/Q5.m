clear all
close all
clc
%%Modelo não linear

%Parametros Gerais
k1=6.01;
k2=0.8433;
k3=0.1123;
Tc = 0.1;

%%Condições iniciais

Ca = [];
u = [];
Caf = [];
Cb = [];
t = [];
Ca(1) = 0.7192;
u(1) = 1;
Caf(1) = 5.1;
Cb(1) = 2.345;
t(1) = 0;

%%Equacionamento pelo método de Euler

for i=1:100
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
    
    u(i+1) = u(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    
    if (i==50)
        u(i+1) = u(i) + 0.1;
    end
    
end

%%Modelo linearizado
%Parametros
Cao = 0.7192;
uo = 1;
Cafo = 5.1;
Cbo = 2.345;

%%Condições iniciais

Ca_l = [];
u_l = [];
Caf_l = [];
Cb_l = [];
t_l = [];
Ca_l(1) = 0;
u_l(1) = 0;
Caf_l(1) = 0;
Cb_l(1) = 0;
t_l(1) = 0;

%%Equacionamento pelo método de Euler

for i=1:100
    
    Ca_l(i+1) = ((Ca_l(i)*((1/Tc)-k1-2*k3*Cao-uo)) + (uo*Caf_l(i)) + (u_l(i)*(Cafo-Cao))) /(1/Tc);
    Cb_l(i+1) = ((Cb_l(i)*((1/Tc)-k2-uo)) + (Ca_l(i)*k1) - (u_l(i)*Cbo)) / (1/Tc);
    
    u_l(i+1) = u_l(i);
    Caf_l(i+1) = Caf_l(i);
    t_l(i+1) = t_l(i)+Tc;
    
    if (i==50)
        u_l(i+1) = u_l(i) + 0.1;
    end
    
end

figure
set(gcf,'name','Gráfico de concentração de A')
title('de concentração de A')
plot(t,(Ca-0.7192))
hold on
plot(t,Ca_l)
plot (t,u_l)
grid on
axis([0 10 0 0.105])
legend('Modelo não linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')

figure
set(gcf,'name','Gráfico de concentração de B')
title('de concentração de B')
plot(t,(Cb-2.345))
hold on
plot(t,Cb_l)
plot(t,u_l)
grid on
axis([0 10 0 0.105])
legend('Modelo não linear','Modelo linearizado','Entrada u')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')

