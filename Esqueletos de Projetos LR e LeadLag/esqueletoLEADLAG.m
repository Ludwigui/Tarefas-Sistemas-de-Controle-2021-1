clear all
close all
clc

%Controle PI

%% Parametros da planta
Ke = ;    %ganho estatico da planta
tau = ;   %constante de tempo da equação linearizada perto do ponto de equilibrio

%% Especificacoes MF
t_5 =     %tempo de 5%
pico =   %sobressinal % sempre em valor ABSOLUTO

syms zeta wn

%fator de amortecimento (zeta)
fa= vpa(solve((pico ==  exp((-pi*zeta)/(sqrt(1 - zeta^2)))))); 
fa = fa(1,:); 

%frequencia natural (wn)
wn = vpa(solve(t_5 == (3/(fa*wn))));    %para 0 < Xi <= 0.7 
wn = vpa(solve(t_5 == (4.8/(fa*wn)))); %para 0.8 <= Xi <= 1
wn = vpa(solve(t_5 == 1.5*tau_rapido + 3*tau_lento)); %para 0.8 > Xi > 1

%ponto desejado
sd_imPositivo =  -fa*wn  + 1i*wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn - 1i*wn*sqrt(1-fa^2);   %parte real negativa

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada
sd = -fa*wn  + 1i*wn*sqrt(1-fa^2); 

fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd) - zero))));
fase2 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)))));
fase3 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd) - polo))));

faseConhecida = fase1 - (fase2 + fase3);

faseTotal = 0; %se  K<0
faseTotal = -180; %se K>0

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));

%zeros SEMPRE a esquerda da localizacao do sd para nao afetar a dominancia
% Calculando a localizacao do zero do controlador:
zero =  -1*real(sd) +  (imag(sd))/tan(deg2rad(double(faseDesconhecida)));

%% Calculando K
syms K
s = sd_imPositivo;
Kc_pos = double(vpa(solve(((1 + PM == 0)))));
s = sd_imNegativo;
Kc_neg = double(vpa(solve((1+ PM == 0))));

Kc = real(Kc_pos);

%% Funcoes de transferencia contínuas 

s = tf('s'); % variavel de Laplace

%FT da planta P(s) sem perturbação
P = Ke/(1+s*tau);
[num_P,den_P] = tfdata(P);

% %%  Funcao de transferencia do Controlador por Avanço de Fase
Cav = Kc*((s+zero))/(s+polo);
[num_Cav,den_Cav] = tfdata(Cav);


 %% Projetando o Controlador por Atraso de Fase

%Especificacao
ke_mf_desejado = ; %ganho de MF deve ser maior ou igual a 0.95

ke_mf_atual = (dcgain(P)*dcgain(Cav))/(1 + dcgain(P)*dcgain(Cav));

%Calculando ke do controlador, ou seja, calculando C(0),  tal que ke_mf = ke_mf_desejado
syms Cd  
C_0 = double(vpa(solve( (dcgain(P)*Cd) / (1 + dcgain(P)*Cd)  == ke_mf_desejado))); %valor de C(0) 

%entao, calculamos o ganho do Controlador de atraso de fase:
syms C_atraso
Ganho_Cat = double(solve(vpa(C_0 == Kc*C_atraso)));

%Escolhendo zero 10x menor que o modulo do ponto desejado:
%z_at = abs(sd)/10; %primeiro ajuste

%Escolhendo zero 3x menor que o modulo do ponto desejado:
z_at = abs(sd)/3; %segundo ajuste

%calculando o zero do Controlador de atraso:
syms polo
p_at = double(vpa(solve(Ganho_Cat == z_at/polo)));

%% Funcao de transferencia do Controlador Atraso
s = tf([1 0],[1]); % variavel de Laplace

Cat =(s + z_at)/(s + p_at);
[num_Cat,den_Cat] = tfdata(Cat);
rlocus(Cat*P)
pzmap(Cat)

%% Controlador Lead_Lag: atraso e avanco

C_leadlag = Cav*Cat

%% FTs de Malha Fechada para Y/R

%FT de Y/R -->  Velocidade/Tensão
 Hr =  (C_leadlag*P)/(1 + C_leadlag*P);
 [num_Hr,den_Hr] = tfdata(Hr);
 Hr = minreal(Hr);

% LR  do den da FT de MF considerando o controlador total (avanço+atraso)
rlocus(P*C_leadlag)
title('LR do denominador da FT de MF Y/R para Controlador avanco e atraso')
figure
pzmap(Hr)
 
%% Definicao do Periodo de amostragem (time sample)  
%  
% % %Periodo de amostragem calculado pelo criterio do tau de MF
step(Hr)
title('Medindo a cte de tempo de MF com Cat')
tau_mf = ; %tempo que a resposta leva para atingir 63% do valor de reg permanente
Ts = tau_mf/20;      %periodo de amostragem

%% Discretizacao por Invariancia ao degrau
Planta_id = c2d(P, Ts, 'zoh');
Cdcat_id = c2d(Cat, Ts, 'zoh');
Cd_id = c2d(C_leadlag, Ts, 'zoh')

% %  %%compara a resposta em frequencia do controlador continuo com as aprox discretas
figure
h = bodeoptions;
h.PhaseMatching = 'on';
bodeplot(C_leadlag,'k',Cd_id,'-r',Cav,'g', {0.1 10},h)
legend('Lead-Lag Continuo',' Lead-Lag ZOH', 'Lead Continuo', 'Location','SouthWest')
title('Com tempo de amostragem igual a 0.00575s')   

 