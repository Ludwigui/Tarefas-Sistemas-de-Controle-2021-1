clear all
close all
clc

%Projeto de Controle Digital Direto

%% Parametros da planta
Ke =      %ganho estatico da planta
tau =     %constante de tempo da equação linearizada perto do ponto de equilibrio

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

%frequencia amortecida
wd = wn*sqrt(1-fa^2);

%ponto desejado
sd_imPositivo =  -fa*wn  + 1i*wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn - 1i*wn*sqrt(1-fa^2);   %parte real negativa

%conversao de sd em zd
zd_fase = Tsin*wd;                 %fase do numero complexo zd 
zd_mod = exp(-fa*wn*Tsin);   %modulo do numero complexo zd 
[zd_mod,zd_fase] = pol2cart(zd_fase,zd_mod);   %transformacao polar em cartesiano

%ponto desejado (no dominio z)
zd_imPositivo = zd_mod + 1i*zd_fase;  %parte real positiva
zd_imNegativo = zd_mod - 1i*zd_fase;  %parte real negativa

zd =  zd_mod + 1i*zd_fase;

%% Discretizando as FTs ja conhecidas
Gi_d =  c2d( tf([N],[D]),Tsin, 'zoh');
Gr_d = c2d( tf([N],[D]),Tsin, 'zoh');

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada

%zeros e  polos do LR (apos colocar na  forma monica)
zeroNum = ;
polo1 = 1;
polo2 = ;
polo3 = ;

fase1 = 180 - rad2deg(double(atan( abs(imag(zd))/(zeroNum -1*real(zd))))); 
fase2 = 180 - rad2deg(double(atan( abs(imag(zd))/(polo1 - 1*real(zd))))); 
fase3 = 180 - rad2deg(double(atan( abs(imag(zd))/(polo2 - 1*real(zd))))); 
fase4 = rad2deg(double(atan( abs(imag(zd))/(real(zd)-  polo3)))); 

faseConhecida = fase1 - (fase2 + fase3 + fase4);

faseTotal = 0; %se  K<0
faseTotal = -180; %se  K>0

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));

paf = abs(zd)^10;

%calculando a fase do paf
fase_paf = rad2deg(double(atan( abs(imag(zd))/(real(zd) - paf)))); 

%recalculando a fase total desonhecida:
faseDesconhecidaNova = fase_paf + faseDesconhecida;

%com essa nova fase desconhecida, calculamos a localizacao dos zeros tq
%eles contribuam com a  fase 2*x --> ou  seja --> cada zero contribui com x

%zeros SEMPRE a esquerda da localizacao do sd para nao afetar a dominancia
% Calculando a localizacao do zero do controlador:
zero = real(zd) - double((imag(zd))/tan(deg2rad(double( (faseDesconhecidaNova/2))))) ;

%Prova real
fasePROVAreal = rad2deg(double(atan( abs(imag(zd))/(real(zd) - zero))));

%% Calculando K
syms K
z = zd_imPositivo;
Kc_pos = double(vpa(solve(((1 + PM == 0)))));
z = zd_imNegativo;
Kc_neg = double(vpa(solve((1+ PM == 0))));

Kc = real(Kc_pos);

%% Funcoes de transferencia discretizadas
 
z = tf('z',Tsin); % variavel Z

%FT do controlador PID
C_d = Kc*(z-zero)^2/((z-paf)*(z-polo1));
[num_C_d,den_C_d] = tfdata(C_d);

%FTdo  Gi_d
Gi_dz =  (N)/(D); 
[num_Gi_dz, den_Gi_dz] =  tfdata(Gi_dz);


%% FT de MF Y/R

%funcao de transferencia de malha fechada de Y/R
Hr =  zpk((C_d*Gi_dz)/(1 + (ganho*C_d*Gi_dz)));
[num_Hr, den_Hr] = tfdata(Hr);

%% FT Y/Q
Hq = zpk((Gi_dz)/(1+(C_d*Gi_dz)));
[num_Hq, den_Hq] = tfdata(Hq);
%% FT U/R
Hur = zpk(C_d/(1+Gi_dz*C_d));
[num_Hur, den_Hur] = tfdata(Hur);
%% FT U/Q
Huq = zpk(-Gi_dz*C_d/(1+Gi_dz*C_d));
[num_Huq, den_Huq] = tfdata(Huq);
%%  Desenhando o LR e plotando as respostas em MF
figure(1)
rlocus(C_d*Gi_dz)   %Lugar das Raizes
hold on;         
figure(2) 
step(Hr)     %FT de MF para Y/R ---> seguimento de referencia
title('Comportamento da saída para uma referência do tipo degrau unitário')
figure(3)
pzmap(Hr)   %DPZr
title('Diagrama polo-zero da FT Y/R')
hold on;
figure(4)
step(Hq)  %FT de MF para Y/Q ---> rejeicao de perturbacao
title('Comportamento da saída após uma perturbação do tipo degrau unitário')
hold on;
figure(5)
pzmap(Hq)  %DPZq
title('Diagrama polo-zero da FT Y/Q')
figure(6)
bode(Hr)
title('Diagrama de Bode da FT Y/R')
figure(7)
bode(Hq)
title('Diagrama de Bode da FT Y/Q')
figure(8)
bode(Hur)
title('Diagrama de Bode da FT U/R')
figure(9)
bode(Huq)
title('Diagrama de Bode da FT U/Q')
figure(10)
pzmap(Hur)
title('Diagrama polo-zero FT U/R')
figure(11)
pzmap(Huq)
title('Diagrama polo-zero da FT U/Q')


%% Filtro de referência
% relação entre polo-zero
r = 
tau_polo = t_5/3;
tau_zero = tau_polo*r;
z1 = exp(-Tsex/tau_zero);
z2 = exp(-Tsex/tau_polo);

F = ((1-z2)/(1-z1))*tf([1 -z1],[1 -z2],Tsex);
Hrf = minreal(Hr*F);

F_continuo = d2c(F, 'matched');

%FT U/R
Hrf = minreal((C_d*Gi_dz*F)/(1 + (C_d*Gi_dz)));

%FT U/Rf
Hurf = minreal((C_d*F)/(1 + (C_d*Gi_dz)));

figure
pzmap(Hrf)   %DPZ da FT de MF da saida em relacao a referencia com filtro
title('DPZ da FT de MF Y/R com filtro')

figure
pzmap(Hurf) %DPZ da FT de MF da entrada de controle em relacao a referencia com filtro
title('DPZ da FT de MF U/R com filtro')

%compara a resposta em frequencia das FTs de MF com o filtro
figure
h = bodeoptions;
h.PhaseMatching = 'on';
bodeplot(Hrf,'-b',  Hurf, 'r',{0.1 10},h)
legend('Y/R','U/R', 'Location','SouthWest')


%  figure
%  pzmap(Hurf) %DPZ da FT de MF da entrada de controle em relacao a referencia com filtro
%  title('DPZ da FT de MF U/R com filtro')



