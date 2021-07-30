clear all
close all
clc

%questao 3 - por feedforward
%% Funcoes de transferencia entre PV, MV e Perturbacao
CaU    = tf([0 4.5067], [1 6.9433]);
CaCaf = tf([0 0.8], [1 6.9433]);
CbCaf = tf([0 4.808], conv([1 6.9433],[1 1.6433]));
CbU    = tf([-2.1699 12.01873], conv([1 6.9433],[1 1.6433]));  

%FT de MF antes do projeto do controlador
P = zpk(CbU); %expressao da Planta
Q = zpk(CbCaf); %expressao da FT perturbacao

Cff_naoreal = zpk(minreal(-Q/P))  %nao realizavel --> polo no SPD
Cff_real     = -dcgain(Q)/dcgain(P) %para compensar, uma alternativa, usar Cff estatico
%Cff_filtrado =  -(1+stau2)/(1+stau1)*Kd/Kp, tau2 = 1/5.539