clear all
close all
clc

%% Parametros Gerais

k1=6.01;
k2=0.8433;
k3=0.1123;
t_cinco = 1.5; 
Ts = t_cinco/20; %periodo de amostragem
Tc = Ts/10;  %per�odo de simula��o

%% Modelo Nao linearizado

%%Condi��es iniciais e inicializa��o das vari�veis
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

%%Simula��o do modelo obtido n�o linear obtido pelo m�todo de Euler

%Opera��o em modo manual at� os 7,5 minutos, levando o sistema ao ponto de
%opera��o
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

%%Passagem do sistema para o modo autom�tico 
for i=1001:3000 
    
    if (((i-j)/10)==1) %Realiza��o da amostragem
        j=i;
        
        %c�lculo do erro
        e(i) = ref(i) - Cb(i); 
    
        %lei de controle
        if(i == 1001)
            u(i) = u(i) + 1.786*e(i) - 1.486*e(i);
        else
            u(i) = u(i-1) + 1.786*e(i) - 1.486*e(i-1); 
            
            if(u(i)>10) %Satura��o do sinal de controle
                u(i)=10;
            elseif(u(i)<0)
                u(i)=0;
            end
        end
    else
        u(i)= u(i-1);
        e(i)= e(i-1);
    end
        
    %Simula��o da planta a partir do sinal de controle autom�tico
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    %Atualiza��o das vari�veis para a pr�xima simula��o
    ref(i+1)=ref(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    a(i)=1;
    
   %Aplica��o de um degrau de refer�ncia aos 15 minutos
    if (i==1400)
        Caf(i+1) = Caf(i) + 0.1;
    end
    if (i==2200)
        ref(i+1) = ref(i) + 0.1;
    end
        
end
%Ajuste do tamanho dos vetores para obten��o dos gr�ficos
 u(3001)=u(3000);
 e(3001)=e(3000);
 a(3001)=a(3000);

%% Graficos

figure
set(gcf,'name','Gr�fico de concentra��o de A')
title('de concentra��o de A')
plot(t,u)
hold on
%plot(t,u)
grid on
%axis([0 10 0 0.105])
%legend('Sa�da','Refer�ncia')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')

figure
set(gcf,'name','Gr�fico de concentra��o de B')
title('de concentra��o de B')
plot(t,ref)
hold on
plot(t,Cb)
plot(t,a)
grid on
%axis([0 10 0 0.105])
legend('Refer�ncia','Sa�da','Modo [man/aut]')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')
