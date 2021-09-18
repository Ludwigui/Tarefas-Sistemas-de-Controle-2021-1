clear all
close all
clc
format SHORT

%Código para projetar PS
s = tf('s');

% Funcoes de transferencia entre PV, MV e Perturbacao
Gq = tf([0 4.808], conv([1 6.9433],[1 1.6433])); %expressao da FT perturbacao
Gu    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  %expressao da planta sem atraso
C =(6.6534*((s+3.879)^2))/(s*(s+28.98)); % controlador primario
F =  1/(((1/3.879)*s + 1)^2); %filtro de referencias
%% Discretizando
t_5 = 1.5;
Ts = t_5/20;

%pelo metodo do sustentador de ordem zero
Gq_d = c2d(Gq, Ts, 'zoh');
Gu_d = c2d(Gu, Ts, 'zoh');

%por ZP matching
C_d = c2d(C, Ts, 'matched');
F_d = c2d(F, Ts, 'matched');

%% Funcoes de transferencia de Cb/R e Cb/Caf

z = tf('z');
%Ft Cb/R com filtro
Hr = minreal((C_d*Gu_d*F_d)/(1+C_d*Gu_d),1e-2)*(z^-40);

%FT para  Cb/R sem o filtro que vai la em Y/Q
Hsf=  zpk(minreal((C_d*Gu_d)/(1+C_d*Gu_d),1e-2)*(z^-40));

%Hrc = (C*Gu*F)/(1+C*Gu);
%figure
%step(Hr)
%hold
%step(Hrc)

%funcao de transferencia de malha fechada de Y/Q
Hqsf = zpk(minreal(((Gq_d)*(z^-40))*(1 - Hsf)));
[num_Hqsf,den_Hqsf] = tfdata(Hqsf);
%step(Hq)

%% Achando params filtro
syms alpha beta gamma K

%calculando alpha
z = 0.884;
NumColchete = ((z^40)*((z-0.68)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
d = 4; %precisao 
valor_alpha = vpa(solve((NumColchete == 0), alpha), d);
% calculando beta 
z = 0.5941;
NumColchete2 = ((z^40)*((z-0.68)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_beta = vpa(solve( (NumColchete2 == 0), beta), d);
% calculando gamma
z = 1;
NumColchete3 = ((z^40)*((z-0.68)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_gamma = vpa(solve((NumColchete3 == 0), gamma), d);
z = 1;
NumColchete4 =  ((alpha*(z^2) + beta*z + gamma)*(K)*(z^2 - 1.628*z + 0.7312)*(z^2 - 1.239*z + 0.4697))/(  ((z-0.68)^4)*(z-0.7476)^2);
valor_K= vpa(solve((NumColchete4 == 1), K), d);

%% resolvendo sistema
syms alpha beta gamma K

eqn1 = alpha ==  valor_alpha;
eqn2 = beta ==  valor_beta;
eqn3 = gamma ==  valor_gamma;
eqn4 = K ==  valor_K;
 
sol = solve([eqn1, eqn2, eqn3, eqn4], [alpha, beta, gamma, K]);
alpha = double(vpa(sol.alpha))
beta = double(vpa(sol.beta))
gamma = double(vpa(sol.gamma))
K = double(vpa(sol.K))

%% Testando filtro
z = tf('z')
%Fr = zpk(((alpha*(z^2) + beta*z + gamma)*(K)*(z^2 - 1.628*z + 0.7312)*(z^2 - 1.239*z + 0.4697))/(  ((z-0.68)^4)*(z-0.7476)^2))
Fr = ((alpha*(z^2) + beta*z + gamma)*(K)*(z^2 - 1.628*z + 0.7312)*(z^2 - 1.239*z + 0.4697))/(  ((z-0.68)^4)*(z-0.7476)^2)
dcgain(Fr)
Hq = zpk(minreal(((Gq_d)*(z^-40))*(1 - Hsf*Fr)));
[num_Hq,den_Hq] = tfdata(Hq);
step(Hq)

step(Hqsf)
hold on
step(Hq)
legend('Sem filtro', 'com filtro')

%% Implementar Ceq 
%Ceq = zpk(minreal((C_d*Fr)/(1+ C_d*Gu_d*(1-Fr*z^-40)), 1e-2))

Ceq = minreal((C_d*Fr)/(1+ C_d*Gu_d*(1-Fr*z^-40)), 1e-2)
%NovoF = F_d/Fr;


 