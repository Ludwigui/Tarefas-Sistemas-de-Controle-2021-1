clear all
close all

k1 = 6.01;
k2 = 0.8433;
k3 = 0.1123;
intCaf = [4 6];
intU = [0 10];

for j=4:0.5:6
    Caf = j;
    Ca1 = @(u) (k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3));
    Cb1 = @(u) (-k1*(k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3)))/(-k2-u);
    if j == 4
        figure(1)
        fplot(Ca1,intU);
        hold on;
    else
        fplot(Ca1,intU);        
    end
end
hold off
xlabel('u[1/min]')
ylabel('Ca[mol/l]')
legend('Caf = 4','Caf = 4,5','Caf = 5','Caf = 5,5','Caf = 6')
grid on

for i=4:0.5:6
    Caf = i;
    Cb1 = @(u) (-k1*(k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3)))/(-k2-u);
    if i == 4
        figure(2);
        fplot(Cb1,intU);
        hold on;
    else
        fplot(Cb1,intU);        
    end
end
xlabel('u[1/min]')
ylabel('Cb[mol/l]')
legend('Caf = 4','Caf = 4,5','Caf = 5','Caf = 5,5','Caf = 6')
grid on

%%---------------------------------------------------------------------
for k=0:2:10
    u = k;
    Ca1 = @(Caf) (k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3));
    Cb1 = @(Caf) (-k1*(k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3)))/(-k2-u);
    if k == 0
        figure(3)
        fplot(Ca1,intCaf);
        hold on;
    else
        fplot(Ca1,intCaf);        
    end
end
hold off
xlabel('Caf[mol/l]')
ylabel('Ca[mol/l]')
legend('u = 0','u = 2','u = 4','u = 6','u = 8','u = 10');
grid on

for l=0:2:10
    u = l;
    Cb1 = @(Caf) (-k1*(k1+u-sqrt((k1+u)^2-4*(-k3)*Caf*u))/(2*(-k3)))/(-k2-u);
    if l == 0
        figure(4);
        fplot(Cb1,intCaf);
        hold on;
    else
        fplot(Cb1,intCaf);        
    end
end
xlabel('Caf[mol/l]')
ylabel('Cb[mol/l]')
legend('u = 0','u = 2','u = 4','u = 6','u = 8','u = 10');
grid on