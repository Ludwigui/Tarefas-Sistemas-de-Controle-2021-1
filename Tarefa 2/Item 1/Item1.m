clear all
close all
clc


%% Parametros da planta
Ke = 1.05;    %ganho estatico da planta
tau = 0.5;   %constante de tempo da equação linearizada perto do ponto de equilibrio

%% Especificacoes MF
t_5 = 1.5; %tempo de 5% [minutos]
pico = 0.05; %sobressinal 5%

syms zeta wn

%fator de amortecimento (zeta)
fa= vpa(solve((pico ==  exp((-pi*zeta)/(sqrt(1 - zeta^2)))))); 
fa = fa(1,:); 

%frequencia natural (wn)
wn = vpa(solve(t_5 == (3/(fa*wn))));

%ponto desejado
sd_imPositivo = -fa*wn  + 1i*2;%wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn - 1i*2;%wn*sqrt(1-fa^2);  %parte real negativa

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada

 sd = -fa*wn  + 1i*2;%wn*sqrt(1-fa^2); 


 fase2 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd))))); %polo Controlador na origem
 fase3 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)-1.6433)))); %polo em 1.6433
 fase4 = rad2deg(double(atan( abs(imag(sd))/(1*real(sd)+6.9433)))); %polo em 6.9433
 fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)+5.55)))); %zero em 5.55





faseConhecida = fase1 -( fase4 + fase2+ fase3 ) ;

faseTotal = 0;

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));
%%

%calculando paf
  paf = abs(sd)*10; 
%calculando a fase do paf
  fase_paf = rad2deg(double(atan( abs(imag(sd))/(paf + real(sd)))));
%recalculando a fase total desonhecida:
  faseDesconhecidaNova = fase_paf + faseDesconhecida;
% Calculando a localizacao dos zeros duplos do controlador:
  zero =  -1*real(sd) +  (imag(sd))/tan(deg2rad(double( (faseDesconhecidaNova/2))));
%Prova real
fasePROVAreal = rad2deg(double(atan( abs(imag(sd))/(zero))));

%% Calculando K
syms K 

s = sd_imPositivo;
Kc_pos =  double(vpa(solve( 1 + ((K*(-2.1633)*(s-5.55)*(s+zero)^2)/(s*(s+paf)*(s+6.9433)*(s+1.6433)) )  == 0)));
s = sd_imNegativo;
Kc_neg =  double(vpa(solve( 1 + ((K*(-2.1633)*(s-5.55)*(s+zero)^2)/(s*(s+paf)*(s+6.9433)*(s+1.6433)) )  == 0)));

Kc = real(Kc_pos);



%% Funcoes de transferencia contínuas
s = tf([1 0],[1]); % variavel de Laplace
%% Planta referência
Pr = -2.1633*(s-5.55)/((s+6.9433)*(s+1.6433));
Ppert = 4.808/((s+1.6433)*(s+6.9433));
%% FT do controlador 
C = Kc*(s+3.7904)^2/(s*(s+28.28)); 
%rlocus(C*Pr)
Gmfr = C*Pr/(1+C*Pr);
%step(Gmfr);
%pzmap(Gmfr);
F = 3.79^2/((s+3.79)^2);
GmfrF = F*C*Pr/(1+C*Pr);
%step(GmfrF)
Gmfp = Ppert/(1+C*Pr);
step(Gmfp)





 