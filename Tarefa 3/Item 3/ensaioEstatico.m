clc
clear all

%% Realização do ensaio plotando Cb em funcao de u

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;
intCaf = [4 6];
intU = [0 10];

Caf = 5.5;
Cb1 = @(u) (-k1*(k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3)))/(-k2-u);
figure(2);
fplot(Cb1,intU);
hold on;
xlabel('u[1/min]')
ylabel('Cb[mol/l]')
legend('Caf = 5,5')
axis([0 10 0 3])
grid on

%% Definido os pontos, parte-se para a modelagem

%pontos (Cb,u):  (2.345,0.7192), (2.542,1.02), (2.706,1.307)  para todos Caf = 5.5

%EDOs linearizadas perto do ponto de equilibrio
syms s deltaCa(t) deltaCb(t) deltaCaf(t) deltaU(t) 

%parametros
k1 = double(6.01); %L/min
k2 = double(0.8433); %L/min
k3 = double(0.1123); %mol/Lmin

%variavel manipulada u = F/V  = [0, 10] L/min = vazao volumetrica
uEq = double(1);
%perturbacao Caf = [4, 6] mol/L = concentracao do produto A no fluido de alimentacao
CafEq = double(5.1);
%variavel de processo Cb = concentracao do produto B
CbEq = double(2.345);
%variavel intermediaria Ca = concentracao do produto A
CaEq = double(0.7192);

%EDOs
eqn1 =vpa( diff(deltaCa(t)) ==  (-k1 - 2*k3*CafEq - uEq)*deltaCa(t) + uEq*deltaCaf(t) + (CafEq - CaEq)*deltaU(t),4);
eqn2 =vpa( diff(deltaCb(t)) ==   k1*deltaCa(t) + (-k2 - uEq)*deltaCb(t) - (CbEq)*deltaU(t),4);
 
%resolvendo 
eqn1LT = vpa(laplace(eqn1,t,s),4);
eqn2LT = vpa(laplace(eqn2,t,s),4);

%substituindo as variaveis transformadas (deltas) em variaveis simbolicas
syms deltaCa_LT  deltaCb_LT deltaCaf_LT deltaU_LT
eqn1LT = vpa(subs(eqn1LT,[laplace(deltaCa,t,s) laplace(deltaCb,t,s) laplace(deltaCaf,t,s) laplace(deltaU,t,s)],[deltaCa_LT ...
                                                                                                                                             deltaCb_LT deltaCaf_LT deltaU_LT]),4);
eqn2LT = vpa(subs(eqn2LT,[laplace(deltaCa,t,s) laplace(deltaCb,t,s)  laplace(deltaU,t,s)],[deltaCa_LT deltaCb_LT deltaU_LT]),4);


%resolvendo as eqs para deltaCa e deltaCb e substituindo em deltas(0) valor 0
deltaCa_s = vpa(subs(solve(eqn1LT, deltaCa_LT), deltaCa(0),0),4)
deltaCb_s = vpa(subs(solve(eqn2LT, deltaCb_LT), deltaCb(0),0),4)



