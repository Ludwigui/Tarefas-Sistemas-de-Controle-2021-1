clear all
close all
clc
format SHORT

%Código para projetar PS
s = tf('s');

% Funcoes de transferencia entre PV, MV e Perturbacao
Gq = tf([0 4.808], conv([1 6.9433],[1 1.6433])); %expressao da FT perturbacao
Gu    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  %expressao da planta sem atraso
C =(6.6534*((s+3.879)^2))/(s*(s+29)); % controlador primario
F =  1/(((1/3.879)*s + 1)^2); %filtro de referencias
%% Discretizando
t_5 = 1.5;
Ts = t_5/20;

%pelo metodo do sustentador de ordem zero
Gq_d = minreal(c2d(Gq, Ts, 'zoh'));
Gu_d = minreal(c2d(Gu, Ts, 'zoh'));

%por ZP matching
C_d = minreal(c2d(C, Ts, 'matched'));
F_d = minreal(c2d(F, Ts, 'matched'));

%% Funcoes de transferencia de Cb/R e Cb/Caf

z = tf('z');
%Ft Cb/R com filtro
Hr = minreal((C_d*Gu_d*F_d)/(1+C_d*Gu_d),1e-2)*(z^-40);

%FT para  Cb/R sem o fiGqltro que vai la em Y/Q
Hsf=  zpk(minreal((C_d*Gu_d)/(1+C_d*Gu_d),1e-2)*(z^-40));

%Hrc = (C*Gu*F)/(1+C*Gu);
%figure
%step(Hsf)
%hold
%step(Hrc)

%funcao de transferencia de malha fechada de Y/Q
Hqsf = zpk(minreal(((Gq_d)*(z^-40))*(1 - Hsf)));

%% Achando params filtro
syms alpha beta gamma

%calculando alpha
z = 0.5941;
NumColchete = ((z^40)*((z-0.61)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
d = 4; %precisao 
valor_alpha = vpa(solve((NumColchete == 0), alpha));
% calculando beta 
z = 0.884;
NumColchete2 = ((z^40)*((z-0.61)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_beta = vpa(solve( (NumColchete2 == 0), beta));
% calculando gamma
z = 1;
NumColchete3 = ((z^40)*((z-0.61)^4)) + (0.32895*(z-1.543)*(alpha*(z^2)+(beta*z)+gamma));
valor_gamma = vpa(solve((NumColchete3 == 0), gamma));

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
z = tf('z',Ts)
NumFr = ((alpha)*(z^2) + (beta*z) + gamma)*(z^2 - 1.682*z + 0.7312)*(z^2 - 1.239*z + 0.4697);
DenFr   = ((z-0.61)^4)*((z-0.7476)^2);
Fr =  minreal(NumFr/DenFr)
Hq = zpk(minreal(((Gq_d)*(z^-40))*(1 - Hsf*Fr)));
[num_Hq,den_Hq] = tfdata(Hq);
L = 3.3;
t1 = 0.45;
t2 = 0.2;
Ke = 0.667;


Ti = t1;
Td = t2;
Kc= (1/(2*L))*(1/(Ke/Ti));

Cp = Kc*(1+1/(Ti*s))*(1+Td*s);
Hqp = minreal(Gq/(1+Cp*Gu)*exp(-3*s))


step(Hqsf)
hold on
step(Hq)
hold on 
step(Hqp)
legend('Sem filtro', 'Com filtro', 'PID S-IMC')

%% 

sim('item3ModeloNLinPS')
figure
plot(dados(:,1), dados(:,2))
hold on
plot(dados(:,1), dados(:,3))
hold on
plot(dados(:,1), dados(:,4))
legend('PV','SP','Sinal de controle [l/min]')
xlabel('Tempo [min]')
ylabel('Concentração [mol/L]')


Fn =1/Fr;
%Ceq = minreal((C_d*Fn)/(1+ C_d*Gu_d*(1- (Fn*(z^-40)))), 1e-2);
NumCeq =   0.23469*(z^40)*(z-0.8647)*(z-0.7986)*(z-0.5939);
DenCeq =  (z+0.8856)*(z-1)*(z-0.772)*(z^2 - 1.987*z + 1.002)*(z^2 + 1.75*z + 0.7844)*(z^2 - 1.936*z + 0.9963)*(z^2 + 1.686*z + 0.7851)*(z^2 - 1.835*z + 0.9715)*(z^2 + 1.581*z + 0.7862)*(z^2 - 1.697*z + 0.9446)*(z^2 + 1.438*z + 0.7878)* (z^2 - 1.523*z + 0.9167)*(z^2 + 1.259*z + 0.7899)*(z^2 - 1.317*z + 0.8892)* (z^2 + 1.05*z + 0.7927)*(z^2 - 1.083*z + 0.8655)*(z^2 + 0.8141*z + 0.7962)*          (z^2 - 0.8281*z + 0.8469)*(z^2 + 0.5575*z + 0.8005)*(z^2 - 0.5579*z + 0.8325)*(z^2 + 0.2858*z + 0.806)*(z^2 - 0.2781*z + 0.8214)*(z^2 + 0.005173*z + 0.8128);

Ceq = NumCeq/DenCeq;

          
%% Configuraçao janela

%Gerando graficos da questao 2
%sim('testeCeq')
sim('PSFsimu')

screenSize = get(0,'screensize'); % gets screen size
monWidth = screenSize(3);
monHeight = screenSize(4);
offHeight = 0; % assumed height of system task bar
monHeight = monHeight - offHeight; % usable screen height
% establishing a 2x3 grid on the screen
figHeight = monHeight/2;
figWidth = monWidth/3;


figure
set(gcf,'OuterPosition',[1 offHeight figWidth figHeight]);
set(gcf,'name','Resposta MF')
plot(sp.Time,sp.Data, '- r')
hold on
plot(pv.Time, pv.Data, '-b')
hold on
plot(pert.Time,pert.Data)
%axis([0 121 0 4])
legend('SP', 'PV', 'pert')
xlabel('Tempo [min]')
ylabel('Concentracao Produto B [mol/L]')
title('Resposta dinamica para a Cb com Ceq')
 