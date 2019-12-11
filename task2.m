t_p = 1;
T = 0.01;

% Факторизуем передаточную функцию объекта.
Pm = [1 3];
Pp = [1];
Rm = [1 14];
Rp = [1 -1];

betta = conv(Pm, Pp);
alpha = conv(Rm, Rp);

% Определим порядок желаемой ПФ
% l = nR+ + r - nP- - 1 = 1 > 0 =>
% nG = nR + l = 3
nG = 3;

%Исходя из условия задачи, в качестве стандартной передаточной функции
%выберем нормированную ПФ с астатизмом 2-го порядка, n = 3
alpha_n = [1 5.1 6.35 1];
tau_p = 7.2;

al = t_p / tau_p;
%Найдем коэффициенты полинома знаменателя G(s) желаемой передаточной
%функции
G = [1 1 1 1];
for i = 1:(nG + 1)
    G(i) = al^(nG-i+1) * alpha_n(i);
end

%Найдем степени плолиномов N и M.
%Так как полиномы должны удовлетворять условиям разрешимости, физической
%осуществимости и грубости, получаем 3 неравенства
% nG <= nM + nN + 1
% nR- + nM <= nP- + nN + r
% nG = nR+ + nN + r

% 3 <= nM + nN + 1
% 1 + nM <= 1 + nN + 2
% 3 = 1 + nN + 2

%=> nN = 0
%   nM >= 2
%   nM <= 2

%=> N(s) = a0
%   M(s) = b0*s^2 + b1*s + b2
%Из полиномиального уравнения P+(s)M(s) + R+(s)N(s)s^r = G(s) получаем
N = [G(1)];
M = [(G(2)-N(1)) G(3) G(4)];

%=> Найдем искомую ПФ регулятора по формуле 
% Wp(s) = (R-(s)*M(s)) / (P-(s)*N(s)*s^r)

betta_r = conv(Rm, M);
tmp = conv(Pm, N);
alpha_r = [tmp 0 0];

% Пф реглятора
R = tf(betta_r, alpha_r);
% ПФ объекта
W = tf(betta, alpha);

% Дискретная система
Rd = c2d(R, T);
Wd = c2d(W, T);
Wyg = feedback(Rd*Wd, 1);
subplot(3, 1, 1); step(Wyg, 100 * T);
title('График переходной функции');
Weg = feedback(1, Rd*Wd);
t = 0:T:1;
subplot(3, 1, 2); step(Weg, 100 * T);
title('График ошибки при входном воздействии g[lT] = 1');
subplot(3, 1, 3); lsim(Weg, 2*t+1, t);
title('График ошибки при входном воздействии g[lT] = 2lT + 1');

info = stepinfo(Wyg,'SettlingTimeThreshold',0.05);
settling_time = roundn(info.SettlingTime, -4);

display(settling_time);