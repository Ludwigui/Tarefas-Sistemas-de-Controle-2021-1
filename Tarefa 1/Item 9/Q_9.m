clear all
close all
clc

%% Parametros Gerais

k1=6.01;
k2=0.8433;
k3=0.1123;
t_cinco = 1.6; 
Ts = t_cinco/20; %periodo de amostragem
Tc = Ts/10;  %período de simulação

%% Modelo Nao linearizado

%%Condições iniciais e inicialização das variáveis
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

%%Simulação do modelo obtido não linear obtido pelo método de Euler

%Operação em modo manual até os 5 minutos, levando o sistema ao ponto de
%operação operador define sinnal de controle (vazão[u]).
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

%%Passagem do sistema para o modo automático aos 5 minutos (625
%%iterações*0.08 minutos)
for i=626:1874 
    
    if (((i-j)/10)==1) %Realização da amostragem a cada 10 iterações
        j=i;
        
        %Filtro para referência
        if(i == 626)
            ref_out(i)=0.846*ref_out(i)+0.154*ref_in(i);
        
        else
            ref_out(i) = 0.846*ref_out(i-1)+0.154*ref_in(i);
        end
        
        %cálculo do erro de seguimento de referência
        e(i) = ref_out(i) - Cb(i); 
    
        %lei de controle
        if(i == 626)
            u(i) = u(i) + 1.48*e(i) - 1.25*e(i);
      
        else
            u(i) = u(i-1) + 1.48*e(i) - 1.25*e(i-1); 
            
            
            if(u(i)>10) %Saturação do sinal de controle (vazão[0-10])
                u(i)=10;
            elseif(u(i)<0)
                u(i)=0;
            end
        end
    else
        %%Atualização das variáveis, para a simulação (realizado nas
        %%iterações em que não ocorrem amostragens)
        u(i)= u(i-1);
        e(i)= e(i-1);
        ref_out(i)= ref_out(i-1);
    end
        
    %Simulação da planta a partir do sinal de controle  do modo automático
    Ca(i+1) = ((-k3*(Ca(i)^2)) + (((1/Tc)-k1 -u(i))*Ca(i)) + (Caf(i)*u(i))) /(1/Tc);
    Cb(i+1) = ((((1/Tc)-k2-u(i))*Cb(i)) + k1*Ca(i)) / (1/Tc);
     
    %Atualização das variáveis para a próxima simulação
    ref_in(i+1)=ref_in(i);
    Caf(i+1) = Caf(i);
    t(i+1) = t(i)+Tc;
    mod(i)=1;
    
   %Aplicação de um degrau de perturbação aos 7 minutos
    if (i==875)
        Caf(i+1) = Caf(i) + 0.2;
    end
    %Aplicação de um degrau de referência aos 11 minutos
    if (i==1375)
        ref_in(i+1) = ref_in(i) + 0.2;
    end
        
end
%Ajuste do tamanho dos vetores para gerar os gráficos
 u(1875)=u(1874);
 e(1875)=e(1874);
 mod(1875)=mod(1874);

%% Graficos


figure 
subplot(311)
plot(t,ref_in,'r',t,Cb,'b')
grid on
axis([0 15 2 2.75])
title('Saída')
ylabel('Cb')
legend('referência','saída')
subplot(312)
plot(t,Caf,'k')
grid on
axis([0 15 5 5.4])
title('Perturbação')
ylabel('Caf')
subplot(313)
plot(t,mod,'m')
grid on
axis([0 15 0 1.5])
title('Modo de operação')
ylabel('man/aut')
legend('0-manual / 1-automático')

figure
set(gcf,'name','Gráfico de concentração de B')
title('Processo completo')
plot(t,ref_in)
hold on
plot(t,Cb)
grid on
legend('Referência','Saída')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')
