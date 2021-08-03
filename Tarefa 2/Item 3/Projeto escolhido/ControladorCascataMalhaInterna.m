clear all
close all
clc

%% Especificacoes MF
t_5 = 0.15; %tempo de 5% [minutos]
pico = 0.05; %sobressinal 5%

syms zeta wn

%fator de amortecimento (zeta)
fa= vpa(solve((pico ==  exp((-pi*zeta)/(sqrt(1 - zeta^2)))))); 
fa = fa(1,:); 

%frequencia natural (wn)
wn = vpa(solve(t_5 == (3/(fa*wn))));

%ponto desejado
sd_imPositivo = -fa*wn  + 1i*wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn -  1i*wn*sqrt(1-fa^2);  %parte real negativa

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada

 sd = -fa*wn  + 1i*wn*sqrt(1-fa^2); 


 fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd))))); %polo Controlador na origem
 fase2 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)-6.9433)))); %polo em 6.9433
 
faseConhecida = -(fase1+fase2) ;

faseTotal = -180;

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));
%%
zero = double( -1*real(sd) +  (imag(sd))/tan(deg2rad(double( (faseDesconhecida)))));
%Prova real
fasePROVAreal =  rad2deg(double(atan( abs(imag(sd))/(zero + real(sd)))));

%% Calculando K
syms K 

s = sd_imPositivo;
Kc_pos =  double(vpa(solve( 1 + (K*4.5067*(s+zero))/(s*(s+6.9433))  == 0)));
s = sd_imNegativo;
Kc_neg =  double(vpa(solve( 1 + (K*4.5067*(s+zero))/(s*(s+6.9433))  == 0)));

Kc = real(Kc_pos);

%% Funcoes de transferencia contínuas
s = tf([1 0],[1]); % variavel de Laplace

Pint = 4.5067/(s+6.9433); %malha interna
C = Kc*(s+zero)/s;  %controlador

figure
rlocus(C*Pint)

Gm = (C*Pint)/(1+C*Pint); %para Y/R
figure
step(Gm)
GmfP = (0.8/(s+6.9433))/(1+C*Pint); %para Y/Q

%filtro: precisa? Malha interna é pra perturbacao
%F = 25.4/(s+25.4);
%Gmf = (C*Pint*F)/(1+C*Pint); %para Y/R com filtro

%figure
%step(Gmf)
figure
step(GmfP)


 