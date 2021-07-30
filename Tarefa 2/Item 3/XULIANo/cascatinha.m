clear all
close all
clc

%questao 3 - por cascata
%% Funcoes de transferencia entre PV, MV e Perturbacao
CaU    = tf([0 4.5067], [1 6.9433]);
CaCaf = tf([0 0.8], [1 6.9433]);
CbCaf = tf([0 4.808], conv([1 6.9433],[1 1.6433]));
CbU    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  

%FT de MF antes do projeto do controlador
P = zpk(CbU); %expressao da Planta
Q = zpk(CbCaf); %expressao da FT perturbacao
MI = CaU;

%controle interno
s = tf('s')

Cin = 7.335*(s+25.4)/s;

Pext = zpk(minreal((1/(s + 1.6433))*(6.01 - ( (2.1699*Cin)/(1 + MI*Cin)))));

%% Especificacoes MF
t_5 = 1.5;    %tempo de 5%
pico = 0.05;  %sobressinal 20% sempre em valor ABSOLUTO

syms zeta wn

%fator de amortecimento (zeta)
fa= vpa(solve((pico ==  exp((-pi*zeta)/(sqrt(1 - zeta^2)))))); 
fa = fa(1,:); 

%frequencia natural (wn)
wn = vpa(solve(t_5 == (3/(fa*wn))));    %para 0 < Xi <= 0.7 

%ponto desejado
sd_imPositivo =  -fa*wn  + 1i*wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn - 1i*wn*sqrt(1-fa^2);   %parte real negativa

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada

sd = -fa*wn  + 1i*wn*sqrt(1-fa^2); 

zero1 = 6.592;
zero2 = 34.29;
polo1 = 0;
polo2 = 1.643;

fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(zero1 - real(sd)  ))));
fase2 = rad2deg(double(atan( abs(imag(sd))/(34.29 + real(sd)))));
fase3 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)))));
fase4 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd) - polo2))));

faseConhecida = (fase1 + fase2) - (fase3 + fase4);

faseTotal = 0; %se  K<0

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));

%zeros SEMPRE a esquerda da localizacao do sd para nao afetar a dominancia
% Calculando a localizacao do zero do controlador:
zero =  double(-1*real(sd) +  (imag(sd))/tan(deg2rad(double(faseDesconhecida))));

fasePROVAreal = rad2deg(double(atan( abs(imag(sd))/(zero + real(sd)))));

%% Calculando K
syms K
s = sd_imPositivo;
Num = -9.9062*(s+34.29)*(s-6.592)*(s+zero)*K;
Den  = (s)*(s+1.643)*(s^2 + 40*s + 839.6);

Kc_pos = double(vpa(solve(((1 + Num/Den == 0)))));
s = sd_imNegativo;
Kc_neg = double(vpa(solve((1 + Num/Den == 0))));

Kc = double(real(Kc_pos));

%% Funcoes de transferencia contínuas 

s = tf('s'); % variavel de Laplace

%FT do controlador PI
Cext = Kc*( (s+zero)/s);
[num_C,den_C] = tfdata(Cext);

%% FT de MF sem Filtro

%funcao de transferencia de malha fechada de Y/R
Hr =  minreal((Cext*Pext)/(1 + (Cext*Pext)));
[num_Hr, den_Hr] = tfdata(Hr);

%funcao de transferencia de malha fechada de Y/Q
% Hq =  minreal((Pext)/(1 + (Cext*Pext)));
% [num_Hq,den_Hq] = tfdata(Hq);

%funcao de transferencia de malha fechada de U/R
% Hur =  minreal((Cext)/(1 + (Cext*Pext)));
% [num_Hur,den_Hur] = tfdata(Hur);

%funcao de transferencia de malha fechada de U/Q
% Huq =  minreal((-Cext)/(1 + (Cext*Pext)));
% [num_Huq,den_Huq] = tfdata(Huq);

%% Desenhando o LR

%sem filtro
rlocus(Cext*Pext)

%% Respostas das FT MF sem o Filtro

figure
step(Hr)  %resposta ao degrau do sistema em MF
title('Resposta ao degrau em relacao ao seguimento de referencias')
% figure
% step(Hq) %resposta ao degrau do sistema em MF em relacao a pert
% title('Resposta ao degrau em relacao a rejeicao à perturbacao')

figure
pzmap(Hr)   %DPZ da FT de MF da saida em relacao a referencia
title('DPZ da FT de MF Y/R')
% figure
% pzmap(Hq) %DPZ da FT de MF da saida em relacao a perturbacao
% title('DPZ da FT de MF Y/Q')
% figure
% pzmap(Hur) %DPZ da FT de MF da entrada de controle em relacao a referencia
% title('DPZ da FT de MF U/R')
% figure
% pzmap(Huq) %DPZ da FT de MF da entrada de controle em relacao a perturbacao
% title('DPZ da FT de MF U/Q')

%compara a resposta em frequencia das FTs de MF sem o filtro
% figure
% h = bodeoptions;
% h.PhaseMatching = 'on';
% bodeplot(Hr,'-b', Hq ,'-.g', Hur, 'r', Huq,':k',{0.1 10},h)
% legend('Y/R','Y/Q','U/R', 'U/Q', 'Location','SouthWest')

%% Projeto do Filtro 

%FT do filtro de referência
F = 1/(1+(1/3.049)*s); %zero é o zero que está "incomodando a resposta"
[num_F,den_F] = tfdata(F);

%filtro nao afeta em nada a resposta a perturbacao!!!!!!!

%% FT de MF com Filtro 

%funcao de transferencia de malha fechada de Y/R
Hrf =  minreal((Pext*Cext*F)/(1 + (Cext*Pext)));
[num_Hrf, den_Hrf] = tfdata(Hrf);

%funcao de transferencia de malha fechada de U/R
Hurf =  minreal((Cext*F)/(1 + (Cext*Pext)));
[num_Hurf,den_Hurf] = tfdata(Hurf);

figure
step(Hrf)  %resposta ao degrau do sistema em MF
title('Resposta ao degrau em relacao ao seguimento de referencias com filtro')

figure
pzmap(Hrf)   %DPZ da FT de MF da saida em relacao a referencia com filtro
title('DPZ da FT de MF Y/R com filtro')

% figure
% pzmap(Hurf) %DPZ da FT de MF da entrada de controle em relacao a referencia com filtro
% title('DPZ da FT de MF U/R com filtro')

%compara a resposta em frequencia das FTs de MF com o filtro
% figure
% h = bodeoptions;
% h.PhaseMatching = 'on';
% bodeplot(Hr,'-b',  Hur, 'r',{0.1 10},h)
% legend('Y/R','U/R', 'Location','SouthWest')
% 
