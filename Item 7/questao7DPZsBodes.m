clear all
close all
clc

%% Parametros de controle

k_u =    0.56; %ganho da FT Cb/u
k_caf = 0.46;  %ganho da FT Cb/Caf
tau_u = 0.49;   %constante de tempo da FT Cb/u
tau_caf = 0.42; %constante de tempo da FT Cb/Caf

%parametros de controle
xi = 0.7; %fator de amortecimento para PICO < 5%
t_cinco = 1.6; %tempo de 5% de malha fechada
wn = 3/(xi*t_cinco); %frequencia natural

%Para alpha grande --> sobressinal maior, mais rapido p/ entrar em regime
%Para alpha pequeno--> sobressinal menor, mais lento p/ entrar em regime
%alpha = 0.40; %regulador de filtragem [0, 1] --> se 1 --> nao tem  filtro

%% Funcoes de transferencia

s = tf([1 0],[1]); % variavel de Laplace

den_desejado = s^2 +2*xi*wn*s + wn^2;

%FT de G(s) = Cb(s)/u(s)
G = k_u/(1+s*tau_u);
[num_G,den_G] = tfdata(G);

%FT de Qi(s) = Cb(s)/Caf(s)
Qi = k_caf/(1+s*tau_caf);
[num_Qi,den_Qi] = tfdata(Qi);

%parametros do controlador
Kc = 1.48;
Ti = 0.237;

%FT do controlador C(s) 
C = (Kc*(1+s*Ti))/(s*Ti);
[num_C_scancel,den_C_scancel] = tfdata(C);

%FT do filtro F(s) sem cancelamento
%F = (1+s*Ti*alpha)/(1 + s*Ti);
F = 1/( 1 + (1/4.219)*s);
[num_F,den_F] = tfdata(F);

%%  FTs de Malha Fechada para Controlador Sem Cancelamento

%FT de Y/R -->  Cb/Ref
Hr=  (C*G)/(1 + C*G);
[num_Hr,den_Hr] = tfdata(Hr);
Hr = minreal(Hr);

%FT de Y/R --> Cb/R com filtro
  Hrf=  (C*G*F)/(1 + C*G);
  [num_Hrf, den_Hrf] = tfdata(Hrf);
  Hrf = minreal(Hrf);

%FT de Y/Q --> Cb/Caf
Hq = (Qi)/(1+(G*C));
[num_Hq,den_Hq] = tfdata(Hq);
Hq = minreal(Hq);

%FT de U/R  --> u/Ref sem filtro
 Hur = (C)/(1+(G*C)); 
 [num_Hur,den_Hur] = tfdata(Hur);
 Hur = minreal(Hur);

%FT de U/R  --> u/Ref com filtro
 Hurf = (C*F)/(1+(G*C)); 
 [num_Hurf,den_Hurf] = tfdata(Hurf);
 Hurf = minreal(Hurf);

%FT de U/Q --> u/Caf
Huq = (-C*Qi)/(1+(G*C));
[num_Huq,den_Huq] = tfdata(Huq);
Huq = minreal(Huq);


%% Verificando os polos e os zeros das  FTs

%consulta direta dos parametros e respostas da FT
funcaoTransf(Hq)


% Simulação
%sim('semCancelFiltrado') % Executa simulação no Simulink

% Exibição dos gráficos e resultados

%resultadosQ7


%% Funcoes adicionais

%coloca a FT na forma padrao
function f = formaPadrao(funcao)
    f=zpk(funcao);
    f.DisplayFormat='frequency';
end

%funcao para consultar os dados da FT
function dados = funcaoTransf(ft)
    dados = [1 2 3 4 5 6];
    dados(1) =   fprintf('zeros: '); zero(ft)
    dados(2) =   fprintf('poles: '); pole(ft)
    dados(3) =   fprintf('dcgain: '); dcgain(ft)
    dados(4) =   fprintf('non standard form: '); ft
    dados(5) =   fprintf('standard form: '); formaPadrao(ft)
    dados(6) =   isstable(ft);  if(true); fprintf('FT é Estável\n'); else fprintf('FT não é Estável \n'); end
    figure
    pzmap(ft); %localizacao grafica dos polos e zeros
    figure
    bode(ft);    %grafico de bode para cada ft
    figure
    step(ft)  %resposta ao degrau 
end