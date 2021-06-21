clc
clear all

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;
V = 100;
sim('DiagramaDeSimulacao')

% plot(ans.data(:,1), ans.data(:,2))
% hold on
% plot(ans.data(:,1), ans.data(:,3))
% hold on
% plot(ans.data(:,1), ans.data(:,4))
% hold on
u = [0 1 2 3 4 5 6 7 8 9 10];
Ca_vetor = [0 0.5655 0.9851 1.3104 1.5707 1.7841 1.9623 2.1136 2.2437 2.3568 2.4561];
Cb_vetor = [0 1.8438 2.0823 2.0492 1.9491 1.8350 1.7234 1.6196 1.5249 1.4390 1.3613];
%% u x Ca
plot(u,Ca_vetor)
xlabel('u')
ylabel('C_{B}')
%% u x Cb
plot(u,Cb_vetor)
xlabel('u')
ylabel('C_{B}')
%% Uma coisa importante: Neste ensaio eu considerei a perturba��o constante de 4 [unidades que nao me lembro] (n�o sei se est� certo)
