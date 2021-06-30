clear all
close all
clc

%% Parametros Gerais

k1=6.01;
k2=0.8433;
k3=0.1123;
t_cinco = 1.5; 
Ts = t_cinco/20; %periodo de amostragem
Tc = Ts/10;  %período de simulação

%% Modelo Nao linearizado

%%Condições iniciais e inicialização das variáveis
Ca = [ ];
u = [ ];
a = [ ];
Caf = [ ];
Cb = [ ] ;
t = [ ];
e = [ ];
ref = [ ];
Ca(1) = 0;
u(1) = 1;
Caf(1) = 5.1;
Cb(1) = 0;
t(1) = 0;
ref(1) = 2.345;
j=991;

%%Simulação do modelo obtido não linear obtido pelo método de Euler

%Operação em modo manual até os 7,5 minutos, levando o sistema ao ponto de
%operação
for i=1:1000
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    u(i+1)=u(i);
    ref(i+1)=ref(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    e(i)=0;
    a(i)=0;
end

%%Passagem do sistema para o modo automático 
for i=1001:3000 
    
    if (((i-j)/10)==1) %Realização da amostragem
        j=i;
        
        %cálculo do erro
        e(i) = ref(i) - Cb(i); 
    
        %lei de controle
        if(i == 1001)
            u(i) = u(i) + 1.786*e(i) - 1.486*e(i);
        else
            u(i) = u(i-1) + 1.786*e(i) - 1.486*e(i-1); 
            
            if(u(i)>10) %Saturação do sinal de controle
                u(i)=10;
            elseif(u(i)<0)
                u(i)=0;
            end
        end
    else
        u(i)= u(i-1);
        e(i)= e(i-1);
    end
        
    %Simulação da planta a partir do sinal de controle automático
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    %Atualização das variáveis para a próxima simulação
    ref(i+1)=ref(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    a(i)=1;
    
   %Aplicação de um degrau de referência aos 15 minutos
    if (i==1400)
        Caf(i+1) = Caf(i) + 0.1;
    end
    if (i==2200)
        ref(i+1) = ref(i) + 0.1;
    end
        
end
%Ajuste do tamanho dos vetores para obtenção dos gráficos
 u(3001)=u(3000);
 e(3001)=e(3000);
 a(3001)=a(3000);

%% Graficos

figure
set(gcf,'name','Gráfico de concentração de A')
title('de concentração de A')
plot(t,u)
hold on
%plot(t,u)
grid on
%axis([0 10 0 0.105])
%legend('Saída','Referência')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')

figure
set(gcf,'name','Gráfico de concentração de B')
title('de concentração de B')
plot(t,ref)
hold on
plot(t,Cb)
plot(t,a)
grid on
%axis([0 10 0 0.105])
legend('Referência','Saída','Modo [man/aut]')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')
