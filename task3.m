% y'' - 2y' + 4y = u
% u = -f(y)y
% f(y) = 2, y > 0; f(y) = -2, y <= 0

% y'' - 2y' + 4y = -f(y)y

% Сделаем замену
% x1 = y; x2 = x1'

% x2' = 2*x2 - 4*x1 - f(x1)*x1
% x1' = x2

% Разделим первое уравнение на второе
% dx2 / dx1 = 2 - 4*x1/x2 - f(x1)*x1/x2

% Если x1 > 0   => f(x1) = 2
% dx2 / dx1 = 2 - 6 * x1 / x2
% Решение:
% ln(x1) = C - ln(6 - 2*x2/x1 + x2^2/(x1^2)) / 2 + arctg((1 - x2/x1)/sqrt(5)) / sqrt(5)

% Если x1 <= 0   => f(x1) = -2
% dx2 / dx1 = 2 - 2 * x1 / x2
% Решение:
% ln(x1) = C - ln(2 - 2*x2/x1 + x2^2/(x1^2)) / 2 + arctg(1 - x2/x1)

hold on;
[x11, x21] = meshgrid(0:0.1:5, -5:0.1:5);
y1 = log(x11) + log(6 - 2.*x21./x11 + x21.^2./(x11.^2)) ./ 2 - atan((1 - x21./x11)./sqrt(5)) ./ sqrt(5);
contour(x11, x21, y1, 7);
[x12, x22] = meshgrid(-5:0.1:0, -5:0.1:5);
y2 = log(-x12) + log(2 - 2.*x22./x12 + x22.^2./(x12.^2)) ./ 2 - atan(1 - x22./x12);
contour(x12, x22, y2, 7);

[x11, x21] = meshgrid(0:1:5, -5:1:5);
[x12, x22] = meshgrid(-5:1:0, -5:1:5);
dx21 = 2*x21 - 6*x11;
dx22 = 2*x22 - 2*x12;
dx1 = x21;
quiver(x11, x21, dx1, dx21);
quiver(x12, x22, dx1, dx22);
fimplicit(@(x12) x12);
xlabel('x1');
ylabel('x2');
title('Фазовый портрет системы');

disp(0);