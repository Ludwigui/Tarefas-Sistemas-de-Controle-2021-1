 clc, clear all, close all
option = odeset('RelTol',1e-3);

fim = 301;           % número de iterações da simulação dinâmica
Ts = 0.08;           % período de amostragem

% cria vetor de entrada e perturbação
u(1:fim) = ones(1,fim);             % vetor de entradas
Caf(1:fim) = 5.1*ones(1,fim);       % vetor de perturbações (deve ser entre 0 e 5)
%Caf(201:end) = 0.2;

% condições iniciais
y1(1) = 0.7192;
y2(1) = 2.345;
y2aux(1) = 0;
e(1) = 0;

% referência
yr(1:fim) = 2.345*ones(1,fim);
%yr(1:fim) = 0.5*ones(1,fim);
yr(101:fim) = 2.345*ones(1,fim-100);

% simulação dinâmica
for k = 2:fim
    % calcula modelo
   % [~,x] = ode45(@(t,x)modeloDin(t,x,u(k-1),Caf(k-1)),[0 Ts],[y1(k-1) y2(k-1)],option);
    [~,x] = ode45(@(t,x)modeloDin(t,x,u(k-1),Caf(k-1)),[0 Ts],[y1(k-1) y2aux(k-1)],option);
    y2aux(k) = x(end,2);
    y2(k) = y2aux(k)                       % velocidade
    y1(k) = x(end,1);                              % posição
  
    %y2(k) = x(2);  %valor Cb
    %y1(k) = x(1);  %valor Ca
       
    % lei de controle 
	e(k) = yr(k) - y2(k);
	u(k) = u(k-1) + 1.73*e(k) - 1.23*e(k-1); %lei de controle malha interna
    
    % saturação
%     if u(k) > 10
%         u(k) = 10;
%     elseif u(k) < -10 
%         u(k) = -10;
%     end    
end

tempo = linspace(0,Ts*(fim-1),fim);
%subplot(311),plot(tempo,y1);hold on
subplot(311),plot(tempo,yr,'r');xlabel('Tempo (s)');legend('referencia');
subplot(312),plot(tempo,y2,'k');xlabel('Tempo (s)');legend('Cb');
%subplot(313),plot(tempo,u);xlabel('Tempo (s)');ylabel('u(t)');
subplot(313),plot(tempo,Caf);xlabel('Tempo (s)');ylabel('d(t)');