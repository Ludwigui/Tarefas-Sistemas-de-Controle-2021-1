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

%% Achando params filtro
syms alpha beta gamma

%calculando alpha
z = 0.884;
NumColchete = ((z^40)*((z-0.678)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
d = 4; %precisao 
valor_alpha = vpa(solve((NumColchete == 0), alpha), d);
% calculando beta 
z = 0.5941;
NumColchete2 = ((z^40)*((z-0.678)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_beta = vpa(solve( (NumColchete2 == 0), beta), d);
% calculando gamma
z = 1;
NumColchete3 = ((z^40)*((z-0.678)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_gamma = vpa(solve((NumColchete3 == 0), gamma), d);

%% resolvendo sistema
syms alpha beta gamma

eqn1 = alpha ==  valor_alpha;
eqn2 = beta ==  valor_beta;
eqn3 = gamma ==  valor_gamma;
 
sol = solve([eqn1, eqn2, eqn3], [alpha, beta, gamma]);
alpha = double(vpa(sol.alpha))
beta = double(vpa(sol.beta))
gamma = double(vpa(sol.gamma))

%% Testando filtro
z = tf('z')
NumFr = ((alpha)*(z^2) + (beta*z) + gamma)*(z^2 - 1.628*z + 0.7312)*(z^2 - 1.239*z + 0.4697);
DenFr   = ((z-0.68)^4)*((z-0.7476)^2);
Fr =  zpk(minreal(NumFr/DenFr))
Fr = (zpk(((alpha*(z^2) + beta*z + gamma)*(z^2 - 1.628*z + 0.7312)*(z^2 - 1.239*z + 0.4697))/(  ((z-0.68)^4)*(z-0.7476)^2)))/dcgain(Fr)
Hq = zpk(minreal(((Gq_d)*(z^-40))*(1 - Hsf*Fr)));
[num_Hq,den_Hq] = tfdata(Hq);

step(Hqsf)
hold on
step(Hq)
legend('Sem filtro', 'com filtro')

%% Configuraçao janela

%Gerando graficos da questao 2
% screenSize = get(0,'screensize'); % gets screen size
%  sim('item1PS')
% 
%monWidth = screenSize(3);
% monHeight = screenSize(4);
% offHeight = 0; % assumed height of system task bar
% monHeight = monHeight - offHeight; % usable screen height
% % establishing a 2x3 grid on the screen
% figHeight = monHeight/2;
% figWidth = monWidth/3;


% figure
% set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
% set(gcf,'name','Resposta MF')
% plot(sp.Time,sp.Data, '- r')
% hold on
% plot(pv.Time, pv.Data, '-b')
% hold on
% plot(pert.Time,pert.Data)
% %axis([0 121 0 4])
% legend('SP', 'PV', 'pert')
% xlabel('Tempo [min]')
% ylabel('Concentracao Produto B [mol/L]')
% title('Resposta dinamica para a Cb')



 