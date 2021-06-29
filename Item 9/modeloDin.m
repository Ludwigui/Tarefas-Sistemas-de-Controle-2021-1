function [dC] = modeloDin(t, x, u, Caf)

Ca = x(1);
Cb = x(2);

% Parametros
k1=6.01;
k2=0.8433;
k3=0.1123;

%modelo dinamico nao linear
dCa = -k1*Ca - k3*(Ca^2) + (Caf - Ca)*u;
dCb = k1*Ca - k2*Cb - Cb*u;
dC = [dCa; dCb];
end

