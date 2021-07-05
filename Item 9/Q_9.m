clear all
close all
clc

%% Parametros Gerais

k1=6.01;
k2=0.8433;
k3=0.1123;
t_cinco = 1.6; 
Ts = t_cinco/20; %periodo de amostragem
Tc = Ts/10;  %per�odo de simula��o

%% Modelo Nao linearizado

%%Condi��es iniciais e inicializa��o das vari�veis
Ca = [ ];
u = [ ];
mod = [ ];
Caf = [ ];
Cb = [ ] ;
t = [ ];
e = [ ];
ref_in = [ ];
ref_out = [ ];
Ca(1) = 0;
u(1) = 1;
Caf(1) = 5.1;
Cb(1) = 0;
t(1) = 0;
ref_in(1) = 2.345;
ref_out(1) = 2.345;
j=616;

%%Simula��o do modelo obtido n�o linear obtido pelo m�todo de Euler

%Opera��o em modo manual at� os 5 minutos, levando o sistema ao ponto de
%opera��o operador define sinnal de controle (vaz�o[u]).
for i=1:625
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    u(i+1)=u(i);
    ref_in(i+1)=ref_in(i);
    ref_out(i+1)=ref_out(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    e(i)=0;
    mod(i)=0;
end

%%Passagem do sistema para o modo autom�tico aos 5 minutos (625
%%itera��es*0.08 minutos)
for i=626:1874 
    
    if (((i-j)/10)==1) %Realiza��o da amostragem a cada 10 itera��es
        j=i;
        
        %Filtro para refer�ncia
        if(i == 626)
            ref_out(i)=0.846*ref_out(i)+0.154*ref_in(i);
        
        else
            ref_out(i) = 0.846*ref_out(i-1)+0.154*ref_in(i);
        end
        
        %c�lculo do erro de seguimento de refer�ncia
        e(i) = ref_out(i) - Cb(i); 
    
        %lei de controle
        if(i == 626)
            u(i) = u(i) + 1.48*e(i) - 1.25*e(i);
      
        else
            u(i) = u(i-1) + 1.48*e(i) - 1.25*e(i-1); 
            
            
            if(u(i)>10) %Satura��o do sinal de controle (vaz�o[0-10])
                u(i)=10;
            elseif(u(i)<0)
                u(i)=0;
            end
        end
    else
        %%Atualiza��o das vari�veis, para a simula��o (realizado nas
        %%itera��es em que n�o ocorrem amostragens)
        u(i)= u(i-1);
        e(i)= e(i-1);
        ref_out(i)= ref_out(i-1);
    end
        
    %Simula��o da planta a partir do sinal de controle  do modo autom�tico
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    %Atualiza��o das vari�veis para a pr�xima simula��o
    ref_in(i+1)=ref_in(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    mod(i)=1;
    
   %Aplica��o de um degrau de perturba��o aos 7 minutos
    if (i==875)
        Caf(i+1) = Caf(i) + 0.2;
    end
    %Aplica��o de um degrau de refer�ncia aos 11 minutos
    if (i==1375)
        ref_in(i+1) = ref_in(i) + 0.2;
    end
        
end
%Ajuste do tamanho dos vetores para gerar os gr�ficos
 u(1875)=u(1874);
 e(1875)=e(1874);
 mod(1875)=mod(1874);

%% Graficos


figure 
subplot(311)
plot(t,ref_in,'r',t,Cb,'b')
grid on
axis([0 15 2 2.75])
title('Sa�da')
ylabel('Cb')
legend('refer�ncia','sa�da')
subplot(312)
plot(t,Caf,'k')
grid on
axis([0 15 5 5.4])
title('Perturba��o')
ylabel('Caf')
subplot(313)
plot(t,mod,'m')
grid on
axis([0 15 0 1.5])
title('Modo de opera��o')
ylabel('man/aut')
legend('0-manual / 1-autom�tico')

figure
set(gcf,'name','Gr�fico de concentra��o de B')
title('Processo completo')
plot(t,ref_in)
hold on
plot(t,Cb)
grid on
legend('Refer�ncia','Sa�da')
xlabel('Tempo [min]')
ylabel('Concentra��o [mol/l]')
