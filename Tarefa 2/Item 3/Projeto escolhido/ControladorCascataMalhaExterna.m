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
sd_imPositivo = -fa*wn  + 1i*wn*sqrt(1-fa^2);  %parte real positiva
sd_imNegativo = -fa*wn -  1i*wn*sqrt(1-fa^2);  %parte real negativa

%% Calculando contribuicoes dos polos e zeros do den da FT de malha fechada

 sd = -fa*wn  + 1i*wn*sqrt(1-fa^2); 

 fase1 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd)+5.55))));   
 fase2 = 180 - rad2deg(double(atan( abs(imag(sd))/(-1*real(sd))))); %polo Controlador na origem
 fase3 = 180 - rad2deg(double(atan( abs(imag(sd))/(- 1*real(sd)-1.6433)))); %polo em 1.6433






faseConhecida = fase1-(fase2+fase3) ;

faseTotal = 0;

syms faseDesconhecida
faseDesconhecida = vpa(solve(faseTotal == faseConhecida + faseDesconhecida));
%%
zero =  -1*real(sd) +  (imag(sd))/tan(deg2rad(double( (faseDesconhecida))));
%Prova real
fasePROVAreal = rad2deg(double(atan( abs(imag(sd))/(zero))));

%% Calculando K
syms K 

s = sd_imPositivo;
Kc_pos =  double(vpa(solve( 1 + K*(-0.48)*(s+zero)*(s-5.55)/(s*(s+1.6433))  == 0)));
s = sd_imNegativo;
Kc_neg =  double(vpa(solve( 1 + K*(-0.48)*(s+zero)*(s-5.55)/(s*(s+1.6433))  == 0)));
Kc = real(Kc_pos);

%% Funcoes de transferencia contínuas
s = tf([1 0],[1]); % variavel de Laplace
Pext = -0.48*(s-5.55)/(s+1.6433);
C = 0.7288*(s+2.812)/s; 
Gmf = C*Pext/(1+C*Pext);
step(Gmf)


 