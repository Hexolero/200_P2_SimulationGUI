clear ; close all; clc

data = xlsread('marathon_mapping_points.xlsx');

x = data(:,1);
y = data(:,2);

hold on;
plot(x,y, 'b-','LineWidth', 1.5)

length_lin = 0;
for k = 2:length(x)
    length_lin = length_lin + sqrt((x(k)-x(k-1))^2 + (y(k)-y(k-1))^2);
end

km_per_unit = 38.57/(sqrt(x(end)^2 + y(end)^2));
km_length = length_lin * km_per_unit;

fprintf('Length of the modelled path is %0.2f units, or %0.2f km\n', length_lin, km_length);

km = 25.0; % Input the distance travelled by the runner here
z = km/42.6;
A = 0;
bin = 1;
length = 0;

while A == 0
    p_length = sqrt((x(bin+1)-x(bin))^2 + (y(bin+1)-y(bin))^2);
    
    if ((length + p_length)/length_lin) < z
        length = length + p_length;
        bin = bin + 1;
    else
        A = 1;
    end
end

m = (y(bin+1) - y(bin))/(x(bin+1) - x(bin));
b = y(bin) - m * x(bin);

syms w
eqn = z == (length + sqrt((w - x(bin))^2 + ((m*w + b)-y(bin))^2))/length_lin;
sol_X = double(solve(eqn, w));
sol_X = sol_X(2);
sol_Y = m * sol_X + b;
check = (length + sqrt((sol_X - x(bin))^2 + (sol_Y - y(bin))^2))/length_lin;
plot(sol_X, sol_Y, 'c*', 'MarkerSize', 10);

fprintf('At %.2f km through the race, the runner is located at (%.2f, %.2f) on the modelled path.\n', km, sol_X, sol_Y);
