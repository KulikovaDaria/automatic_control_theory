t_p = 1;
T = 0.01;

% ����������� ������������ ������� �������.
Pm = [1 3];
Pp = [1];
Rm = [1 14];
Rp = [1 -1];

betta = conv(Pm, Pp);
alpha = conv(Rm, Rp);

% ��������� ������� �������� ��
% l = nR+ + r - nP- - 1 = 1 > 0 =>
% nG = nR + l = 3
nG = 3;

%������ �� ������� ������, � �������� ����������� ������������ �������
%������� ������������� �� � ���������� 2-�� �������, n = 3
alpha_n = [1 5.1 6.35 1];
tau_p = 7.2;

al = t_p / tau_p;
%������ ������������ �������� ����������� G(s) �������� ������������
%�������
G = [1 1 1 1];
for i = 1:(nG + 1)
    G(i) = al^(nG-i+1) * alpha_n(i);
end

%������ ������� ���������� N � M.
%��� ��� �������� ������ ������������� �������� ������������, ����������
%�������������� � ��������, �������� 3 �����������
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
%�� ��������������� ��������� P+(s)M(s) + R+(s)N(s)s^r = G(s) ��������
N = [G(1)];
M = [(G(2)-N(1)) G(3) G(4)];

%=> ������ ������� �� ���������� �� ������� 
% Wp(s) = (R-(s)*M(s)) / (P-(s)*N(s)*s^r)

betta_r = conv(Rm, M);
tmp = conv(Pm, N);
alpha_r = [tmp 0 0];

% �� ���������
R = tf(betta_r, alpha_r);
% �� �������
W = tf(betta, alpha);

% ���������� �������
Rd = c2d(R, T);
Wd = c2d(W, T);
Wyg = feedback(Rd*Wd, 1);
subplot(3, 1, 1); step(Wyg, 100 * T);
title('������ ���������� �������');
Weg = feedback(1, Rd*Wd);
t = 0:T:1;
subplot(3, 1, 2); step(Weg, 100 * T);
title('������ ������ ��� ������� ����������� g[lT] = 1');
subplot(3, 1, 3); lsim(Weg, 2*t+1, t);
title('������ ������ ��� ������� ����������� g[lT] = 2lT + 1');

info = stepinfo(Wyg,'SettlingTimeThreshold',0.05);
settling_time = roundn(info.SettlingTime, -4);

display(settling_time);