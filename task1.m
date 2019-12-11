alpha = [1 -1.85 0.0184];
betta = [1 1.98];
T = 0.1;

W = tf(betta, alpha, T);

%alphaI, bettaI - �����, ������� ������ ��������� ����������;   
%alpha0, betta0 - ����� ��  � ��� ��������� ����������;
bettaI = 1;
betta0 = [1 1.98];
alphaI = [1 -0.01];
alpha0 = [1 -1.84];

% l = r - k = 1, ��� k - �������� ������ z=1, r - ������� ���������, r=1
% nV >= nAl0 + l - 1 - nBI + nAl = 3
% => V = z^3

%������ ������� ���������� N � M.
%��� ��� �������� ������ ������������� �������� ������������, ����������
%�������������� � ��������, �������� 3 �����������
% nAlI + nM <= nBI + nN + 1
% nV <= nM + nN + 1
% nV = nN + nAl0 + l

% nN = 1
% nM <= 1
% nM >= 1

% nN = 1
% nM = 1

% N = n1 * z + n0
% M = m1 * z + m0

% V = M * betta0 + N * alpha0 * (z - 1)^l
% z^3 = (m1 * z + m0) * (z + 1.98) + (n1 * z + n0) * (z - 1.84) * (z - 1)

% 1 = n1
% 0 = m1 - n1 - 1.84n1 + n0
% 0 = 1.98m1 + m0 + 1.84n1 - n0 - 1.84n0
% 0 = 1.98m0 + 1.84n0

n1 = 1;
n0 = 923571 / 711475;
m1 = 1097018 / 711475;
m0 = -858268 / 711475;

N = [n1 n0];
M = [m1 m0];

R = tf(conv(alphaI, M), conv(conv(bettaI, N), [1 -1]), T);

t = 0:0.1:1;
WR = feedback(R*W, 1);
subplot(2, 1, 1); step(WR, t);
Weg = feedback(1, R*W);
title('������ ���������� �������');
subplot(2, 1, 2); lsim(Weg, 2 * t + 1, t);
title('������ ������');
% ��� ��� ������� ������������, � ���������� 1 �������, �� C0 = 0,  
% C1 = T * Weg(z) / (z - 1), ��� z = 1 => e = const
[num, den] = tfdata(Weg);
num = num{1};
den = den{1};
z = 1;
% (g[lT])' = (2lT + 1)' = 2
gp = 2;
[q, r] = deconv(num, [1 -1]);
C1 = T * polyval(q, z) / polyval(den, z);
e = roundn(C1 * gp, -4);

display(e);
