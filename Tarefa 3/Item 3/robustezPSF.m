close all
clc

%% Funcoes de transferencia continuas

s = tf('s');

tfn = minreal(zpk((-2.1699*s+12.0873)/((s+6.9433)*(s+1.6433))));
%C = 6.6533*(s+3.79)^2/(s*(s+29));
C = (0.5*6.6533)*(s+3.79)^2/(s*(s+29));

Fref =  1/(((1/3.879)*s + 1)^2); %filtro de referencias

tf12 = minreal(zpk((-2.464*s+7.139)/(s^2+9.651*s+16.09)));
tf08 = minreal(zpk((-2.162*s+11.89)/(s^2+8.79*s+11.89)));
tf07 = minreal(zpk((-2.042*s+13.37)/(s^2+8.579*s+11.4)));
tf09 = minreal(zpk((-2.26*s+10.54)/(s^2+9.01*s+13.21)));
tf11 = minreal(zpk((-2.408*s+8.188)/(s^2+9.438*s+15.11)));
tf13 = minreal(zpk((-2.508*s+6.178)/(s^2+9.864*s+17.1)));

%% Discretizacao

Ts = 0.075;
z = tf('z',Ts);

Cz = c2d(C,Ts,'matched');

tfnz = c2d(tfn,Ts,'zoh');
tf07z = c2d(tf07,Ts,'zoh');
tf08z = c2d(tf08,Ts,'zoh');
tf09z = c2d(tf09,Ts,'zoh');
tf11z = c2d(tf11,Ts,'zoh');
tf12z = c2d(tf12,Ts,'zoh');
tf13z = c2d(tf13,Ts,'zoh');

NumFr = ((2.7452)*(z^2) + (-4.0570*z) + 1.4413)*(z^2 - 1.682*z + 0.7312)*(z^2 - 1.239*z + 0.4697);
DenFr   = ((z-0.61)^4)*((z-0.7476)^2);
Fr =  minreal(NumFr/DenFr);

% NumFr2 = ((15.3556)*(z^2) + (-22.6907*z) + 8.0608)*(z^2 - 1.682*z + 0.7312)*(z^2 - 1.239*z + 0.4697);
% DenFr2   = ((z-0.4)^4)*((z-0.7476)^2);
% Fr2 =  minreal(NumFr/DenFr)

Fs = d2c(Fr,'matched');
%Fs2 = d2c(Fr2,'matched');

F = Fref/Fs;
F2 = Fref/Fs2;
X = [ tf07 tf08 tf09 tf11 tf12 tf13 ];
Er = [];

for i=1:1:6

g = tfn*X(i);    
Eri = (g-tfn)/tfn;
Er = [Er Eri]; %delta Pi
    
end
%% 


for i=1:1:6
   bodemag(1/(Er(i)))  %1/deltaPi
   hold on
end


ymfRob = (C*tfn)/((1+C*tfn))*F;
%ymfRob2 = (C*tfn)/((1+C*tfn))*F2;
bodemag(ymfRob, '--r')
%hold on
%bodemag(ymfRob2, '-.b')

%legend('deltaPi', 'FtMF_filtro1', 'FtmF_filtro2')

%%
% ymf = Fref*C*tfn/(1+C*tfn)*exp(-3*s);
%figure
% step(ymf)
% 
% ma = C*tfn;
allmargin(ma)