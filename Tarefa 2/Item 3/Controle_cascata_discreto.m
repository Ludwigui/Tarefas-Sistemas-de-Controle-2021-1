clear all
close all
clc

%% Parametros Gerais

k1=6.01;
k2=0.8433;
k3=0.1123;
t_cinco = 1.5; 
t_cinco_in = 1.5/10;
Tse = t_cinco/20; %periodo de amostragem externo
Tsi = t_cinco_in/20; %periodo de amostragem interno
Tc = Tsi/10;  %período de simulação

%% Modelo Nao linearizado

%%Condições iniciais
u_int = [0 0];
u_ext = [0 0];
e_int = [0 0] ;
e_ext = [0 0.4460e-4];
Caf = [5.1 5.1];
Ca = [0 0];
Cb = [0 0];
t = [0 Tc];
ref_in(1) = 0;
ref(1) = 0;
j=0;
l=0;

%Rampa para chegar ao ponto de operação
for k=2:30000
    if (k<10001)
        ref_in(k)=ref_in(k-1)+0.0002345;
    end
    %%Filtro de referência da malha externa
    ref(k)=0.8098*ref(k-1)+0.1902*ref_in(k);
    
    if (((k-j)/100)==1) %Realização da amostragem
        j=k;
        
        %cálculo do erro da malha externa
        e_ext(k) = ref(k) - Cb(k); 
    
        %lei de controle da malha externa
        u_ext(k) = u_ext(k-1) + 0.708*e_ext(k) - 0.574*e_ext(k-1);
            
    else  %Atualização dos valores quando não há amostragem
        u_ext(k)= u_ext(k-1);
        e_ext(k)= e_ext(k-1);
    end
            
    if (((k-l)/10)==1) %Realização da amostragem
        l=k;
        %cálculo do erro da malha interna
        e_int(k) = u_ext(k) - Ca(k); 
    
        %lei de controle da malha interna
        u_int(k) = u_int(k-1) + 7.335*e_int(k) - 5.938*e_int(k-1); 
            
    else  %Atualização dos valores quando não há amostragem
        u_int(k)= u_int(k-1); 
        e_int(k)= e_int(k-1);
    end
    
    if (k==30000) %Parada da simulação
        break
    end
        
    %Simulação da planta
    Ca(k+1) = ((-k3*(Ca(k)^2)) + (((1/Tc)-k1 -u_int(k))*Ca(k)) + (Caf(k)*u_int(k))) /(1/Tc);
    Cb(k+1) = ((((1/Tc)-k2-u_int(k))*Cb(k)) + k1*Ca(k)) / (1/Tc);
     
    %Atualização das variáveis para a próxima simulação
    ref_in(k+1)=ref_in(k);
    Caf(k+1) = Caf(k);
    t(k+1) = t(k)+Tc;


   %Aplicação de um degrau de perturbação e de referência
    if (k==14999)
        Caf(k+1) = Caf(k) + 0.2;
    end
    if (k==22499)
        ref_in(k+1) = ref_in(k) + 0.1;
    end
        
end

%% Graficos

figure 
subplot(211)
plot(t,ref_in,'r',t,Cb,'b')
grid on
axis([0 22 2 2.6])
title('Saída')
ylabel('Cb')
legend('referência','saída')
subplot(212)
plot(t,Caf,'k')
grid on
axis([0 22 5 5.4])
title('Perturbação')
ylabel('Caf')

figure
set(gcf,'name','Gráfico de concentração de B')
title('Processo completo')
plot(t,ref)
hold on
plot(t,Cb)
grid on
axis([0 22 0 2.7])
legend('Referência','Saída')
xlabel('Tempo [min]')
ylabel('Concentração [mol/l]')