clear all
close all
clc

%Código para projetar um controlador PI (um zero e um polos) com o LR
%contem projeto do filtro, Bodes, DPZs.

%% Funcoes de transferencia entre PV, MV e Perturbacao
CaU    = tf([0 4.5067], [1 6.9433]);
CaCaf = tf([0 0.8], [1 6.9433]);
CbCaf = tf([0 4.808], conv([1 6.9433],[1 1.6433]));
CbU    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  

%FT de MF antes do projeto do controlador
P = CbU; %expressao da Planta
Q = CbCaf; %expressao da FT perturbacao
C = tf([0 1],[1 0]); %parte conhecida do controlador
Hr_antes = zpk(minreal((C*P)/(1+C*P)));

%% Especificacoes MF
t_5 = 1.5;    %tempo de 5% min
pico = 0.05;  %sobressinal 5% em valor absoluto

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

zero1 = 5.538;
polo1 = 0;
polo2 = -1.6433;
polo3 = -6.9433;

fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd) + zero1))));
fase2 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)))));
fase3 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd) + polo2))));
fase4 =  rad2deg(double(atan( abs(imag(sd))/(-1*polo3 + 1*real(sd)))));

faseConhecida = fase1 - (fase2 + fase3 + fase4);

faseTotal = 0; %se K<0

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));

%Onde paf é um polo de alta frequencia que serve apenas para tornar a FT do controlador realizável

%calculando paf
paf = double(abs(sd)*10);

%calculando a fase do paf
fase_paf = rad2deg(double(atan( abs(imag(sd))/(paf + real(sd))))); 

%recalculando a fase total desonhecida:
faseDesconhecidaNova = fase_paf + faseDesconhecida;

%zeros SEMPRE a esquerda da localizacao do sd para nao afetar a dominancia
%com essa nova fase desconhecida, calculamos a localizacao dos zeros tq
%eles contribuam com a  fase 2*x --> ou  seja --> cada zero contribui com x

% Calculando a localizacao do zero do controlador:
zero = double( -1*real(sd) +  (imag(sd))/tan(deg2rad(double( (faseDesconhecidaNova/2)))));

%Prova real
fasePROVAreal = rad2deg(double(atan( abs(imag(sd))/(zero + real(sd)))));


%% Calculando K
syms K
s = sd_imPositivo;
Num = (((s+zero)^2)*(-2.1699*s + 12.01873))*K;
Den  =  s*(s+6.9433)*(s+1.6433)*(s+paf);
Kc_pos = double(vpa(solve(((1 + Num/Den == 0)))));
s = sd_imNegativo;
Kc_neg = double(vpa(solve((1+ Num/Den == 0))));

%Num = (((s+zero)^2)*(-2.1699*s + 12.01873))
%Den  =  s*(s+6.9433)*(s+1.6433)*(s+paf)
%KLR = -Den/Num

Kc = real(Kc_pos);

%% Funcoes de transferencia contínuas 

s = tf('s'); % variavel de Laplace

%FT do controlador PID
C = zpk(Kc*( (s +zero)^2)/(s*(s +paf)));
[num_C,den_C] = tfdata(C);

%% FT de MF sem Filtro

%funcao de transferencia de malha fechada de Y/R
Hr =  minreal((C*P)/(1 + (C*P)));
[num_Hr, den_Hr] = tfdata(Hr);

%funcao de transferencia de malha fechada de Y/Q
Hq =  minreal((Q)/(1 + (C*P)));
[num_Hq,den_Hq] = tfdata(Hq);

%funcao de transferencia de malha fechada de U/R
 Hur =  minreal((C)/(1 + (C*P)));
 [num_Hur,den_Hur] = tfdata(Hur);

%funcao de transferencia de malha fechada de U/Q
 Huq =  minreal((-C*Q)/(1 + (C*P)));
 [num_Huq,den_Huq] = tfdata(Huq);


%% Desenhando o LR

%sem filtro
figure
rlocus(C*P)

%% Respostas das FT MF sem o Filtro

figure
step(Hr)  %resposta ao degrau do sistema em MF
title('Resposta ao degrau em relacao ao seguimento de referencias')
figure
step(Hq) %resposta ao degrau do sistema em MF em relacao a pert
title('Resposta ao degrau em relacao a rejeicao à perturbacao')

figure
pzmap(Hr)   %DPZ da FT de MF da saida em relacao a referencia
title('DPZ da FT de MF Y/R')
figure
pzmap(Hq) %DPZ da FT de MF da saida em relacao a perturbacao
title('DPZ da FT de MF Y/Q')

figure
pzmap(Hur) %DPZ da FT de MF da entrada de controle em relacao a referencia
title('DPZ da FT de MF U/R')
figure
pzmap(Huq) %DPZ da FT de MF da entrada de controle em relacao a perturbacao
title('DPZ da FT de MF U/Q')

%%compara a resposta em frequencia das FTs de MF sem o filtro
figure
h = bodeoptions;
h.PhaseMatching = 'on';
%bodeplot(Hr,'-b', Hq ,'-.g',{0.1 10},h)
bodeplot(Hr,'-b', Hq ,'-.g', Hur, 'r', Huq,':k',{0.1 10},h)
legend('Y/R','Y/Q','U/R', 'U/Q', 'Location','SouthWest')
title('Diagramas de Bode das FTs de MF sem filtro')

%% Projeto do Filtro 

%FT do filtro de referência
F = 1/(1+(1/zero)*s)^2; %zeros são os zeros duplos que estão "incomodando a resposta"
[num_F,den_F] = tfdata(F);

%filtro nao afeta em nada a resposta a perturbacao!!!!!!!

%% FT de MF com Filtro 

%funcao de transferencia de malha fechada de Y/R
Hrf =  minreal((P*C*F)/(1 + (C*P)));
[num_Hrf, den_Hrf] = tfdata(Hrf);

%funcao de transferencia de malha fechada de U/R
Hurf =  minreal((C*F)/(1 + (C*P)));
[num_Hurf,den_Hurf] = tfdata(Hurf);


figure
step(Hrf)  %resposta ao degrau do sistema em MF
hold on
step(Hr)
legend('Com filtro', 'Sem filtro')
title('Resposta ao degrau em relacao ao seguimento de referencias')

figure
step(Hurf)  %resposta ao degrau do sistema em MF
hold on
step(Hur)
legend('Com filtro', 'Sem filtro')
title('Resposta ao degrau em relacao ao seguimento de referencias')

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
bodeplot(Hrf,'-b', Hq ,'-.g', Hurf, 'r', Huq,':k',{0.1 10},h)
legend('Y/R','Y/Q','U/R', 'U/Q', 'Location','SouthWest')
title('Diagramas de Bode das FTs de MF com filtro')




 